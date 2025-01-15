import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/game.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_remote_data_source.dart';

@Injectable(as: GameRepository)
class GameRepositoryImpl implements GameRepository {
  final GameRemoteDataSource remoteDataSource;

  GameRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Game>>> getFeaturedGames() async {
    try {
      final games = [
        Game(
          id: '1',
          title: 'Bataille',
          description: 'Un jeu où deux joueurs comparent la valeur de leurs cartes. La carte la plus haute gagne.',
          imageUrl: 'assets/images/bataille.png',
          route: '/bataille',
        ),
        Game(
          id: '2',
          title: 'Blackjack',
          description: 'Une version simplifiée du célèbre jeu de casino.',
          imageUrl: 'assets/images/blackjack.png',
          route: '/blackjack',
        ),
        Game(
          id: '3',
          title: 'Poker à deux cartes',
          description: 'Les joueurs parient sur qui a la meilleure main avec seulement deux cartes.',
          imageUrl: 'assets/images/poker.png',
          route: '/poker',
        ),
      ];
      return Right(games);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Game>>> getPopularGames() async {
    try {
      final result = await remoteDataSource.getPopularGames();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Game>>> searchGames(String query) async {
    try {
      final result = await remoteDataSource.searchGames(query);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
