import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ndembo/features/game_selection/presentation/pages/game_selection_screen.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ndembo',
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (context) => getIt<HomeBloc>()..add(LoadHomeData()),
        child: const GameSelectionScreen(),
      ),
    );
  }
}
