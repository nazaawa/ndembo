import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/game_model.dart';

abstract class GameRemoteDataSource {
  Future<List<GameModel>> getFeaturedGames();
  Future<List<GameModel>> getPopularGames();
  Future<List<GameModel>> searchGames(String query);
}

@Injectable(as: GameRemoteDataSource)
class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  final Dio dio;

  GameRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<GameModel>> getFeaturedGames() async {
    // TODO: Implement real API call
    // This is mock data for now
    return [
      const GameModel(
        id: '1',
        title: 'Tic-Tac-Toe',
        description: 'Le classique jeu de morpion! Affrontez l\'ordinateur ou un ami.',
        imageUrl: 'https://picsum.photos/400/300?random=1',
        isFeatured: true,
        gameType: GameType.tictactoe,
      ),
      const GameModel(
        id: '2',
        title: 'Pierre-Papier-Ciseaux',
        description: 'Testez votre chance et votre stratégie!',
        imageUrl: 'https://picsum.photos/400/300?random=2',
        isFeatured: true,
        gameType: GameType.rockPaperScissors,
      ),
    ];
  }

  @override
  Future<List<GameModel>> getPopularGames() async {
    // TODO: Implement real API call
    return [
      const GameModel(
        id: '3',
        title: 'Pile ou Face',
        description: 'Un simple jeu de hasard. Choisissez pile ou face!',
        imageUrl: 'https://picsum.photos/200/200?random=3',
        gameType: GameType.coinFlip,
      ),
      const GameModel(
        id: '4',
        title: 'Tic-Tac-Toe Pro',
        description: 'Version avancée avec des défis supplémentaires.',
        imageUrl: 'https://picsum.photos/200/200?random=4',
        gameType: GameType.tictactoe,
      ),
      const GameModel(
        id: '5',
        title: 'Pierre-Papier-Ciseaux Tournoi',
        description: 'Participez à des tournois en ligne!',
        imageUrl: 'https://picsum.photos/200/200?random=5',
        gameType: GameType.rockPaperScissors,
      ),
      const GameModel(
        id: '6',
        title: 'Pile ou Face Challenge',
        description: 'Défiez vos amis dans des séries de lancers.',
        imageUrl: 'https://picsum.photos/200/200?random=6',
        gameType: GameType.coinFlip,
      ),
    ];
  }

  @override
  Future<List<GameModel>> searchGames(String query) async {
    final allGames = [...await getFeaturedGames(), ...await getPopularGames()];
    return allGames
        .where((game) =>
            game.title.toLowerCase().contains(query.toLowerCase()) ||
            game.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
