part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

class SearchGames extends HomeEvent {
  final String query;

  SearchGames(this.query);

  @override
  List<Object> get props => [query];
}
