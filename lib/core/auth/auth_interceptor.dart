import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_repository.dart';

/// Hängt das Bearer Token an jeden ausgehenden Request.
/// Wenn kein Token vorhanden ist, wird der Request trotzdem durchgelassen —
/// der Server antwortet dann mit 401, was der [RefreshInterceptor] behandelt.
@lazySingleton
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authRepository.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
