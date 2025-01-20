import 'package:flutter/material.dart';
import 'dart:math';

enum AILevel {
  easy,
  medium,
  hard,
}

class CheckersGameScreen extends StatefulWidget {
  final bool vsComputer;
  final AILevel? aiLevel;

  const CheckersGameScreen({
    super.key,
    this.vsComputer = false,
    this.aiLevel = AILevel.medium,
  });

  @override
  State<CheckersGameScreen> createState() => _CheckersGameScreenState();
}

class _CheckersGameScreenState extends State<CheckersGameScreen> {
  late List<List<Piece?>> board;
  bool isPlayer1Turn = true;
  Piece? selectedPiece;
  List<Position> possibleMoves = [];
  bool isComputerThinking = false;
  bool gameOver = false;
  String? winner;
  int player1Pieces = 0;
  int player2Pieces = 0;

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

  void initializeBoard() {
    board = List.generate(8, (i) => List.generate(8, (j) => null));
    
    // Place black pieces (Player 1)
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 8; col++) {
        if ((row + col) % 2 == 1) {
          board[row][col] = Piece(
            isPlayer1: true,
            isKing: false,
            position: Position(row, col),
          );
        }
      }
    }
    
    // Place white pieces (Player 2)
    for (int row = 5; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if ((row + col) % 2 == 1) {
          board[row][col] = Piece(
            isPlayer1: false,
            isKing: false,
            position: Position(row, col),
          );
        }
      }
    }
  }

  List<Position> getValidMoves(Position position,
      {bool checkingCaptures = false}) {
    Piece? piece = board[position.row][position.col];
    if (piece == null || piece.isPlayer1 != isPlayer1Turn) return [];

    List<Position> moves = [];
    List<Position> captures = [];
    
    // Directions for movement (up-left, up-right, down-left, down-right)
    List<List<int>> directions = [
      [-1, -1],
      [-1, 1],
      [1, -1],
      [1, 1]
    ];

    for (var direction in directions) {
      if (!piece.isKing) {
        if ((piece.isPlayer1 && direction[0] < 0) ||
            (!piece.isPlayer1 && direction[0] > 0)) {
          continue;
        }
      }

      int newRow = position.row + direction[0];
      int newCol = position.col + direction[1];

      // Check regular move
      if (!checkingCaptures &&
          isValidPosition(newRow, newCol) &&
          board[newRow][newCol] == null) {
        moves.add(Position(newRow, newCol));
      }
      
      // Check capture move
      if (isValidPosition(newRow, newCol) &&
          board[newRow][newCol] != null &&
          board[newRow][newCol]!.isPlayer1 != piece.isPlayer1) {
        int jumpRow = newRow + direction[0];
        int jumpCol = newCol + direction[1];
        if (isValidPosition(jumpRow, jumpCol) &&
            board[jumpRow][jumpCol] == null) {
          captures.add(Position(jumpRow, jumpCol));
        }
      }
    }

    if (checkingCaptures) {
      return captures;
    }

    // If there are captures available, only return captures
    if (hasCaptureMoves()) {
      return captures;
    }
    
    return captures.isNotEmpty ? captures : moves;
  }

  bool isValidPosition(int row, int col) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
  }

  bool hasCaptureMoves() {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        Piece? piece = board[row][col];
        if (piece != null && piece.isPlayer1 == isPlayer1Turn) {
          List<Position> captures =
              getValidMoves(Position(row, col), checkingCaptures: true);
          if (captures.isNotEmpty) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void onTileTap(int row, int col) {
    if (!mounted) return;

    setState(() {
      Position tappedPosition = Position(row, col);

      // If a piece is already selected
      if (selectedPiece != null) {
        // Check if the tapped position is a valid move
        if (possibleMoves.any((pos) => pos.row == row && pos.col == col)) {
          movePiece(selectedPiece!.position, tappedPosition);
        } else {
          // If tapping on another piece of the same player, select it
          Piece? newPiece = board[row][col];
          if (newPiece != null && newPiece.isPlayer1 == isPlayer1Turn) {
            selectedPiece = newPiece;
            possibleMoves = getValidMoves(tappedPosition);
          } else {
            // Otherwise, deselect
            selectedPiece = null;
            possibleMoves = [];
          }
        }
      } else {
        // Try to select a piece
        Piece? piece = board[row][col];
        if (piece != null && piece.isPlayer1 == isPlayer1Turn) {
          selectedPiece = piece;
          possibleMoves = getValidMoves(tappedPosition);
        }
      }
    });
  }

  void movePiece(Position from, Position to) {
    // Move the piece
    Piece movedPiece = board[from.row][from.col]!;
    movedPiece.position = to;
    board[to.row][to.col] = movedPiece;
    board[from.row][from.col] = null;
    
    // Check if piece becomes king
    if ((to.row == 0 && !movedPiece.isPlayer1) ||
        (to.row == 7 && movedPiece.isPlayer1)) {
      movedPiece.isKing = true;
    }
    
    bool madeCapture = false;
    // Handle capture
    if ((to.row - from.row).abs() == 2) {
      int capturedRow = (from.row + to.row) ~/ 2;
      int capturedCol = (from.col + to.col) ~/ 2;
      board[capturedRow][capturedCol] = null;
      madeCapture = true;

      // Check if there are other captures possible for the same piece
      List<Position> additionalCaptures =
          getValidMoves(to, checkingCaptures: true);
      
      if (additionalCaptures.isNotEmpty) {
        // If there are other captures possible, do not change turn
        selectedPiece = movedPiece;
        possibleMoves = additionalCaptures;
        setState(() {});
        return;
      }
    }
    
    // Change turn
    selectedPiece = null;
    possibleMoves = [];
    isPlayer1Turn = !isPlayer1Turn;

    // Vérifier la fin de partie après chaque coup
    checkGameOver();

    // Si le jeu n'est pas terminé, continuer avec le tour de l'ordinateur
    if (!gameOver && widget.vsComputer && !isPlayer1Turn) {
      makeComputerMove();
    }
  }

  void makeComputerMove() async {
    setState(() {
      isComputerThinking = true;
    });

    // Wait a bit to give the impression that the computer is thinking
    await Future.delayed(const Duration(milliseconds: 500));

    // Find the best move
    Move bestMove = findBestMove();

    // Make the move
    if (bestMove.from != null && bestMove.to != null) {
      movePiece(bestMove.from!, bestMove.to!);
    }

    setState(() {
      isComputerThinking = false;
    });
  }

  bool hasValidMoves(bool forPlayer1) {
    // Vérifier si le joueur a au moins un mouvement valide
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        Piece? piece = board[row][col];
        if (piece != null && piece.isPlayer1 == forPlayer1) {
          List<Position> moves = getValidMoves(Position(row, col));
          if (moves.isNotEmpty) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void checkGameOver() {
    // Compter les pièces
    player1Pieces = 0;
    player2Pieces = 0;
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        Piece? piece = board[row][col];
        if (piece != null) {
          if (piece.isPlayer1) {
            player1Pieces++;
          } else {
            player2Pieces++;
          }
        }
      }
    }

    // Vérifier si un joueur n'a plus de pièces
    if (player1Pieces == 0) {
      setState(() {
        gameOver = true;
        winner = "Blanc"; // Le joueur blanc gagne car plus de pièces noires
      });
      showGameOverDialog();
      return;
    }
    if (player2Pieces == 0) {
      setState(() {
        gameOver = true;
        winner = "Noir"; // Le joueur noir gagne car plus de pièces blanches
      });
      showGameOverDialog();
      return;
    }

    // Vérifier si le joueur actuel peut bouger
    bool currentPlayerCanMove = hasValidMoves(isPlayer1Turn);
    if (!currentPlayerCanMove) {
      setState(() {
        gameOver = true;
        winner = isPlayer1Turn
            ? "Blanc"
            : "Noir"; // Le joueur qui ne peut pas bouger perd
      });
      showGameOverDialog();
    }
  }

  void showGameOverDialog() {
    String victoryReason = "";
    if (player1Pieces == 0) {
      victoryReason = "Toutes les pièces noires ont été capturées !";
    } else if (player2Pieces == 0) {
      victoryReason = "Toutes les pièces blanches ont été capturées !";
    } else {
      victoryReason = winner == "Noir"
          ? "Les pièces blanches sont bloquées !"
          : "Les pièces noires sont bloquées !";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Fin de la partie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Le joueur $winner a gagné !"),
            const SizedBox(height: 10),
            Text(victoryReason),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text("Pions noirs"),
                    Text("$player1Pieces",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    const Text("Pions blancs"),
                    Text("$player2Pieces",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Voulez-vous rejouer ?"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Menu principal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                initializeBoard();
                gameOver = false;
                winner = null;
                isPlayer1Turn = true;
                selectedPiece = null;
                possibleMoves = [];
                player1Pieces = 0;
                player2Pieces = 0;
              });
            },
            child: const Text('Rejouer'),
          ),
        ],
      ),
    );
  }

  Move findBestMove() {
    if (widget.aiLevel == AILevel.easy) {
      // En mode facile, choisir un coup aléatoire parmi les coups valides
      List<Move> possibleMoves = [];
      for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 8; col++) {
          Piece? piece = board[row][col];
          if (piece != null && piece.isPlayer1 == isPlayer1Turn) {
            Position from = Position(row, col);
            List<Position> moves = getValidMoves(from);
            for (Position to in moves) {
              possibleMoves.add(Move(from, to));
            }
          }
        }
      }
      if (possibleMoves.isNotEmpty) {
        return possibleMoves[Random().nextInt(possibleMoves.length)];
      }
      return Move(null, null);
    }

    // Pour les niveaux moyen et difficile, utiliser l'algorithme minimax
    int depth = widget.aiLevel == AILevel.hard ? 4 : 2;
    int bestValue = -1000;
    Move bestMove = Move(null, null);

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        Piece? piece = board[row][col];
        if (piece != null && piece.isPlayer1 == isPlayer1Turn) {
          Position from = Position(row, col);
          List<Position> moves = getValidMoves(from);

          for (Position to in moves) {
            Move move = Move(from, to);
            List<List<Piece?>> tempBoard = copyBoard();
            makeMove(move, tempBoard);

            int moveValue = minimax(tempBoard, depth - 1, false, -1000, 1000);

            if (moveValue > bestValue) {
              bestValue = moveValue;
              bestMove = move;
            }
          }
        }
      }
    }

    return bestMove;
  }

  int minimax(List<List<Piece?>> tempBoard, int depth, bool isMaximizing,
      int alpha, int beta) {
    if (depth == 0) {
      return evaluateBoard(tempBoard);
    }

    if (isMaximizing) {
      int maxEval = -1000;
      for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 8; col++) {
          Piece? piece = tempBoard[row][col];
          if (piece != null && piece.isPlayer1 == isPlayer1Turn) {
            Position from = Position(row, col);
            List<Position> moves = getValidMoves(from);
            for (Position to in moves) {
              List<List<Piece?>> newBoard = copyBoard();
              makeMove(Move(from, to), newBoard);
              int eval = minimax(newBoard, depth - 1, false, alpha, beta);
              maxEval = max(maxEval, eval);
              alpha = max(alpha, eval);
              if (beta <= alpha) break;
            }
          }
        }
      }
      return maxEval;
    } else {
      int minEval = 1000;
      for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 8; col++) {
          Piece? piece = tempBoard[row][col];
          if (piece != null && piece.isPlayer1 != isPlayer1Turn) {
            Position from = Position(row, col);
            List<Position> moves = getValidMoves(from);
            for (Position to in moves) {
              List<List<Piece?>> newBoard = copyBoard();
              makeMove(Move(from, to), newBoard);
              int eval = minimax(newBoard, depth - 1, true, alpha, beta);
              minEval = min(minEval, eval);
              beta = min(beta, eval);
              if (beta <= alpha) break;
            }
          }
        }
      }
      return minEval;
    }
  }

  List<List<Piece?>> copyBoard() {
    return List.generate(8, (row) {
      return List.generate(8, (col) {
        if (board[row][col] == null) return null;
        return Piece(
          isPlayer1: board[row][col]!.isPlayer1,
          isKing: board[row][col]!.isKing,
          position: Position(row, col),
        );
      });
    });
  }

  void makeMove(Move move, List<List<Piece?>> tempBoard) {
    if (move.from == null || move.to == null) return;

    // Move the piece
    Piece movedPiece = tempBoard[move.from!.row][move.from!.col]!;
    tempBoard[move.to!.row][move.to!.col] = movedPiece;
    tempBoard[move.from!.row][move.from!.col] = null;

    // Handle capture
    if ((move.to!.row - move.from!.row).abs() == 2) {
      int capturedRow = (move.from!.row + move.to!.row) ~/ 2;
      int capturedCol = (move.from!.col + move.to!.col) ~/ 2;
      tempBoard[capturedRow][capturedCol] = null;
    }
  }

  int evaluateBoard(List<List<Piece?>> tempBoard) {
    int score = 0;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        Piece? piece = tempBoard[row][col];
        if (piece != null) {
          int pieceValue = piece.isKing ? 3 : 1;

          // Position bonus
          if (!piece.isKing) {
            if (piece.isPlayer1) {
              // Bonus for moving down
              pieceValue += row;
            } else {
              // Bonus for moving up
              pieceValue += (7 - row);
            }
          }

          // Bonus for central positions
          if ((col == 3 || col == 4) && (row == 3 || row == 4)) {
            pieceValue += 2;
          }

          // Add or subtract depending on the owner
          if (piece.isPlayer1 == isPlayer1Turn) {
            score += pieceValue;
          } else {
            score -= pieceValue;
          }
        }
      }
    }

    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isComputerThinking
            ? 'L\'ordinateur réfléchit...'
            : gameOver
                ? 'Fin de la partie'
                : 'Jeu de Dames - ${isPlayer1Turn ? "Noir" : "Blanc"}'),
        actions: [
          if (!gameOver)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Abandonner ?'),
                    content: const Text(
                        'Voulez-vous vraiment abandonner la partie ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Non'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            gameOver = true;
                            winner = isPlayer1Turn ? "Blanc" : "Noir";
                          });
                          showGameOverDialog();
                        },
                        child: const Text('Oui'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Abandonner',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Column(
        children: [
          if (widget.vsComputer)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                isPlayer1Turn ? 'Votre tour' : 'Tour de l\'ordinateur',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                    ),
                    itemCount: 64,
                    itemBuilder: (context, index) {
                      final row = index ~/ 8;
                      final col = index % 8;
                      final isBlackSquare = (row + col) % 2 == 1;
                      final piece = board[row][col];
                      final isSelected = selectedPiece?.position.row == row &&
                          selectedPiece?.position.col == col;
                      final isValidMove = possibleMoves
                          .any((pos) => pos.row == row && pos.col == col);

                      return GestureDetector(
                        onTap: () {
                          if (!widget.vsComputer || isPlayer1Turn) {
                            onTileTap(row, col);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue
                                : isValidMove
                                    ? Colors.blue.withOpacity(0.5)
                                    : isBlackSquare
                                        ? Colors.brown
                                        : Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: piece != null
                              ? Center(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: piece.isPlayer1
                                          ? Colors.black
                                          : Colors.white,
                                      border: Border.all(
                                        color: piece.isPlayer1
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    child: piece.isKing
                                        ? Icon(
                                            Icons.stars,
                                            color: piece.isPlayer1
                                                ? Colors.white
                                                : Colors.black,
                                          )
                                        : null,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Position {
  int row;
  int col;

  Position(this.row, this.col);
}

class Piece {
  bool isPlayer1;
  bool isKing;
  Position position;

  Piece({
    required this.isPlayer1,
    required this.isKing,
    required this.position,
  });
}

class Move {
  final Position? from;
  final Position? to;

  Move(this.from, this.to);
}
