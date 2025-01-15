import 'package:flutter/material.dart';

class PokerPage extends StatelessWidget {
  const PokerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poker à deux cartes'),
      ),
      body: const Center(
        child: Text('Poker Game Coming Soon'),
      ),
    );
  }
}
