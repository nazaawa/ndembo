import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeu de Course Virtuelle'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choisissez le mode de jeu :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const VirtualRaceScreen(numberOfPlayers: 1),
                  ),
                );
              },
              child: const Text('1 Joueur'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const VirtualRaceScreen(numberOfPlayers: 2),
                  ),
                );
              },
              child: const Text('2 Joueurs'),
            ),
          ],
        ),
      ),
    );
  }
}

class VirtualRaceScreen extends StatefulWidget {
  final int numberOfPlayers;

  const VirtualRaceScreen({super.key, required this.numberOfPlayers});

  @override
  State<VirtualRaceScreen> createState() => _VirtualRaceScreenState();
}

class _VirtualRaceScreenState extends State<VirtualRaceScreen> {
  final List<String> racers = ['🚗', '🚕', '🚙', '🚌', '🚓'];
  final Map<String, double> positions = {};
  String? selectedRacerPlayer1;
  String? selectedRacerPlayer2;
  String? winner;
  bool isRacing = false;
  bool showConfetti = false;

  @override
  void initState() {
    super.initState();
    _resetRace();
  }

  void _resetRace() {
    positions.clear();
    for (var racer in racers) {
      positions[racer] = 0.0;
    }
    selectedRacerPlayer1 = null;
    selectedRacerPlayer2 = null;
    winner = null;
    isRacing = false;
    showConfetti = false;
    setState(() {});
  }

  Future<void> _startRace() async {
    setState(() {
      isRacing = true;
      winner = null;
      showConfetti = false;
    });

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        for (var racer in racers) {
          positions[racer] =
              min(1.0, positions[racer]! + Random().nextDouble() * 0.1);
        }
        final finished = positions.entries.firstWhere(
          (entry) => entry.value >= 1.0,
          orElse: () => const MapEntry('', 0.0),
        );

        if (finished.key.isNotEmpty) {
          winner = finished.key;
          isRacing = false;
          showConfetti =
              winner == selectedRacerPlayer1 || winner == selectedRacerPlayer2;
          timer.cancel();

          // Réinitialiser après un délai
          Future.delayed(const Duration(seconds: 3), () {
            _resetRace();
          });
        }
      });
    });
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
          'Course Virtuelle',
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
                _buildScoreCard('Meilleur Temps', '0', Colors.green),
                Container(
                  height: 40,
                  width: 2,
                  color: Colors.grey[300],
                ),
                _buildScoreCard('Tours', '0', Colors.blue),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CustomPaint(
                      painter: RaceTrackPainter(
                        playerPosition: positions.values.first,
                        checkpoints: [0.2, 0.5, 0.8],
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
                if (!isRacing && !isRacing)
                  Center(
                    child: ElevatedButton(
                      onPressed: _startRace,
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
                          const Icon(Icons.play_arrow),
                          const SizedBox(width: 8),
                          Text(
                            'Démarrer',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isRacing)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Course en cours...',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Temps: 0',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                if (showConfetti)
                  ParticleSystem(
                    position: const Offset(100, 100),
                  ),
              ],
            ),
          ),
          if (isRacing)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    Icons.arrow_back,
                    () {},
                    Colors.blue,
                  ),
                  _buildControlButton(
                    Icons.arrow_upward,
                    () {},
                    Colors.green,
                  ),
                  _buildControlButton(
                    Icons.arrow_downward,
                    () {},
                    Colors.orange,
                  ),
                  _buildControlButton(
                    Icons.arrow_forward,
                    () {},
                    Colors.purple,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, String value, Color color) {
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
            value,
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

  Widget _buildControlButton(IconData icon, VoidCallback onPressed, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.8),
            color,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class RaceTrackPainter extends CustomPainter {
  final double playerPosition;
  final List<double> checkpoints;

  RaceTrackPainter({
    required this.playerPosition,
    required this.checkpoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final trackPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final trackBorderPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final checkpointPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final playerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Dessiner la piste
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(20, 20, size.width - 40, size.height - 40),
      const Radius.circular(30),
    );
    canvas.drawRRect(trackRect, trackPaint);
    canvas.drawRRect(trackRect, trackBorderPaint);

    // Dessiner les checkpoints
    final trackLength = (size.width - 40) * 2 + (size.height - 40) * 2;
    for (final checkpoint in checkpoints) {
      final position = _calculatePosition(checkpoint, trackLength, size);
      canvas.drawCircle(position, 10, checkpointPaint);
    }

    // Dessiner le joueur
    final playerPos = _calculatePosition(playerPosition, trackLength, size);
    canvas.drawCircle(playerPos, 15, playerPaint);
  }

  Offset _calculatePosition(double progress, double trackLength, Size size) {
    final normalizedProgress = progress * trackLength;
    final width = size.width - 40;
    final height = size.height - 40;

    if (normalizedProgress < width) {
      return Offset(20 + normalizedProgress, 20);
    } else if (normalizedProgress < width + height) {
      return Offset(size.width - 20, 20 + (normalizedProgress - width));
    } else if (normalizedProgress < width * 2 + height) {
      return Offset(
        size.width - 20 - (normalizedProgress - width - height),
        size.height - 20,
      );
    } else {
      return Offset(
        20,
        size.height - 20 - (normalizedProgress - width * 2 - height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant RaceTrackPainter oldDelegate) {
    return playerPosition != oldDelegate.playerPosition ||
        checkpoints != oldDelegate.checkpoints;
  }
}

class _RaceTrackClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 20, size.width - 40, size.height - 40),
        const Radius.circular(30),
      ),
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ParticleSystem extends StatefulWidget {
  final Offset position;

  const ParticleSystem({
    Key? key,
    required this.position,
  }) : super(key: key);

  @override
  _ParticleSystemState createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _initParticles();
    _controller.forward();
  }

  void _initParticles() {
    particles = List.generate(
      20,
      (index) => Particle(
        position: widget.position,
        velocity: Offset.fromDirection(
          Random().nextDouble() * 2 * pi,
          Random().nextDouble() * 2 + 1,
        ),
        color: Colors.blue.withOpacity(0.6),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var particle in particles) {
          particle.update(_controller.value);
        }
        return CustomPaint(
          painter: ParticlePainter(particles),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double life = 1.0;

  Particle({
    required this.position,
    required this.velocity,
    required this.color,
  });

  void update(double progress) {
    position += velocity;
    life = 1.0 - progress;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.life)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(particle.position, 2 * particle.life, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
