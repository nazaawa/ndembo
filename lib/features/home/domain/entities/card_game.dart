import 'package:equatable/equatable.dart';

class CardGame extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String route;

  const CardGame({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.route,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, route];
}
