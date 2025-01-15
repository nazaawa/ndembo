import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class NgolaGameScreen extends StatefulWidget {
  const NgolaGameScreen({super.key});

  @override
  State<NgolaGameScreen> createState() => _NgolaGameScreenState();
}

class _NgolaGameScreenState extends State<NgolaGameScreen> {
  final game = NgolaGame();

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: game);
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

  // Fonction pour distribuer les graines
  void distributeSeeds(int player, int hole) {
    int seeds = boardData[player][hole];
    boardData[player][hole] = 0;
    int currentPlayerRow = player;
    int currentHole = hole + 1;

    while (seeds > 0) {
      if (currentHole < 6) {
        boardData[currentPlayerRow][currentHole]++;
        seeds--;
        currentHole++;
      } else if (currentHole == 6 && currentPlayerRow == player) {
        greniersData[player]++;
        seeds--;
        currentPlayerRow = 1 - player; // Passer à l'autre rangée
        currentHole = 0;
      } else {
        currentPlayerRow = 1 - player;
        currentHole = 0;
      }
    }

    // Vérifier les captures
    if (currentHole - 1 >= 0 && currentHole - 1 < 6) {
      if (boardData[currentPlayerRow][currentHole - 1] == 1 &&
          currentPlayerRow != player) {
        greniersData[player] += boardData[currentPlayerRow][currentHole - 1];
        boardData[currentPlayerRow][currentHole - 1] = 0;
      }
    }

    // Vérifier si le jeu est terminé
    if (boardData[0].every((seeds) => seeds == 0) ||
        boardData[1].every((seeds) => seeds == 0)) {
      isGameOver = true;
      greniersData[0] += boardData[0].reduce((a, b) => a + b);
      greniersData[1] += boardData[1].reduce((a, b) => a + b);
    }

    // Mettre à jour l'affichage
    updateUI();

    // Changer de joueur
    currentPlayer = 1 - currentPlayer;
  }

  // Mettre à jour l'interface utilisateur
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

  // Gérer les clics
  @override
  void onTapDown(TapDownInfo info) {
    if (isGameOver) return;

    final touchPosition = info.eventPosition.global;
    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 6; col++) {
        final holePosition = holes[row * 6 + col].position;
        if (touchPosition.x >= holePosition.x &&
            touchPosition.x <= holePosition.x + 50 &&
            touchPosition.y >= holePosition.y &&
            touchPosition.y <= holePosition.y + 50) {
          if (currentPlayer == row && boardData[row][col] > 0) {
            distributeSeeds(row, col);
          }
        }
      }
    }
  }
}
