import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinFlipScreen extends StatefulWidget {
  const CoinFlipScreen({super.key});

  @override
  State<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();
  
  bool? isHeads;
  String? playerChoice;
  int wins = 0;
  int losses = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        _checkResult();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCoin(bool choice) {
    setState(() {
      playerChoice = choice ? 'Pile' : 'Face';
      isHeads = null;
    });

    _controller.forward(from: 0);
  }

  void _checkResult() {
    setState(() {
      isHeads = _random.nextBool();
      if ((isHeads! && playerChoice == 'Pile') ||
          (!isHeads! && playerChoice == 'Face')) {
        wins++;
      } else {
        losses++;
      }
    });
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
          'Pile ou Face',
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
                _buildScoreCard('Victoires', wins, Colors.green),
                _buildScoreCard('Défaites', losses, Colors.red),
              ],
            ),
          ),
          const Spacer(),
          RotationTransition(
            turns: _animation,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  isHeads == null
                      ? '?'
                      : isHeads!
                          ? 'P'
                          : 'F',
                  style: GoogleFonts.poppins(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          if (isHeads != null)
            Text(
              (isHeads! && playerChoice == 'Pile') ||
                      (!isHeads! && playerChoice == 'Face')
                  ? 'Vous avez gagné !'
                  : 'Vous avez perdu !',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: (isHeads! && playerChoice == 'Pile') ||
                        (!isHeads! && playerChoice == 'Face')
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildChoiceButton('Pile', true),
                _buildChoiceButton('Face', false),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, int score, Color color) {
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
            label,
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
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton(String label, bool isHeads) {
    return ElevatedButton(
      onPressed: () => _flipCoin(isHeads),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
