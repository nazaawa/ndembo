import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/game.dart';
import '../../domain/repositories/game_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GameRepository gameRepository;

  HomeBloc({required this.gameRepository}) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SearchGames>(_onSearchGames);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    final featuredGamesResult = await gameRepository.getFeaturedGames();
    final popularGamesResult = await gameRepository.getPopularGames();

    featuredGamesResult.fold(
      (failure) => emit(HomeError(message: 'Failed to load games')),
      (featuredGames) {
        popularGamesResult.fold(
          (failure) => emit(HomeError(message: 'Failed to load games')),
          (popularGames) => emit(
            HomeLoaded(
              featuredGames: featuredGames,
              popularGames: popularGames,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onSearchGames(
    SearchGames event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeSearching());

    final result = await gameRepository.searchGames(event.query);

    result.fold(
      (failure) => emit(HomeError(message: 'Failed to search games')),
      (games) => emit(HomeSearchResults(games: games)),
    );
  }
}
