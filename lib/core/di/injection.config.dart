// dart format width=80
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

import '../../features/auth/data/datasources/auth_local_data_source.dart'
    as _i852;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../../features/product/data/datasources/product_remote_data_source.dart'
    as _i1;
import '../../features/product/data/repositories/product_repository_impl.dart'
    as _i1040;
import '../../features/product/domain/repositories/product_repository.dart'
    as _i39;
import '../../features/product/domain/usecases/get_products_usecase.dart'
    as _i1035;
import '../../features/product/presentation/bloc/product_bloc.dart' as _i415;
import '../network/api_client.dart' as _i557;
import '../network/auth_interceptor.dart' as _i908;
import 'injection.dart' as _i464;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.sharedPreferences,
    preResolve: true,
  );
  gh.factory<_i652.DashboardBloc>(() => _i652.DashboardBloc());
  gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
  gh.factory<_i852.AuthLocalDataSource>(
    () => _i852.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
  );
  gh.factory<_i908.AuthInterceptor>(
    () => _i908.AuthInterceptor(gh<_i852.AuthLocalDataSource>()),
  );
  gh.lazySingleton<_i557.ApiClient>(
    () => _i557.ApiClient(gh<_i361.Dio>(), gh<_i908.AuthInterceptor>()),
  );
  gh.factory<_i107.AuthRemoteDataSource>(
    () => _i107.AuthRemoteDataSourceImpl(gh<_i557.ApiClient>()),
  );
  gh.factory<_i1.ProductRemoteDataSource>(
    () => _i1.ProductRemoteDataSourceImpl(gh<_i557.ApiClient>()),
  );
  gh.factory<_i787.AuthRepository>(
    () => _i153.AuthRepositoryImpl(
      remoteDataSource: gh<_i107.AuthRemoteDataSource>(),
      localDataSource: gh<_i852.AuthLocalDataSource>(),
    ),
  );
  gh.factory<_i39.ProductRepository>(
    () => _i1040.ProductRepositoryImpl(
      remoteDataSource: gh<_i1.ProductRemoteDataSource>(),
    ),
  );
  gh.factory<_i188.LoginUseCase>(
    () => _i188.LoginUseCase(gh<_i787.AuthRepository>()),
  );
  gh.factory<_i1035.GetProductsUseCase>(
    () => _i1035.GetProductsUseCase(gh<_i39.ProductRepository>()),
  );
  gh.factory<_i797.AuthBloc>(
    () => _i797.AuthBloc(loginUseCase: gh<_i188.LoginUseCase>()),
  );
  gh.factory<_i415.ProductBloc>(
    () =>
        _i415.ProductBloc(getProductsUseCase: gh<_i1035.GetProductsUseCase>()),
  );
  return getIt;
}

class _$RegisterModule extends _i464.RegisterModule {}
