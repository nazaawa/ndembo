import 'package:dartz/dartz.dart';
import '../entities/game.dart';
import '../../../../core/error/failures.dart';

abstract class GameRepository {
  Future<Either<Failure, List<Game>>> getFeaturedGames();
  Future<Either<Failure, List<Game>>> getPopularGames();
  Future<Either<Failure, List<Game>>> searchGames(String query);
}
