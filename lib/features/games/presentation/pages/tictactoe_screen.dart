import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/game_result_dialog.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<List<String>> board;
  late bool isPlayerXTurn;
  late bool gameEnded;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    board = List.generate(3, (_) => List.filled(3, ''));
    isPlayerXTurn = true;
    gameEnded = false;
  }

  void _onTileTapped(int row, int col) {
    if (board[row][col].isNotEmpty || gameEnded) return;

    setState(() {
      board[row][col] = isPlayerXTurn ? 'X' : 'O';
      isPlayerXTurn = !isPlayerXTurn;

      if (_checkWinner(row, col)) {
        gameEnded = true;
        _showGameResult(!isPlayerXTurn ? 'Joueur X' : 'Joueur O');
      } else if (_isBoardFull()) {
        gameEnded = true;
        _showGameResult(null);
      }
    });
  }

  bool _checkWinner(int row, int col) {
    final player = board[row][col];

    // Check row
    if (board[row].every((cell) => cell == player)) return true;

    // Check column
    if (board.every((row) => row[col] == player)) return true;

    // Check diagonals
    if (row == col) {
      if (List.generate(3, (i) => board[i][i]).every((cell) => cell == player)) {
        return true;
      }
    }

    if (row + col == 2) {
      if (List.generate(3, (i) => board[i][2 - i]).every((cell) => cell == player)) {
        return true;
      }
    }

    return false;
  }

  bool _isBoardFull() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void _showGameResult(String? winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameResultDialog(
        title: winner != null ? 'Victoire !' : 'Match nul !',
        message: winner != null ? '$winner a gagné !' : 'Personne n\'a gagné.',
        onRestart: () {
          Navigator.pop(context);
          setState(() {
            _initializeGame();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tic-Tac-Toe',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPlayerInfo('Joueur X', isPlayerXTurn, Colors.blue),
                Container(
                  height: 40,
                  width: 2,
                  color: Colors.grey[300],
                ),
                _buildPlayerInfo('Joueur O', !isPlayerXTurn, Colors.red),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        final row = index ~/ 3;
                        final col = index % 3;
                        return _buildTile(row, col);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _initializeGame();
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Recommencer'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(String player, bool isCurrentTurn, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrentTurn ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isCurrentTurn ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: isCurrentTurn ? color : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            player,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: isCurrentTurn ? FontWeight.bold : FontWeight.normal,
              color: isCurrentTurn ? color : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(int row, int col) {
    return InkWell(
      onTap: () => _onTileTapped(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: board[row][col].isNotEmpty
              ? (board[row][col] == 'X' ? Colors.blue.withOpacity(0.1) : Colors.red.withOpacity(0.1))
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: board[row][col].isNotEmpty
                ? (board[row][col] == 'X' ? Colors.blue.withOpacity(0.3) : Colors.red.withOpacity(0.3))
                : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            board[row][col],
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: board[row][col] == 'X' ? Colors.blue : Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
