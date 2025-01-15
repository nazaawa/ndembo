import 'package:equatable/equatable.dart';
import '../../data/models/game_model.dart';

class Game extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final bool isFeatured;
  final GameType gameType;

  const Game({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isFeatured = false,
    required this.gameType,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, isFeatured, gameType];
}
