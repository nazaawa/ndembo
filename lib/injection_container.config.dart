// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'core/di/register_module.dart' as _i854;
import 'features/home/data/datasources/card_games_data_source.dart' as _i634;
import 'features/home/data/datasources/game_remote_data_source.dart' as _i628;
import 'features/home/data/datasources/remote_data_source.dart' as _i351;
import 'features/home/data/repositories/game_repository_impl.dart' as _i394;
import 'features/home/domain/repositories/game_repository.dart' as _i72;
import 'features/home/presentation/bloc/home_bloc.dart' as _i123;
import 'injection_container.dart' as _i809;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.sharedPreferences,
    preResolve: true,
  );
  gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
  gh.lazySingleton<_i361.Dio>(
    () => registerModule.dio,
    instanceName: 'BaseClient',
  );
  gh.factory<_i628.GameRemoteDataSource>(
      () => _i628.GameRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.factory<_i72.GameRepository>(() => _i394.GameRepositoryImpl(
      remoteDataSource: gh<_i628.GameRemoteDataSource>()));
  gh.factory<_i809.HomeBlocFactory>(
      () => _i809.HomeBlocFactory(gh<_i72.GameRepository>()));
  gh.factory<_i123.HomeBloc>(
      () => _i123.HomeBloc(gameRepository: gh<_i72.GameRepository>()));
  return getIt;
}

class _$RegisterModule extends _i854.RegisterModule {}

