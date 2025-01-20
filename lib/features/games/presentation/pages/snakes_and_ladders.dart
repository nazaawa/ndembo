import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnakesAndLaddersScreen extends StatefulWidget {
  const SnakesAndLaddersScreen({super.key});

  @override
  State<SnakesAndLaddersScreen> createState() => _SnakesAndLaddersScreenState();
}

class _SnakesAndLaddersScreenState extends State<SnakesAndLaddersScreen>
    with SingleTickerProviderStateMixin {
  int currentPlayer = 1;
  int diceNumber = 1;
  List<int> playerPositions = [0, 0];
  final int winningPosition = 100;
  bool gameEnded = false;
  bool isRolling = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  // Définition des cases spéciales (snakes and ladders inclus)
  final Map<int, SpecialCell> specialCells = {
    3: SpecialCell(
        type: CellType.ladder, value: 22, message: "Monte à la case 25!"),
    5: SpecialCell(
        type: CellType.bonus, value: 2, message: "Avance de 2 cases!"),
    11: SpecialCell(
        type: CellType.snake,
        value: -9,
        message: "Oh non, descends à la case 2!"),
    17: SpecialCell(
        type: CellType.ladder, value: 10, message: "Monte à la case 27!"),
    19: SpecialCell(
        type: CellType.malus, value: -5, message: "Recule de 5 cases!"),
    22: SpecialCell(
        type: CellType.snake, value: -17, message: "Descends à la case 5!"),
    56: SpecialCell(
        type: CellType.teleport,
        value: 78,
        message: "Téléportation à la case 78!"),
    99: SpecialCell(
        type: CellType.snake,
        value: -20,
        message: "Oh non! Retour à la case 79!"),
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.addListener(() {
      if (isRolling) {
        setState(() {
          diceNumber = Random().nextInt(6) + 1;
        });
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isRolling = false;
        applyMove();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void rollDice() {
    if (gameEnded || isRolling) return;

    setState(() {
      isRolling = true;
    });

    _controller.reset();
    _controller.forward();
  }

  void applyMove() {
    setState(() {
      int playerIndex = currentPlayer - 1;
      int newPosition = playerPositions[playerIndex] + diceNumber;

      // Vérifier les cases spéciales
      if (specialCells.containsKey(newPosition)) {
        final specialCell = specialCells[newPosition]!;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(specialCell.message),
            duration: const Duration(seconds: 2),
          ),
        );

        if (specialCell.type == CellType.teleport ||
            specialCell.type == CellType.snake ||
            specialCell.type == CellType.ladder) {
          newPosition = specialCell.value;
        } else {
          newPosition += specialCell.value;
        }
      }

      // S'assurer que la position reste dans les limites
      newPosition = newPosition.clamp(0, winningPosition);
      playerPositions[playerIndex] = newPosition;

      checkWinner();
      if (!gameEnded) {
        currentPlayer = currentPlayer == 1 ? 2 : 1;
      }
    });
  }

  void checkWinner() {
    if (playerPositions[currentPlayer - 1] >= winningPosition) {
      gameEnded = true;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('🎉 Partie terminée!'),
          content: Text('Joueur $currentPlayer a gagné!'),
          actions: [
            TextButton(
              onPressed: resetGame,
              child: const Text('Nouvelle partie'),
            ),
          ],
        ),
      );
    }
  }

  void resetGame() {
    setState(() {
      currentPlayer = 1;
      diceNumber = 1;
      playerPositions = [0, 0];
      gameEnded = false;
    });
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
          'Serpents et Échelles',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: resetGame,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPlayerInfo(1, Colors.blue),
                Container(
                  height: 40,
                  width: 2,
                  color: Colors.grey[300],
                ),
                _buildPlayerInfo(2, Colors.red),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue[50]!,
                    Colors.blue[100]!,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildGameBoard(),
                    const SizedBox(height: 20),
                    _buildDiceSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(int player, Color color) {
    bool isCurrentPlayer = currentPlayer == player;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrentPlayer ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Joueur $player',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: isCurrentPlayer ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Position: ${playerPositions[player - 1]}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiceSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Text(
            'Tour du Joueur $currentPlayer',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: currentPlayer == 1 ? Colors.blue : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value * 4 * pi,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      diceNumber.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isRolling ? null : rollDice,
            style: ElevatedButton.styleFrom(
              backgroundColor: currentPlayer == 1 ? Colors.blue : Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              isRolling ? 'Lancement...' : 'Lancer le dé',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGameBoard() {
    return Container(
      margin: const EdgeInsets.all(20),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: winningPosition + 1,
          itemBuilder: (context, index) {
            bool hasPlayer1 = playerPositions[0] == index;
            bool hasPlayer2 = playerPositions[1] == index;
            bool isSpecial = specialCells.containsKey(index);
            
            return Container(
              decoration: BoxDecoration(
                color: isSpecial
                    ? _getCellColor(specialCells[index]!.type)
                    : Colors.grey[100],
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      index.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (hasPlayer1)
                    const Positioned(
                      top: 2,
                      left: 2,
                      child: Icon(
                        Icons.circle,
                        color: Colors.blue,
                        size: 14,
                      ),
                    ),
                  if (hasPlayer2)
                    const Positioned(
                      bottom: 2,
                      right: 2,
                      child: Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: 14,
                      ),
                    ),
                  if (isSpecial)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(
                        _getCellIcon(specialCells[index]!.type),
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getCellColor(CellType type) {
    switch (type) {
      case CellType.bonus:
        return Colors.green[300]!;
      case CellType.malus:
        return Colors.red[300]!;
      case CellType.ladder:
        return Colors.blue[300]!;
      case CellType.snake:
        return Colors.orange[300]!;
      case CellType.teleport:
        return Colors.purple[300]!;
    }
  }

  IconData _getCellIcon(CellType type) {
    switch (type) {
      case CellType.bonus:
        return Icons.add_circle;
      case CellType.malus:
        return Icons.remove_circle;
      case CellType.ladder:
        return Icons.arrow_upward;
      case CellType.snake:
        return Icons.arrow_downward;
      case CellType.teleport:
        return Icons.swap_horiz;
    }
  }
}

// Types de cases spéciales
enum CellType { bonus, malus, ladder, snake, teleport }

class SpecialCell {
  final CellType type;
  final int value;
  final String message;

  SpecialCell({
    required this.type,
    required this.value,
    required this.message,
  });
}
