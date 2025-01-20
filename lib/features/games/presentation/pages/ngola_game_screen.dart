import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class NgolaGameScreen extends StatefulWidget {
  const NgolaGameScreen({super.key});

  @override
  State<NgolaGameScreen> createState() => _NgolaGameScreenState();
}

class _NgolaGameScreenState extends State<NgolaGameScreen>
    with SingleTickerProviderStateMixin {
  final game = NgolaGame();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playMoveAnimation() {
    _controller.forward().then((_) => _controller.reverse());
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
          'Ngola',
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
                _buildScoreCard('Joueur 1', game.greniersData[0], Colors.blue),
                Container(
                  height: 40,
                  width: 2,
                  color: Colors.grey[300],
                ),
                _buildScoreCard('Joueur 2', game.greniersData[1], Colors.red),
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
                    Colors.brown[100]!,
                    Colors.brown[200]!,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPlayerBoard(2, game),
                  const SizedBox(height: 40),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.rotate(
                          angle: _rotateAnimation.value,
                          child: _buildCentralPit(game.centralPit),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  _buildPlayerBoard(1, game),
                ],
              ),
            ),
          ),
          if (game.isGameOver)
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.green, Colors.blue],
                          ).createShader(bounds),
                          child: Text(
                            'Partie terminée !',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Gagnant : ${game.greniersData[0] > game.greniersData[1] ? 'Joueur 1' : 'Joueur 2'}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: game.greniersData[0] > game.greniersData[1]
                                ? Colors.blue
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            game.resetGame();
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Nouvelle partie',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, int score, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
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
          ),
        );
      },
    );
  }

  Widget _buildPlayerBoard(int player, NgolaGame game) {
    final pits = player == 1 ? game.boardData[0] : game.boardData[1];
    final isCurrentPlayer = game.currentPlayer == player;
    final color = player == 1 ? Colors.blue : Colors.red;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          6,
          (index) => TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 200 + index * 100),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: _buildPit(
                  stones: pits[index],
                  onTap: () {
                    if (isCurrentPlayer && !game.isGameOver) {
                      _playMoveAnimation();
                      game.distributeSeeds(player - 1, index);
                      setState(() {});
                    }
                  },
                  color: color,
                  isEnabled: isCurrentPlayer && !game.isGameOver,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPit({
    required int stones,
    required VoidCallback? onTap,
    required Color color,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: isEnabled ? color : Colors.grey,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: isEnabled
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.1),
                    color.withOpacity(0.2),
                  ],
                )
              : null,
        ),
        child: Center(
          child: Text(
            stones.toString(),
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isEnabled ? color : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCentralPit(int centralPit) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.amber,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber[300]!,
            Colors.amber[700]!,
          ],
        ),
      ),
      child: Center(
        child: Text(
          centralPit.toString(),
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class NgolaGame extends FlameGame with TapDetector {
  // Plateau de jeu
  late final SpriteComponent board;
  late final List<SpriteComponent> holes = [];
  late final List<TextComponent> seedsCount = [];
  late final List<TextComponent> greniers = [];

  // Données du jeu
  List<List<int>> boardData = [
    [4, 4, 4, 4, 4, 4], // Rangée du joueur 1
    [4, 4, 4, 4, 4, 4], // Rangée du joueur 2
  ];
  List<int> greniersData = [0, 0]; // Greniers pour les joueurs 1 et 2
  int currentPlayer = 0; // 0 pour le joueur 1, 1 pour le joueur 2
  bool isGameOver = false;
  int centralPit = 0;
  bool canContinuePlaying = false;

  @override
  Future<void> onLoad() async {
    // Charger le plateau de jeu
    final boardSprite =
        await loadSprite('board.png'); // Remplacez par votre image
    board = SpriteComponent()
      ..sprite = boardSprite
      ..size = size;
    add(board);

    // Créer les cases (trous)
    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 6; col++) {
        final hole = SpriteComponent()
          ..sprite = await loadSprite('hole.png') // Remplacez par votre image
          ..size = Vector2(50, 50)
          ..position = Vector2(100 + col * 60, 100 + row * 60);
        holes.add(hole);
        add(hole);

        // Afficher le nombre de graines
        final seedCount = TextComponent(
          text: '${boardData[row][col]}',
          position: Vector2(100 + col * 60 + 20, 100 + row * 60 + 20),
          textRenderer: TextPaint(
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
        seedsCount.add(seedCount);
        add(seedCount);
      }
    }

    // Créer les greniers
    for (int i = 0; i < 2; i++) {
      final grenier = TextComponent(
        text: 'Grenier ${i + 1}: ${greniersData[i]}',
        position: Vector2(50, 300 + i * 50),
        textRenderer: TextPaint(
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      );
      greniers.add(grenier);
      add(grenier);
    }
  }

  bool isValidMove(int player, int hole) {
    // Vérifier si le trou appartient au joueur actuel
    if (player != currentPlayer) return false;

    // Vérifier si le trou n'est pas vide
    if (boardData[player][hole] == 0) return false;

    return true;
  }

  void distributeSeeds(int player, int hole) {
    if (!isValidMove(player, hole)) return;

    int seeds = boardData[player][hole];
    boardData[player][hole] = 0;
    int currentPlayerRow = player;
    int currentHole = hole;
    canContinuePlaying = false;

    while (seeds > 0) {
      currentHole++;
      
      // Si on arrive à la fin de la rangée
      if (currentHole >= 6) {
        currentPlayerRow = 1 - currentPlayerRow;
        currentHole = 0;
      }

      // Si on revient au trou de départ, on le saute
      if (currentPlayerRow == player && currentHole == hole) {
        currentHole++;
        if (currentHole >= 6) {
          currentPlayerRow = 1 - currentPlayerRow;
          currentHole = 0;
        }
      }

      boardData[currentPlayerRow][currentHole]++;
      seeds--;
    }

    // Règles de capture
    if (currentPlayerRow == player) {
      // Si la dernière graine tombe dans un trou du joueur
      int lastHoleSeeds = boardData[currentPlayerRow][currentHole];

      // Capture si le trou était vide avant (donc maintenant contient 1)
      if (lastHoleSeeds == 1) {
        // Capturer les graines du trou opposé
        int oppositeRow = 1 - currentPlayerRow;
        int oppositeHole = 5 - currentHole;

        if (boardData[oppositeRow][oppositeHole] > 0) {
          greniersData[player] += boardData[oppositeRow][oppositeHole] + 1;
          boardData[oppositeRow][oppositeHole] = 0;
          boardData[currentPlayerRow][currentHole] = 0;
          canContinuePlaying = true;
        }
      }
    }

    // Vérifier si le jeu est terminé
    bool player1Empty = boardData[0].every((seeds) => seeds == 0);
    bool player2Empty = boardData[1].every((seeds) => seeds == 0);

    if (player1Empty || player2Empty) {
      isGameOver = true;
      // Collecter toutes les graines restantes
      for (int row = 0; row < 2; row++) {
        for (int col = 0; col < 6; col++) {
          greniersData[row] += boardData[row][col];
          boardData[row][col] = 0;
        }
      }
    }

    // Mettre à jour l'affichage
    updateUI();

    // Changer de joueur seulement si pas de capture
    if (!canContinuePlaying) {
      currentPlayer = 1 - currentPlayer;
    }
  }

  void updateUI() {
    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 6; col++) {
        seedsCount[row * 6 + col].text = '${boardData[row][col]}';
      }
    }
    for (int i = 0; i < 2; i++) {
      greniers[i].text = 'Grenier ${i + 1}: ${greniersData[i]}';
    }
  }

  void resetGame() {
    boardData = [
      [4, 4, 4, 4, 4, 4], // Rangée du joueur 1
      [4, 4, 4, 4, 4, 4], // Rangée du joueur 2
    ];
    greniersData = [0, 0]; // Greniers pour les joueurs 1 et 2
    currentPlayer = 0; // 0 pour le joueur 1, 1 pour le joueur 2
    isGameOver = false;
    centralPit = 0;
    updateUI();
  }
}
