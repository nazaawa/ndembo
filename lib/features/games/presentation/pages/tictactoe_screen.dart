import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/tictactoe_board.dart';
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () {
              setState(() {
                _initializeGame();
              });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isPlayerXTurn ? 'Tour du Joueur X' : 'Tour du Joueur O',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 40),
          TicTacToeBoard(
            board: board,
            onTileTapped: _onTileTapped,
          ),
        ],
      ),
    );
  }
}
