import 'package:injectable/injectable.dart';
import '../models/game_model.dart';
import 'card_games_data_source.dart';

abstract class GameRemoteDataSource {
  Future<List<GameModel>> getFeaturedGames();
  Future<List<GameModel>> getPopularGames();
  Future<List<GameModel>> searchGames(String query);
}

@Injectable(as: GameRemoteDataSource)
class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  final CardGamesDataSource cardGamesDataSource;

  GameRemoteDataSourceImpl({required this.cardGamesDataSource});

  @override
  Future<List<GameModel>> getFeaturedGames() async {
    // Pour l'instant, nous retournons uniquement les jeux de cartes
    return cardGamesDataSource.getCardGames();
  }

  @override
  Future<List<GameModel>> getPopularGames() async {
    // Pour l'instant, nous retournons les mêmes jeux
    return cardGamesDataSource.getCardGames();
  }

  @override
  Future<List<GameModel>> searchGames(String query) async {
    final allGames = cardGamesDataSource.getCardGames();
    return allGames
        .where((game) =>
            game.title.toLowerCase().contains(query.toLowerCase()) ||
            game.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
