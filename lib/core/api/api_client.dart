import 'package:dio/dio.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_interceptor.dart';
import 'package:isef01_second_brain_frontend/core/auth/refresh_interceptor.dart';
import 'package:isef01_second_brain_frontend/core/utils/app_config.dart';

/// Erzeugt die fertig konfigurierte Dio-Instanz.
/// Interceptoren-Reihenfolge: Auth → Refresh
/// (Phase 3 ergänzt: Logging, Error-Mapping)
Dio createApiClient(
  AuthInterceptor authInterceptor,
  RefreshInterceptor refreshInterceptor,
) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.addAll([authInterceptor, refreshInterceptor]);
  return dio;
}
