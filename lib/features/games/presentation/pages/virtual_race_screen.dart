import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text('Jeu de Course Virtuelle'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetRace,
            tooltip: 'Réinitialiser',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Pariez sur un coureur avant le départ !',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (winner != null)
              Column(
                children: [
                  Text(
                    winner == selectedRacerPlayer1
                        ? "🎉 Joueur 1 a gagné ! $winner a terminé premier !"
                        : winner == selectedRacerPlayer2
                            ? "🎉 Joueur 2 a gagné ! $winner a terminé premier !"
                            : "😞 Aucun joueur n'a gagné. $winner a terminé premier.",
                    style: TextStyle(
                      fontSize: 18,
                      color: winner == selectedRacerPlayer1 ||
                              winner == selectedRacerPlayer2
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  if (showConfetti)
                    const Icon(
                      Icons.celebration,
                      color: Colors.yellow,
                      size: 50,
                    ),
                ],
              ),
            if (isRacing)
              const Text(
                "La course est en cours...",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: racers.length,
                itemBuilder: (context, index) {
                  final racer = racers[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            racer,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: selectedRacerPlayer1 == racer
                                  ? Colors.blue
                                  : selectedRacerPlayer2 == racer
                                      ? Colors.green
                                      : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            children: [
                              LinearProgressIndicator(
                                value: positions[racer],
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  selectedRacerPlayer1 == racer
                                      ? Colors.blue
                                      : selectedRacerPlayer2 == racer
                                          ? Colors.green
                                          : Colors.red,
                                ),
                                minHeight: 20,
                              ),
                              Positioned(
                                left: positions[racer]! *
                                    (MediaQuery.of(context).size.width - 48),
                                child: const Icon(
                                  Icons.directions_car,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (!isRacing)
              Column(
                children: [
                  if (widget.numberOfPlayers >= 1)
                    Text(
                      selectedRacerPlayer1 == null
                          ? "Joueur 1 : Sélectionnez un coureur."
                          : "Joueur 1 a parié sur : $selectedRacerPlayer1",
                      style: const TextStyle(fontSize: 16),
                    ),
                  if (widget.numberOfPlayers >= 2)
                    Text(
                      selectedRacerPlayer2 == null
                          ? "Joueur 2 : Sélectionnez un coureur."
                          : "Joueur 2 a parié sur : $selectedRacerPlayer2",
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: racers
                        .map((racer) => ChoiceChip(
                              label: Text(racer),
                              selected: selectedRacerPlayer1 == racer ||
                                  selectedRacerPlayer2 == racer,
                              onSelected: (isSelected) {
                                if (!isRacing) {
                                  setState(() {
                                    if (widget.numberOfPlayers == 1) {
                                      selectedRacerPlayer1 = racer;
                                    } else if (widget.numberOfPlayers == 2) {
                                      if (selectedRacerPlayer1 == null) {
                                        selectedRacerPlayer1 = racer;
                                      } else if (selectedRacerPlayer2 == null &&
                                          selectedRacerPlayer1 != racer) {
                                        selectedRacerPlayer2 = racer;
                                      }
                                    }
                                  });
                                }
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Commencer la course'),
                    onPressed: (widget.numberOfPlayers == 1 &&
                                selectedRacerPlayer1 != null) ||
                            (widget.numberOfPlayers == 2 &&
                                selectedRacerPlayer1 != null &&
                                selectedRacerPlayer2 != null)
                        ? _startRace
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
