import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/game.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_remote_data_source.dart';

class GameRepositoryImpl implements GameRepository {
  final GameRemoteDataSource remoteDataSource;

  GameRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Game>>> getFeaturedGames() async {
    try {
      final result = await remoteDataSource.getFeaturedGames();
      return Right(result);
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
