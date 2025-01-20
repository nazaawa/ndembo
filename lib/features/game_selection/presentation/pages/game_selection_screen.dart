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

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sports_esports,
                color: Colors.blue,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Ndembo Games',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black54),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'À propos de Ndembo',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    'Ndembo est une collection de jeux traditionnels et modernes, mettant en valeur la richesse du patrimoine ludique africain tout en proposant des classiques universels.',
                    style: GoogleFonts.poppins(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Fermer',
                        style: GoogleFonts.poppins(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenue sur Ndembo',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Découvrez notre collection de jeux passionnants',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.games,
                    color: Colors.white,
                    size: 48,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildCategoryHeader('Jeux Classiques', Icons.star),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildGameCard(
                  'Tic Tac Toe',
                  'Le jeu classique du morpion',
                  Icons.grid_3x3,
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TicTacToeScreen(),
                    ),
                  ),
                ),
                _buildGameCard(
                  'Pile ou Face',
                  'Testez votre chance',
                  Icons.monetization_on,
                  Colors.amber,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CoinFlipScreen(),
                    ),
                  ),
                ),
                _buildGameCard(
                  'Dés',
                  'Lancez les dés',
                  Icons.casino,
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DiceGameScreen(),
                    ),
                  ),
                ),
                _buildGameCard(
                  'Pierre Papier Ciseaux',
                  'Le jeu de réflexe',
                  Icons.sports_martial_arts,
                  Colors.purple,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RockPaperScissorsScreen(),
                    ),
                  ),
                ),
                _buildGameCard(
                  'Serpents et Échelles',
                  'Le jeu de plateau classique',
                  Icons.timeline,
                  Colors.green[700]!,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SnakesAndLaddersScreen(),
                    ),
                  ),
                ),
                _buildGameCard(
                  'Jeu de Dames',
                  'Le jeu de stratégie',
                  Icons.grid_on,
                  Colors.brown[700]!,
                  () async {
                    final vsComputer = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Choisir votre Adversaire',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildModeChoice(
                                      context: context,
                                      icon: Icons.people,
                                      title: '2 Joueurs',
                                      subtitle: 'Jouer à deux',
                                      color: Colors.blue,
                                      onTap: () =>
                                          Navigator.pop(context, false),
                                    ),
                                    _buildModeChoice(
                                      context: context,
                                      icon: Icons.computer,
                                      title: 'vs IA',
                                      subtitle: 'Défier l\'ordinateur',
                                      color: Colors.green,
                                      onTap: () => Navigator.pop(context, true),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    if (vsComputer == true) {
                      final level = await showDialog<AILevel>(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Niveau de Difficulté',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  _buildDifficultyChoice(
                                    context: context,
                                    icon: Icons.sentiment_satisfied,
                                    title: 'Facile',
                                    description: 'Pour débuter tranquillement',
                                    color: Colors.green,
                                    level: AILevel.easy,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildDifficultyChoice(
                                    context: context,
                                    icon: Icons.sentiment_neutral,
                                    title: 'Moyen',
                                    description: 'Pour un défi équilibré',
                                    color: Colors.orange,
                                    level: AILevel.medium,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildDifficultyChoice(
                                    context: context,
                                    icon: Icons.sentiment_very_dissatisfied,
                                    title: 'Difficile',
                                    description: 'Pour les experts',
                                    color: Colors.red,
                                    level: AILevel.hard,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                      if (level != null) {
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckersGameScreen(
                              vsComputer: true,
                              aiLevel: level,
                            ),
                          ),
                        );
                      }
                    } else if (vsComputer == false) {
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckersGameScreen(
                            vsComputer: false,
                            aiLevel: null,
                          ),
                        ),
                      );
                    }
                  },
                ),
            
              ],
            ),
            const SizedBox(height: 24),
            _buildCategoryHeader('Jeux Africains', Icons.public),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildGameCard(
                  'Ngola',
                  'Le jeu traditionnel africain',
                  Icons.grain,
                  Colors.brown,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NgolaGameScreen(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildCategoryHeader('Jeux de Course', Icons.directions_run),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildGameCard(
                  'Course Virtuelle',
                  'Course contre la montre',
                  Icons.directions_run,
                  Colors.orange,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ModeSelectionScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildGameCard(String title, String description, IconData icon,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeChoice({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyChoice({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required AILevel level,
  }) {
    return InkWell(
      onTap: () => Navigator.pop(context, level),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
