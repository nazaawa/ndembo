import 'package:injectable/injectable.dart';
import 'package:ndembo/features/home/domain/entities/game_type.dart';
import '../models/game_model.dart';

@injectable
class CardGamesDataSource {
  List<GameModel> getCardGames() {
    return [
      GameModel(
        id: 'bataille',
        title: 'Bataille',
        description:
            'Un jeu où deux joueurs comparent la valeur de leurs cartes. La carte la plus haute gagne.',
        imageUrl: 'assets/images/bataille.png',
        isFeatured: true,
        gameType: GameType.card,
      ),
      GameModel(
        id: 'blackjack',
        title: 'Blackjack simplifié',
        description: 'Une version simplifiée du célèbre jeu de casino.',
        imageUrl: 'assets/images/blackjack.png',
        isFeatured: true,
        gameType: GameType.card,
      ),
      GameModel(
        id: 'poker',
        title: 'Poker à deux cartes',
        description:
            'Les joueurs parient sur qui a la meilleure main avec seulement deux cartes.',
        imageUrl: 'assets/images/poker.png',
        isFeatured: true,
        gameType: GameType.card,
      ),
    ];
  }
}
