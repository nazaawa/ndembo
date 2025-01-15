import 'package:flutter/material.dart';

class CheckersGameScreen extends StatefulWidget {
  const CheckersGameScreen({super.key});

  @override
  State<CheckersGameScreen> createState() => _CheckersGameScreenState();
}

class _CheckersGameScreenState extends State<CheckersGameScreen>
    with SingleTickerProviderStateMixin {
  static const int boardSize = 8;
  late List<List<String?>> board;
  String currentPlayer = 'black';
  int? selectedRow;
  int? selectedCol;
  List<List<bool>> validMoves =
      List.generate(boardSize, (_) => List.generate(boardSize, (_) => false));
  bool isMidCapture = false;
  late AnimationController _animationController;
  Offset? _animationOffset;
  String? _animatedPiece;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _initializeBoard() {
    board =
        List.generate(boardSize, (_) => List.generate(boardSize, (_) => null));

    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if ((row + col) % 2 == 1 && row < 3) {
          board[row][col] = 'black';
        } else if ((row + col) % 2 == 1 && row > 4) {
          board[row][col] = 'white';
        }
      }
    }
    _calculateValidMoves();
  }

  bool isValidMove(int fromRow, int fromCol, int toRow, int toCol) {
    if (toRow < 0 || toRow >= boardSize || toCol < 0 || toCol >= boardSize) {
      return false;
    }
    if (board[toRow][toCol] != null) return false;

    int rowDiff = (toRow - fromRow).abs();
    int colDiff = (toCol - fromCol).abs();

    String piece = board[fromRow][fromCol]!;
    bool isKing = piece.endsWith('_king');

    // Pour les pions simples, vérifier la direction
    if (!isKing) {
      if (piece == 'black' && toRow <= fromRow) {
        return false; // Les pions noirs ne peuvent pas reculer
      }
      if (piece == 'white' && toRow >= fromRow) {
        return false; // Les pions blancs ne peuvent pas reculer
      }
    }

    if (rowDiff == 1 && colDiff == 1 && !isMidCapture && !_hasCaptureMoves()) {
      return true;
    } else if (rowDiff == 2 && colDiff == 2) {
      int middleRow = (fromRow + toRow) ~/ 2;
      int middleCol = (fromCol + toCol) ~/ 2;
      String? middlePiece = board[middleRow][middleCol];
      if (middlePiece != null && middlePiece != board[fromRow][fromCol]) {
        return true;
      }
    }
    return false;
  }

  void movePiece(int fromRow, int fromCol, int toRow, int toCol) {
    setState(() {
      _isAnimating = true;
      _animatedPiece = board[fromRow][fromCol];
      _animationOffset =
          Offset((toCol - fromCol).toDouble(), (toRow - fromRow).toDouble());
      _animationController.forward().then((_) {
        setState(() {
          _isAnimating = false;
          board[toRow][toCol] = board[fromRow][fromCol];
          board[fromRow][fromCol] = null;

          // Gestion de la prise
          int rowDiff = (toRow - fromRow).abs();
          if (rowDiff == 2) {
            int middleRow = (fromRow + toRow) ~/ 2;
            int middleCol = (fromCol + toCol) ~/ 2;
            board[middleRow][middleCol] = null;

            // Vérifier si une autre prise est possible
            isMidCapture = _canCaptureAgain(toRow, toCol);
            if (isMidCapture) {
              selectedRow = toRow;
              selectedCol = toCol;
              _calculateValidMoves();
              return;
            }
          }

          // Promotion en dame
          if (toRow == 0 && board[toRow][toCol] == 'white') {
            board[toRow][toCol] = 'white_king';
          } else if (toRow == boardSize - 1 && board[toRow][toCol] == 'black') {
            board[toRow][toCol] = 'black_king';
          }

          // Fin du tour
          isMidCapture = false;
          selectedRow = null;
          selectedCol = null;
          currentPlayer = currentPlayer == 'black' ? 'white' : 'black';
          _calculateValidMoves();

          // Vérifier la fin de partie
          if (_isGameOver()) {
            _showGameOverDialog();
          }
        });
      });
    });
  }

  bool _canCaptureAgain(int row, int col) {
    String piece = board[row][col]!;
    bool isKing = piece.endsWith('_king');

    List<int> rowDirections = isKing
        ? [-1, 1]
        : (piece == 'black'
            ? [1]
            : [-1]); // Seulement vers l'avant pour les pions simples
    for (int rowDir in rowDirections) {
      for (int colDir in [-1, 1]) {
        int newRow = row + 2 * rowDir;
        int newCol = col + 2 * colDir;
        if (newRow >= 0 &&
            newRow < boardSize &&
            newCol >= 0 &&
            newCol < boardSize) {
          int middleRow = row + rowDir;
          int middleCol = col + colDir;
          String? middlePiece = board[middleRow][middleCol];
          if (middlePiece != null &&
              middlePiece != board[row][col] &&
              board[newRow][newCol] == null) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool _hasCaptureMoves() {
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (board[row][col] != null &&
            board[row][col]!.startsWith(currentPlayer)) {
          if (_calculateMovesForPiece(row, col,
              checkOnly: true, checkCapturesOnly: true)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool _isGameOver() {
    bool blackHasPieces = false;
    bool whiteHasPieces = false;
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (board[row][col] != null) {
          if (board[row][col]!.startsWith('black')) {
            blackHasPieces = true;
          } else if (board[row][col]!.startsWith('white')) {
            whiteHasPieces = true;
          }
        }
      }
    }
    if (!blackHasPieces || !whiteHasPieces) {
      return true;
    }

    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (board[row][col] != null &&
            board[row][col]!.startsWith(currentPlayer)) {
          if (_calculateMovesForPiece(row, col, checkOnly: true)) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Fin de partie'),
          content: Text(
              'Le joueur ${currentPlayer == 'black' ? 'Noir' : 'Blanc'} a gagné !'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _initializeBoard();
                });
              },
              child: const Text('Rejouer'),
            ),
          ],
        );
      },
    );
  }

  void _calculateValidMoves() {
    validMoves =
        List.generate(boardSize, (_) => List.generate(boardSize, (_) => false));
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (board[row][col] == currentPlayer ||
            board[row][col] == '${currentPlayer}_king') {
          _calculateMovesForPiece(row, col);
        }
      }
    }
  }

  bool _calculateMovesForPiece(int row, int col,
      {bool checkOnly = false, bool checkCapturesOnly = false}) {
    String piece = board[row][col]!;
    bool isKing = piece.endsWith('_king');

    List<int> rowDirections = isKing
        ? [-1, 1]
        : (piece == 'black'
            ? [1]
            : [-1]); // Seulement vers l'avant pour les pions simples
    bool hasValidMoves = false;

    for (int rowDir in rowDirections) {
      for (int colDir in [-1, 1]) {
        int newRow = row + rowDir;
        int newCol = col + colDir;
        if (newRow >= 0 &&
            newRow < boardSize &&
            newCol >= 0 &&
            newCol < boardSize) {
          if (board[newRow][newCol] == null &&
              !isMidCapture &&
              !checkCapturesOnly) {
            if (!checkOnly) validMoves[newRow][newCol] = true;
            hasValidMoves = true;
          } else if (board[newRow][newCol] != null &&
              board[newRow][newCol]!
                  .startsWith(currentPlayer == 'black' ? 'white' : 'black')) {
            int jumpRow = newRow + rowDir;
            int jumpCol = newCol + colDir;
            if (jumpRow >= 0 &&
                jumpRow < boardSize &&
                jumpCol >= 0 &&
                jumpCol < boardSize &&
                board[jumpRow][jumpCol] == null) {
              if (!checkOnly) validMoves[jumpRow][jumpCol] = true;
              hasValidMoves = true;
            }
          }
        }
      }
    }
    return hasValidMoves;
  }

  void onTileTapped(int row, int col) {
    if (_isAnimating) return;

    if (selectedRow == null || selectedCol == null) {
      // Sélectionner une pièce
      if (board[row][col] != null &&
          board[row][col]!.startsWith(currentPlayer)) {
        setState(() {
          selectedRow = row;
          selectedCol = col;
          _calculateValidMoves();
        });
      }
    } else {
      // Déplacer la pièce
      if (validMoves[row][col]) {
        movePiece(selectedRow!, selectedCol!, row, col);
      } else {
        // Annuler la sélection si le mouvement est invalide
        setState(() {
          selectedRow = null;
          selectedCol = null;
          _calculateValidMoves();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeu de Dames'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tour du joueur : ${currentPlayer == 'black' ? 'Noir' : 'Blanc'}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: boardSize,
              ),
              itemCount: boardSize * boardSize,
              itemBuilder: (context, index) {
                int row = index ~/ boardSize;
                int col = index % boardSize;

                bool isSelected = selectedRow == row && selectedCol == col;
                bool isDarkTile = (row + col) % 2 == 1;
                bool isValidMove = validMoves[row][col];

                return GestureDetector(
                  onTap: () => onTileTapped(row, col),
                  child: Container(
                    color: isDarkTile ? Colors.brown : Colors.white,
                    child: Center(
                      child: Stack(
                        children: [
                          if (isSelected)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.yellow.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                          if (isValidMove)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                          if (board[row][col] != null && !_isAnimating)
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: board[row][col]!.startsWith('black')
                                    ? Colors.black
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black, width: 2),
                              ),
                              child: board[row][col]!.endsWith('_king')
                                  ? const Icon(Icons.star,
                                      color: Colors.yellow, size: 20)
                                  : null,
                            ),
                          if (_isAnimating &&
                              _animatedPiece != null &&
                              selectedRow == row &&
                              selectedCol == col)
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              left: _animationOffset!.dx *
                                  (MediaQuery.of(context).size.width /
                                      boardSize),
                              top: _animationOffset!.dy *
                                  (MediaQuery.of(context).size.width /
                                      boardSize),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _animatedPiece!.startsWith('black')
                                      ? Colors.black
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                ),
                                child: _animatedPiece!.endsWith('_king')
                                    ? const Icon(Icons.star,
                                        color: Colors.yellow, size: 20)
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _initializeBoard();
                currentPlayer = 'black';
                selectedRow = null;
                selectedCol = null;
                _calculateValidMoves();
              });
            },
            child: const Text("Réinitialiser la partie"),
          ),
        ],
      ),
    );
  }
}
