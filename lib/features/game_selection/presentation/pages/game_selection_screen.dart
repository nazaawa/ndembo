import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndembo/features/games/presentation/pages/checkers_game_screen.dart';
import 'package:ndembo/features/games/presentation/pages/dice_screen.dart';
import 'package:ndembo/features/games/presentation/pages/ngola_game_screen.dart';
import 'package:ndembo/features/games/presentation/pages/snakes_and_ladders.dart';
import 'package:ndembo/features/games/presentation/pages/virtual_race_screen.dart';
import '../../../games/presentation/pages/tictactoe_screen.dart';
import '../../../games/presentation/pages/rock_paper_scissors_screen.dart';
import '../../../games/presentation/pages/coin_flip_screen.dart';
import '../widgets/game_category_chip.dart';
import '../widgets/game_card.dart';

class GameSelectionScreen extends StatefulWidget {
  const GameSelectionScreen({super.key});

  @override
  State<GameSelectionScreen> createState() => _GameSelectionScreenState();
}

class _GameSelectionScreenState extends State<GameSelectionScreen> {
  String _selectedCategory = 'Jeux de dés';

  final List<String> _categories = [
    'Jeux de dés',
    'Jeux de cartes',
    'Jeux d\'action',
  ];

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
          'Choisissez un jeu',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GameCategoryChip(
                    label: category,
                    isSelected: _selectedCategory == category,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                GameCard(
                  title: 'Tic-Tac-Toe (Morpion)',
                  description: 'Le classique jeu de morpion à deux joueurs',
                  onPlay: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TicTacToeScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GameCard(
                  title: 'Pierre-Papier-Ciseaux',
                  description: 'Affrontez l\'ordinateur dans ce jeu de réflexe',
                  onPlay: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RockPaperScissorsScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GameCard(
                  title: 'Pile ou Face',
                  description: 'Un simple jeu de hasard',
                  onPlay: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CoinFlipScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GameCard(
                  title: 'Ludo Simplifié',
                  description: 'Une version simplifiée du jeu Ludo',
                  onPlay: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SnakesAndLaddersScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GameCard(
                  title: 'Découvrir le hasard',
                  description: 'Un simple jeu de hasard',
                  onPlay: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DiceGameScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GameCard(
                  title: 'Dames',
                  description: 'Un jeu de dames simplifié',
                  onPlay: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckersGameScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GameCard(
                  title: 'Jeu de course virtuelle',
                  description: 'Un jeu de course virtuelle simplifié',
                  onPlay: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ModeSelectionScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GameCard(
                  title: 'Jeu de Ngola',
                  description: 'Un jeu de Ngola simplifié',
                  onPlay: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NgolaGameScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
