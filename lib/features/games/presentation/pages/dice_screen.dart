import 'dart:math';
import 'package:flutter/material.dart';

class DiceGameScreen extends StatefulWidget {
  const DiceGameScreen({super.key});

  @override
  State<DiceGameScreen> createState() => _DiceGameScreenState();
}

class _DiceGameScreenState extends State<DiceGameScreen>
    with SingleTickerProviderStateMixin {
  final Random random = Random();
  int dice1 = 1;
  int dice2 = 1;
  bool isRolling = false;
  bool gameEnded = false;

  late AnimationController _animationController;
  late Animation<double> _diceAnimation;

  // Gestion des joueurs
  int currentPlayer = 1;
  String player1Bet = "";
  String player2Bet = "";
  int player1Score = 0;
  int player2Score = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _diceAnimation = Tween<double>(begin: 0, end: pi * 2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void rollDice() {
    if (isRolling) return;

    setState(() {
      isRolling = true;
    });

    _animationController.forward(from: 0).whenComplete(() {
      setState(() {
        dice1 = random.nextInt(6) + 1;
        dice2 = random.nextInt(6) + 1;
        isRolling = false;
        evaluateResult();
      });
    });
  }

  void evaluateResult() {
    int sum = dice1 + dice2;
    String diceSumResult = sum % 2 == 0 ? "pair" : "impair";

    String currentBet = currentPlayer == 1 ? player1Bet : player2Bet;

    if (currentBet == diceSumResult || currentBet == sum.toString()) {
      setState(() {
        if (currentPlayer == 1) {
          player1Score += 1;
        } else {
          player2Score += 1;
        }
      });
    }

    // Passer au joueur suivant
    setState(() {
      if (currentPlayer == 1) {
        currentPlayer = 2;
      } else {
        currentPlayer = 1;
        gameEnded = true; // Fin du tour
      }
    });
  }

  void resetGame() {
    setState(() {
      dice1 = 1;
      dice2 = 1;
      player1Bet = "";
      player2Bet = "";
      player1Score = 0;
      player2Score = 0;
      currentPlayer = 1;
      gameEnded = false;
    });
  }

  Widget buildDice(int number) {
    return AnimatedBuilder(
      animation: _diceAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _diceAnimation.value,
          child: child,
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBettingOptions() {
    String currentBet = currentPlayer == 1 ? player1Bet : player2Bet;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Joueur $currentPlayer : Choisissez votre pari",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildBetButton("pair", currentBet),
            _buildBetButton("impair", currentBet),
            for (int i = 2; i <= 12; i++)
              _buildBetButton(i.toString(), currentBet),
          ],
        ),
      ],
    );
  }

  Widget _buildBetButton(String bet, String currentBet) {
    bool isSelected = currentBet == bet;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () {
        if (isRolling || gameEnded) return;

        setState(() {
          if (currentPlayer == 1) {
            player1Bet = bet;
          } else {
            player2Bet = bet;
          }
        });
      },
      child: Text(bet),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeu de dés - Deux joueurs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              gameEnded
                  ? "Partie terminée !\nScores - Joueur 1 : $player1Score | Joueur 2 : $player2Score"
                  : "Joueur $currentPlayer : Placez votre pari",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDice(dice1),
                const SizedBox(width: 10),
                buildDice(dice2),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (isRolling ||
                      (currentPlayer == 1 && player1Bet.isEmpty) ||
                      (currentPlayer == 2 && player2Bet.isEmpty))
                  ? null
                  : rollDice,
              child: isRolling
                  ? const Text("Lancement...")
                  : const Text("Lancer les dés"),
            ),
            const SizedBox(height: 20),
            buildBettingOptions(),
            const SizedBox(height: 20),
            if (gameEnded)
              ElevatedButton(
                onPressed: resetGame,
                child: const Text("Nouvelle partie"),
              ),
          ],
        ),
      ),
    );
  }
}
