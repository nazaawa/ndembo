import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:ndembo/features/home/presentation/pages/home_page.dart';
import 'package:ndembo/features/games/presentation/pages/bataille_page.dart';
import 'package:ndembo/features/games/presentation/pages/blackjack_page.dart';
import 'package:ndembo/features/games/presentation/pages/poker_page.dart';

part 'app_router.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<BatailleRoute>(path: 'bataille'),
    TypedGoRoute<BlackjackRoute>(path: 'blackjack'),
    TypedGoRoute<PokerRoute>(path: 'poker'),
  ],
)
@immutable
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

@immutable
class BatailleRoute extends GoRouteData {
  const BatailleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const BataillePage();
}

@immutable
class BlackjackRoute extends GoRouteData {
  const BlackjackRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const BlackjackPage();
}

@immutable
class PokerRoute extends GoRouteData {
  const PokerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const PokerPage();
}

final router = GoRouter(
  routes: $appRoutes,
);
