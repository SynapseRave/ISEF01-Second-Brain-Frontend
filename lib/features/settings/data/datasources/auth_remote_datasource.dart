import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract interface class AuthRemoteDatasource {
  Future<void> exchangeGoogleToken({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  });
}

@LazySingleton(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  const AuthRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> exchangeGoogleToken({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/auth/google/token',
      data: {
        'code': code,
        'code_verifier': codeVerifier,
        'redirect_uri': redirectUri,
      },
    );
  }
}
