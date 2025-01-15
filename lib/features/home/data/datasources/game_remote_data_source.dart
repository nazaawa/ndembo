import 'package:dio/dio.dart';
import '../models/game_model.dart';

abstract class GameRemoteDataSource {
  Future<List<GameModel>> getFeaturedGames();
  Future<List<GameModel>> getPopularGames();
  Future<List<GameModel>> searchGames(String query);
}

class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  final Dio client;

  GameRemoteDataSourceImpl({required this.client});

  @override
  Future<List<GameModel>> getFeaturedGames() async {
    // TODO: Implement real API call
    // This is mock data for now
    return [
      const GameModel(
        id: '1',
        title: 'New Adventures',
        description: 'Exciting games just!',
        imageUrl: 'https://picsum.photos/400/300?random=1',
        isFeatured: true,
      ),
      const GameModel(
        id: '2',
        title: 'Mega Sale',
        description: 'Limited time offers',
        imageUrl: 'https://picsum.photos/400/300?random=2',
        isFeatured: true,
      ),
    ];
  }

  @override
  Future<List<GameModel>> getPopularGames() async {
    // TODO: Implement real API call
    return [
      const GameModel(
        id: '3',
        title: 'Epic Battle',
        description: 'Join the ultimate fight for glory.',
        imageUrl: 'https://picsum.photos/200/200?random=3',
      ),
      const GameModel(
        id: '4',
        title: 'Mystery Quest',
        description: 'Unravel the secrets of the past.',
        imageUrl: 'https://picsum.photos/200/200?random=4',
      ),
      const GameModel(
        id: '5',
        title: 'Fantasy World',
        description: 'Explore magical realms of adventure.',
        imageUrl: 'https://picsum.photos/200/200?random=5',
      ),
      const GameModel(
        id: '6',
        title: 'Racing Legends',
        description: 'Who will speed to victory?',
        imageUrl: 'https://picsum.photos/200/200?random=6',
      ),
    ];
  }

  @override
  Future<List<GameModel>> searchGames(String query) async {
    // TODO: Implement real API call
    final allGames = [...await getFeaturedGames(), ...await getPopularGames()];
    return allGames
        .where((game) =>
            game.title.toLowerCase().contains(query.toLowerCase()) ||
            game.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
