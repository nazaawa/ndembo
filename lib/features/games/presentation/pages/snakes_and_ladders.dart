import 'dart:math';
import 'package:flutter/material.dart';

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

  Widget buildGameBoard() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 400,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
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
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black26,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    index.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (hasPlayer1)
                  const Positioned(
                    top: 4,
                    left: 4,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 10,
                      child: Text('1',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                if (hasPlayer2)
                  const Positioned(
                    bottom: 4,
                    right: 4,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 10,
                      child: Text('2',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getCellColor(CellType type) {
    switch (type) {
      case CellType.bonus:
        return Colors.green[200]!;
      case CellType.malus:
        return Colors.red[200]!;
      case CellType.ladder:
        return Colors.blue[200]!;
      case CellType.snake:
        return Colors.orange[200]!;
      case CellType.teleport:
        return Colors.purple[200]!;
    }
  }

  Widget buildDice() {
    return Transform.rotate(
      angle: _animation.value * 4 * pi,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, _animation.value * 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            diceNumber.toString(),
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snakes & Ladders'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                gameEnded
                    ? 'Joueur $currentPlayer a gagné!'
                    : 'Tour du Joueur $currentPlayer',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              buildGameBoard(),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => buildDice(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: gameEnded || isRolling ? null : rollDice,
                child: Text(isRolling ? 'Lancement...' : 'Lancer le dé'),
              ),
            ],
          ),
        ),
      ),
    );
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
