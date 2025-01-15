import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RockPaperScissorsScreen extends StatefulWidget {
  const RockPaperScissorsScreen({super.key});

  @override
  State<RockPaperScissorsScreen> createState() => _RockPaperScissorsScreenState();
}

class _RockPaperScissorsScreenState extends State<RockPaperScissorsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  
  String? playerChoice;
  String? computerChoice;
  String? result;
  int playerScore = 0;
  int computerScore = 0;

  final List<String> choices = ['Pierre', 'Papier', 'Ciseaux'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _play(String choice) {
    setState(() {
      playerChoice = choice;
      computerChoice = choices[_random.nextInt(3)];
      
      if (playerChoice == computerChoice) {
        result = 'Égalité !';
      } else if ((playerChoice == 'Pierre' && computerChoice == 'Ciseaux') ||
                 (playerChoice == 'Papier' && computerChoice == 'Pierre') ||
                 (playerChoice == 'Ciseaux' && computerChoice == 'Papier')) {
        result = 'Vous avez gagné !';
        playerScore++;
      } else {
        result = 'L\'ordinateur a gagné !';
        computerScore++;
      }
    });

    _controller.forward(from: 0);
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
          'Pierre-Papier-Ciseaux',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreCard('Vous', playerScore),
                _buildScoreCard('Ordinateur', computerScore),
              ],
            ),
          ),
          const Spacer(),
          if (playerChoice != null && computerChoice != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildChoiceDisplay('Vous', playerChoice!),
                _buildChoiceDisplay('Ordinateur', computerChoice!),
              ],
            ),
            const SizedBox(height: 32),
            ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Curves.easeInOut,
              ),
              child: Text(
                result!,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: result == 'Vous avez gagné !'
                      ? Colors.green
                      : result == 'L\'ordinateur a gagné !'
                          ? Colors.red
                          : Colors.blue,
                ),
              ),
            ),
          ],
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: choices.map((choice) {
                return _buildChoiceButton(choice);
              }).toList(),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String player, int score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
            player,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            score.toString(),
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceDisplay(String player, String choice) {
    return Column(
      children: [
        Text(
          player,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            _getEmoji(choice),
            style: const TextStyle(fontSize: 48),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceButton(String choice) {
    return ElevatedButton(
      onPressed: () => _play(choice),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      child: Text(
        choice,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getEmoji(String choice) {
    switch (choice) {
      case 'Pierre':
        return '✊';
      case 'Papier':
        return '✋';
      case 'Ciseaux':
        return '✌️';
      default:
        return '';
    }
  }
}
