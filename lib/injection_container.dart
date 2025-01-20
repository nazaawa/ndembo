import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
// ignore: duplicate_import
import 'package:injectable/injectable.dart';
import 'features/home/domain/repositories/game_repository.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  await init(getIt);
}




@injectable
class HomeBlocFactory {
  final GameRepository repository;

  HomeBlocFactory(this.repository);

  HomeBloc create() => HomeBloc(gameRepository: repository);
}
