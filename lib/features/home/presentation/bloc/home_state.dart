part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Game> featuredGames;
  final List<Game> popularGames;

  HomeLoaded({
    required this.featuredGames,
    required this.popularGames,
  });

  @override
  List<Object> get props => [featuredGames, popularGames];
}

class HomeSearching extends HomeState {}

class HomeSearchResults extends HomeState {
  final List<Game> games;

  HomeSearchResults({required this.games});

  @override
  List<Object> get props => [games];
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});

  @override
  List<Object> get props => [message];
}
