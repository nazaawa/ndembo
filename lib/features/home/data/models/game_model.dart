import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/game.dart';

part 'game_model.g.dart';

enum GameType {
  tictactoe,
  rockPaperScissors,
  coinFlip,
}

@JsonSerializable()
class GameModel extends Game {
  const GameModel({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    bool isFeatured = false,
    required GameType gameType,
  }) : super(
          id: id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          isFeatured: isFeatured,
          gameType: gameType,
        );

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameModelToJson(this);
}
