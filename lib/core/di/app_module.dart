import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/api/api_client.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_interceptor.dart';
import 'package:isef01_second_brain_frontend/core/auth/refresh_interceptor.dart';

/// Registriert Drittanbieter-Klassen im DI-Container.
@module
abstract class AppModule {
  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();

  /// `RefreshInterceptor` holt Dio lazy über `sl<Dio>()` — kein Kreisschluss.
  @lazySingleton
  Dio dio(AuthInterceptor auth, RefreshInterceptor refresh) =>
      createApiClient(auth, refresh);
}
