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
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart'
    as _i3001;
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i3002;
import '../../features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i3003;
import '../../features/dashboard/domain/usecases/get_dashboard_items_usecase.dart'
    as _i3004;
import '../../features/dashboard/presentation/bloc/dashboard_cubit.dart'
    as _i3005;
import '../../features/chat/data/datasources/chat_remote_datasource.dart'
    as _i2001;
import '../../features/chat/data/repositories/chat_repository_impl.dart'
    as _i2002;
import '../../features/chat/domain/repositories/chat_repository.dart' as _i2003;
import '../../features/chat/domain/usecases/send_message_usecase.dart'
    as _i2004;
import '../../features/chat/presentation/bloc/chat_cubit.dart' as _i2005;
import '../../features/history/data/datasources/history_remote_datasource.dart'
    as _i4001;
import '../../features/history/data/repositories/history_repository_impl.dart'
    as _i4002;
import '../../features/history/domain/repositories/history_repository.dart'
    as _i4003;
import '../../features/history/presentation/bloc/history_cubit.dart' as _i4004;
import '../../features/settings/data/datasources/auth_remote_datasource.dart'
    as _i448;
import '../../features/settings/data/datasources/config_remote_datasource.dart'
    as _i620;
import '../../features/settings/data/datasources/settings_remote_datasource.dart'
    as _i944;
import '../../features/settings/data/oauth/google_calendar_oauth_connector.dart'
    as _i1740;
import '../../features/settings/data/oauth/onenote_oauth_connector.dart'
    as _i877;
import '../../features/settings/data/repositories/settings_repository_impl.dart'
    as _i943;
import '../../features/settings/domain/repositories/settings_repository.dart'
    as _i1049;
import '../../features/settings/domain/usecases/connect_service_usecase.dart'
    as _i519;
import '../../features/settings/domain/usecases/disconnect_service_usecase.dart'
    as _i159;
import '../../features/settings/presentation/bloc/settings_cubit.dart' as _i346;
import '../../features/user/data/datasources/user_remote_datasource.dart'
    as _i759;
import '../../features/user/data/repositories/user_repository_impl.dart'
    as _i477;
import '../../features/user/domain/repositories/user_repository.dart' as _i110;
import '../../features/user/domain/usecases/get_user_usecase.dart' as _i710;
import '../../features/user/domain/usecases/update_user_usecase.dart' as _i1041;
import '../../features/user/presentation/bloc/user_cubit.dart' as _i305;
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
    gh.lazySingleton<_i3001.DashboardRemoteDatasource>(
      () => _i3001.DashboardRemoteDatasourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i3003.DashboardRepository>(
      () => _i3002.DashboardRepositoryImpl(
        gh<_i3001.DashboardRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i3004.GetDashboardItemsUseCase>(
      () => _i3004.GetDashboardItemsUseCase(gh<_i3003.DashboardRepository>()),
    );
    gh.factory<_i3005.DashboardCubit>(
      () => _i3005.DashboardCubit(gh<_i3004.GetDashboardItemsUseCase>()),
    );
    gh.lazySingleton<_i2001.ChatRemoteDatasource>(
      () => _i2001.ChatRemoteDatasourceImpl(gh<_i778.AuthRepository>()),
    );
    gh.lazySingleton<_i2003.ChatRepository>(
      () => _i2002.ChatRepositoryImpl(gh<_i2001.ChatRemoteDatasource>()),
    );
    gh.lazySingleton<_i2004.SendMessageUseCase>(
      () => _i2004.SendMessageUseCase(gh<_i2003.ChatRepository>()),
    );
    gh.factory<_i2005.ChatCubit>(
      () => _i2005.ChatCubit(gh<_i2004.SendMessageUseCase>()),
    );
    gh.lazySingleton<_i4001.HistoryRemoteDatasource>(
      () => _i4001.HistoryRemoteDatasourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i4003.HistoryRepository>(
      () => _i4002.HistoryRepositoryImpl(gh<_i4001.HistoryRemoteDatasource>()),
    );
    gh.factory<_i4004.HistoryCubit>(
      () => _i4004.HistoryCubit(gh<_i4003.HistoryRepository>()),
    );
    gh.lazySingleton<_i448.AuthRemoteDatasource>(
      () => _i448.AuthRemoteDatasourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i620.ConfigRemoteDatasource>(
      () => _i620.ConfigRemoteDatasourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i944.SettingsRemoteDatasource>(
      () => _i944.SettingsRemoteDatasourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1049.SettingsRepository>(
      () => _i943.SettingsRepositoryImpl(gh<_i944.SettingsRemoteDatasource>()),
    );
    gh.lazySingleton<_i519.ConnectServiceUseCase>(
      () => _i519.ConnectServiceUseCase(gh<_i1049.SettingsRepository>()),
    );
    gh.lazySingleton<_i159.DisconnectServiceUseCase>(
      () => _i159.DisconnectServiceUseCase(gh<_i1049.SettingsRepository>()),
    );
    gh.lazySingleton<_i1740.GoogleCalendarOAuthConnector>(
      () => _i1740.GoogleCalendarOAuthConnector(
        gh<_i620.ConfigRemoteDatasource>(),
        gh<_i448.AuthRemoteDatasource>(),
      ),
    );
    gh.lazySingleton<_i877.OneNoteOAuthConnector>(
      () => _i877.OneNoteOAuthConnector(gh<_i620.ConfigRemoteDatasource>()),
    );
    gh.lazySingleton<_i346.SettingsCubit>(
      () => _i346.SettingsCubit(
        gh<_i1049.SettingsRepository>(),
        gh<_i519.ConnectServiceUseCase>(),
        gh<_i159.DisconnectServiceUseCase>(),
        gh<_i1740.GoogleCalendarOAuthConnector>(),
        gh<_i877.OneNoteOAuthConnector>(),
      ),
    );
    gh.lazySingleton<_i759.UserRemoteDatasource>(
      () => _i759.UserRemoteDatasourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i110.UserRepository>(
      () => _i477.UserRepositoryImpl(gh<_i759.UserRemoteDatasource>()),
    );
    gh.lazySingleton<_i710.GetUserUseCase>(
      () => _i710.GetUserUseCase(gh<_i110.UserRepository>()),
    );
    gh.lazySingleton<_i1041.UpdateUserUseCase>(
      () => _i1041.UpdateUserUseCase(gh<_i110.UserRepository>()),
    );
    gh.lazySingleton<_i305.UserCubit>(
      () => _i305.UserCubit(
        gh<_i710.GetUserUseCase>(),
        gh<_i1041.UpdateUserUseCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
