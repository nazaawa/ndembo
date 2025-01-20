import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_history.dart';

class LocalStorageService {
  static const String _playedGamesKey = 'played_games';
  static const String _scoresKey = 'game_scores';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  Future<void> saveGameHistory(GameHistory history) async {
    final List<String> histories = _prefs.getStringList(_playedGamesKey) ?? [];
    histories.add(jsonEncode(history.toJson()));
    await _prefs.setStringList(_playedGamesKey, histories);
  }

  List<GameHistory> getPlayedGames() {
    final List<String> histories = _prefs.getStringList(_playedGamesKey) ?? [];
    return histories
        .map((str) => GameHistory.fromJson(jsonDecode(str)))
        .toList()
      ..sort((a, b) => b.playedAt.compareTo(a.playedAt));
  }

  Future<void> saveGameScore(String gameId, int score) async {
    final Map<String, dynamic> scores = Map<String, dynamic>.from(
        jsonDecode(_prefs.getString(_scoresKey) ?? '{}'));
    scores[gameId] = score;
    await _prefs.setString(_scoresKey, jsonEncode(scores));
  }

  int? getGameScore(String gameId) {
    final Map<String, dynamic> scores = Map<String, dynamic>.from(
        jsonDecode(_prefs.getString(_scoresKey) ?? '{}'));
    return scores[gameId] as int?;
  }

  List<GameHistory> getRecentGames() {
    return getPlayedGames().take(5).toList();
  }

  List<String> getPlayedGameIds() {
    return getPlayedGames().map((game) => game.gameId).toList();
  }
}
