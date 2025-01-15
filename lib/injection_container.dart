import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'features/home/data/datasources/game_remote_data_source.dart';
import 'features/home/data/repositories/game_repository_impl.dart';
import 'features/home/domain/repositories/game_repository.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() => init(getIt);

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio(BaseOptions(
        baseUrl: 'https://api.example.com', // Replace with your API URL
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ));
}

@module
abstract class AppModule {
  @Injectable(as: GameRepository)
  GameRepositoryImpl gameRepository(GameRemoteDataSource dataSource) =>
      GameRepositoryImpl(remoteDataSource: dataSource);

  @Injectable(as: GameRemoteDataSource)
  GameRemoteDataSourceImpl gameRemoteDataSource(Dio dio) =>
      GameRemoteDataSourceImpl(dio: dio);
}

@module
abstract class StorageModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}

@injectable
class HomeBlocFactory {
  final GameRepository repository;

  HomeBlocFactory(this.repository);

  HomeBloc create() => HomeBloc(gameRepository: repository);
}

