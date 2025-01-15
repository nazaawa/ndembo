import 'package:equatable/equatable.dart';

class Game extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final bool isFeatured;

  const Game({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, isFeatured];
}
