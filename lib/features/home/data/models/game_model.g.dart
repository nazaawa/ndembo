// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      isFeatured: json['isFeatured'] as bool? ?? false,
      gameType: $enumDecode(_$GameTypeEnumMap, json['gameType']),
    );

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'isFeatured': instance.isFeatured,
      'gameType': _$GameTypeEnumMap[instance.gameType]!,
    };

const _$GameTypeEnumMap = {
  GameType.card: 'card',
  GameType.dice: 'dice',
  GameType.board: 'board',
  GameType.action: 'action',
  GameType.other: 'other',
  GameType.tictactoe: 'tictactoe',
  GameType.rockPaperScissors: 'rockPaperScissors',
  GameType.coinFlip: 'coinFlip',
};
