import 'package:dio/dio.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';

/// Wandelt eine [DioException] in einen typisierten [Failure] um.
/// Wird in allen Repository-Implementierungen verwendet.
Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionTimeout:
      return const NetworkFailure();
    default:
      return switch (e.response?.statusCode) {
        401 => const AuthFailure(),
        403 => const AuthFailure('Zugriff verweigert.'),
        404 => const NotFoundFailure(),
        409 => const ValidationFailure('Bereits vorhanden.'),
        422 => ValidationFailure(
            _extractDetail(e.response?.data) ?? 'Ungültige Eingabe.',
          ),
        _ => const ServerFailure(),
      };
  }
}

String? _extractDetail(dynamic data) {
  if (data is Map<String, dynamic>) {
    final detail = data['detail'];
    if (detail is String) return detail;
    if (detail is List && detail.isNotEmpty) {
      final first = detail.first;
      if (first is Map) return first['msg']?.toString();
    }
  }
  return null;
}
