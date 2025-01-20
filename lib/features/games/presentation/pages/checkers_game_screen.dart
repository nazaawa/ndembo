import 'package:flutter/material.dart';

class CheckersGameScreen extends StatefulWidget {
  const CheckersGameScreen({super.key});

  @override
  State<CheckersGameScreen> createState() => _CheckersGameScreenState();
}

class _CheckersGameScreenState extends State<CheckersGameScreen> {
  late List<List<Piece?>> board;
  bool isPlayer1Turn = true;
  Piece? selectedPiece;
  List<Position> possibleMoves = [];
  bool mustCapture = false;

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
    
    // Handle capture
    if ((to.row - from.row).abs() == 2) {
      int capturedRow = (from.row + to.row) ~/ 2;
      int capturedCol = (from.col + to.col) ~/ 2;
      board[capturedRow][capturedCol] = null;

      // Check if there are other captures possible for the same piece
      List<Position> additionalCaptures = getValidMoves(to).where((pos) {
        int rowDiff = (pos.row - to.row).abs();
        return rowDiff == 2;
      }).toList();
      
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu de Dames - ${isPlayer1Turn ? "Noir" : "Blanc"}'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  onTap: () => onTileTap(row, col),
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
