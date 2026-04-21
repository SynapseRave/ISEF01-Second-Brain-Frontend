// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../auth/auth_cubit.dart' as _i761;
import '../auth/auth_interceptor.dart' as _i53;
import '../auth/auth_repository.dart' as _i778;
import '../auth/auth_repository_impl.dart' as _i790;
import '../auth/refresh_interceptor.dart' as _i312;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => appModule.flutterSecureStorage,
    );
    gh.lazySingleton<_i778.AuthRepository>(
      () => _i790.AuthRepositoryImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i761.AuthCubit>(
      () => _i761.AuthCubit(gh<_i778.AuthRepository>()),
    );
    gh.lazySingleton<_i53.AuthInterceptor>(
      () => _i53.AuthInterceptor(gh<_i778.AuthRepository>()),
    );
    gh.lazySingleton<_i312.RefreshInterceptor>(
      () => _i312.RefreshInterceptor(gh<_i778.AuthRepository>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => appModule.dio(
        gh<_i53.AuthInterceptor>(),
        gh<_i312.RefreshInterceptor>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
