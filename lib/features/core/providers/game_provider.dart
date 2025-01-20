import 'package:flutter/foundation.dart';
import '../data/services/local_storage_service.dart';
import '../data/models/game_history.dart';

class GameProvider extends ChangeNotifier {
  final LocalStorageService _storageService;
  
  GameProvider(this._storageService);

  List<GameHistory> get recentGames => _storageService.getRecentGames();
  
  List<String> get playedGameIds => _storageService.getPlayedGameIds();

  Future<void> saveGameScore(String gameId, String gameName, int score) async {
    await _storageService.saveGameScore(gameId, score);
    await _storageService.saveGameHistory(
      GameHistory(
        gameId: gameId,
        gameName: gameName,
        score: score,
        playedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  int? getGameScore(String gameId) => _storageService.getGameScore(gameId);
}
