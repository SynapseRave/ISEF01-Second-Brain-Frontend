import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

abstract final class OAuthPkce {
  static String randomBase64(int byteCount) {
    final bytes = List<int>.generate(
      byteCount,
      (_) => Random.secure().nextInt(256),
    );
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  static String s256Challenge(String verifier) {
    final digest = sha256.convert(utf8.encode(verifier));
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }
}

String describeOAuthCallbackError(Uri uri) {
  final description = uri.queryParameters['error_description'];
  final error = uri.queryParameters['error'];
  if (description != null && description.isNotEmpty) {
    return description;
  }
  if (error != null && error.isNotEmpty) {
    return error;
  }
  return 'OAuth-Flow wurde abgebrochen oder ist fehlgeschlagen.';
}

String describeTokenExchangeError(
  Map<String, dynamic>? body, {
  required String fallback,
}) {
  if (body == null) return fallback;
  final description = body['error_description']?.toString();
  if (description != null && description.isNotEmpty) return description;
  final message = body['error']?.toString();
  if (message != null && message.isNotEmpty) return message;
  return fallback;
}
