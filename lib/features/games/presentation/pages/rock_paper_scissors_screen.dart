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
  int wins = 0;
  int losses = 0;

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

  void _makeChoice(String choice) {
    setState(() {
      playerChoice = choice;
      computerChoice = choices[_random.nextInt(3)];
      
      if (playerChoice == computerChoice) {
        result = 'Égalité !';
      } else if ((playerChoice == 'Pierre' && computerChoice == 'Ciseaux') ||
                 (playerChoice == 'Papier' && computerChoice == 'Pierre') ||
                 (playerChoice == 'Ciseaux' && computerChoice == 'Papier')) {
        result = 'Vous avez gagné !';
        wins++;
      } else {
        result = 'L\'ordinateur a gagné !';
        losses++;
      }
    });

    _controller.forward(from: 0);
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
          'Pierre Papier Ciseaux',
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
                _buildScoreCard('Victoires', wins, Colors.green),
                Container(
                  height: 40,
                  width: 2,
                  color: Colors.grey[300],
                ),
                _buildScoreCard('Défaites', losses, Colors.red),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildChoiceDisplay(playerChoice, 'Votre choix', Colors.blue),
                const SizedBox(height: 40),
                _buildChoiceDisplay(computerChoice, 'Ordinateur', Colors.red),
                const SizedBox(height: 40),
                if (result?.isNotEmpty ?? false)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _getResultColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      result ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getResultColor(),
                      ),
                    ),
                  ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildChoiceButton('Pierre', '✊', Colors.brown),
                    _buildChoiceButton('Papier', '✋', Colors.blue),
                    _buildChoiceButton('Ciseaux', '✌️', Colors.purple),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getResultColor() {
    if (result != null && result!.contains('Gagné')) {
      return Colors.green;
    } else if (result != null && result!.contains('Perdu')) {
      return Colors.red;
    }
    return Colors.orange;
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

  Widget _buildChoiceDisplay(String? choice, String label, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
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
          ),
          child: Center(
            child: Text(
              choice == null ? '?' : _getEmoji(choice),
              style: const TextStyle(fontSize: 48),
            ),
          ),
        ),
      ],
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
        return '?';
    }
  }

  Widget _buildChoiceButton(String choice, String emoji, Color color) {
    return ElevatedButton(
      onPressed: () => _makeChoice(choice),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 4),
          Text(
            choice,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
