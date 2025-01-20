import 'dart:convert';

class GameHistory {
  final String gameId;
  final String gameName;
  final int score;
  final DateTime playedAt;

  GameHistory({
    required this.gameId,
    required this.gameName,
    required this.score,
    required this.playedAt,
  });

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'gameName': gameName,
        'score': score,
        'playedAt': playedAt.toIso8601String(),
      };

  factory GameHistory.fromJson(Map<String, dynamic> json) => GameHistory(
        gameId: json['gameId'],
        gameName: json['gameName'],
        score: json['score'],
        playedAt: DateTime.parse(json['playedAt']),
      );
}
