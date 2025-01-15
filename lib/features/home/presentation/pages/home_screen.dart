import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/home_bloc.dart';
import '../widgets/featured_game_card.dart';
import '../widgets/game_list_item.dart';
import '../widgets/search_bar_widget.dart';
import '../../../game_selection/presentation/pages/game_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()..add(LoadHomeData()),
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeError) {
              return Center(child: Text(state.message));
            } else if (state is HomeLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: const Text('Ndembo'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.games),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GameSelectionScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SearchBarWidget(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.featuredGames.length,
                        itemBuilder: (context, index) {
                          final game = state.featuredGames[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: FeaturedGameCard(game: game),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Jeux Populaires',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final game = state.popularGames[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: GameListItem(game: game),
                        );
                      },
                      childCount: state.popularGames.length,
                    ),
                  ),
                ],
              );
            } else if (state is HomeSearchResults) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.games.length,
                itemBuilder: (context, index) {
                  final game = state.games[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GameListItem(game: game),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
