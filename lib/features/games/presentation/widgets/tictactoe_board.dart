import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicTacToeBoard extends StatelessWidget {
  final List<List<String>> board;
  final Function(int, int) onTileTapped;

  const TicTacToeBoard({
    super.key,
    required this.board,
    required this.onTileTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            physics: const NeverScrollableScrollPhysics(),
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
    );
  }

  Widget _buildTile(int row, int col) {
    return GestureDetector(
      onTap: () => onTileTapped(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
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
