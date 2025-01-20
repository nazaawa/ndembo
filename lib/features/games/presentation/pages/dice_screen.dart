import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red[300]!,
              Colors.red[700]!,
            ],
          ),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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

  Widget _buildScoreCard(String label, int score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
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
          'Dés',
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
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreCard('Joueur 1', player1Score, Colors.blue),
                Container(
                  height: 40,
                  width: 2,
                  color: Colors.grey[300],
                ),
                _buildScoreCard('Joueur 2', player2Score, Colors.green),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildDice(dice1),
                      const SizedBox(width: 24),
                      buildDice(dice2),
                    ],
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: (isRolling ||
                            (currentPlayer == 1 && player1Bet.isEmpty) ||
                            (currentPlayer == 2 && player2Bet.isEmpty))
                        ? null
                        : rollDice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.casino),
                        const SizedBox(width: 8),
                        Text(
                          'Lancer les dés',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
          ),
        ],
      ),
    );
  }
}
