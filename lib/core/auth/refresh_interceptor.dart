import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_repository.dart';
import 'package:isef01_second_brain_frontend/core/di/injection.dart';

/// Fängt 401-Antworten ab, versucht einen Silent Refresh und wiederholt
/// den ursprünglichen Request genau einmal mit dem neuen Token.
///
/// Dio wird hier NICHT im Konstruktor injiziert, um die zirkuläre Abhängigkeit
/// (Dio → RefreshInterceptor → Dio) zu vermeiden. Stattdessen lazy via `sl<Dio>()`.
@lazySingleton
class RefreshInterceptor extends Interceptor {
  RefreshInterceptor(this._authRepository);

  final AuthRepository _authRepository;

  // Lazy aufgelöst — nach der DI-Initialisierung garantiert verfügbar.
  Dio get _dio => sl<Dio>();

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final refreshed = await _authRepository.refreshToken();
    if (!refreshed) {
      return handler.next(err);
    }

    final token = await _authRepository.getAccessToken();
    if (token == null) return handler.next(err);

    try {
      final retryOptions = err.requestOptions
        ..headers['Authorization'] = 'Bearer $token';
      final response = await _dio.fetch(retryOptions);
      return handler.resolve(response);
    } on DioException catch (retryErr) {
      return handler.next(retryErr);
    }
  }
}
