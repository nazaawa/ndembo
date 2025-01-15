import 'package:json_annotation/json_annotation.dart';
import 'package:ndembo/features/home/domain/entities/game_type.dart';
import '../../domain/entities/game.dart';

part 'game_model.g.dart';


@JsonSerializable() 
class GameModel extends Game {
  const GameModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    super.isFeatured,
    required super.gameType,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameModelToJson(this);
}
