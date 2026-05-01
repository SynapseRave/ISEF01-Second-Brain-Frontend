import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_repository.dart';
import 'package:isef01_second_brain_frontend/core/auth/platform/browser_redirect_stub.dart'
    if (dart.library.js_interop) 'package:isef01_second_brain_frontend/core/auth/platform/browser_redirect_web.dart';
import 'package:isef01_second_brain_frontend/core/auth/platform/clear_url_stub.dart'
    if (dart.library.js_interop) 'package:isef01_second_brain_frontend/core/auth/platform/clear_url_web.dart';
import 'package:isef01_second_brain_frontend/core/auth/platform/pkce_storage_stub.dart'
    if (dart.library.js_interop) 'package:isef01_second_brain_frontend/core/auth/platform/pkce_storage_web.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/core/utils/app_config.dart';
import 'package:openid_client/openid_client.dart';

/// PKCE Authorization Code Flow für Flutter Web.
///
/// Ablauf:
///  1. login()      → PKCE erzeugen, speichern, Browser zu Keycloak weiterleiten.
///  2. App-Reload   → Keycloak leitet zurück mit ?code=…&state=…
///  3. initialize() → erkennt Callback, ruft login() → Code gegen Token tauschen.
///
/// Tokens: Access Token im RAM, Refresh Token in flutter_secure_storage.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const _refreshTokenKey = 'auth_refresh_token';
  static const _pkceVerifierKey = 'pkce_code_verifier';
  static const _pkceStateKey = 'pkce_state';

  String? _accessToken;
  DateTime? _accessTokenExpiry;

  final _authController = StreamController<bool>.broadcast();
  OpenIdProviderMetadata? _metadata;

  @override
  Stream<bool> get authStateChanges => _authController.stream;

  @override
  DateTime? get tokenExpiry => _accessTokenExpiry;

  @override
  bool get hasAuthCallback =>
      _isOnAuthRedirectUri &&
      _hasPendingPkce &&
      (_hasAuthorizationCodeCallback || _hasAuthorizationErrorCallback);

  // ── OIDC Discovery ────────────────────────────────────────────────────────

  Future<OpenIdProviderMetadata> _getMetadata() async {
    if (_metadata != null) return _metadata!;
    final issuer = await Issuer.discover(
      Uri.parse('${AppConfig.keycloakUrl}/realms/${AppConfig.keycloakRealm}'),
    );
    return _metadata = issuer.metadata;
  }

  // ── PKCE ─────────────────────────────────────────────────────────────────

  static String _randomBase64(int byteCount) {
    final bytes = List<int>.generate(
      byteCount,
      (_) => Random.secure().nextInt(256),
    );
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  static String _s256Challenge(String verifier) {
    final digest = sha256.convert(utf8.encode(verifier));
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  // ── Auth Flow ─────────────────────────────────────────────────────────────

  @override
  Future<AuthFailure?> login() async {
    if (_hasPendingPkce) {
      if (_hasAuthorizationErrorCallback) {
        _clearPkceState();
        return AuthFailure(_describeCallbackError(Uri.base));
      }

      final callbackCode = Uri.base.queryParameters['code'];
      if (callbackCode != null) {
        return _exchangeCode(callbackCode);
      }
    }

    return _redirectToKeycloak();
  }

  Future<AuthFailure?> _redirectToKeycloak() async {
    try {
      final verifier = _randomBase64(32);
      final state = _randomBase64(16);

      pkceWrite(_pkceVerifierKey, verifier);
      pkceWrite(_pkceStateKey, state);

      final meta = await _getMetadata();
      final authUri = meta.authorizationEndpoint.replace(
        queryParameters: {
          'client_id': AppConfig.keycloakClientId,
          'redirect_uri': AppConfig.redirectUri,
          'response_type': 'code',
          'scope': 'openid profile email',
          'state': state,
          'code_challenge': _s256Challenge(verifier),
          'code_challenge_method': 'S256',
        },
      );

      redirectBrowser(authUri.toString());
      return null; // Wird auf Web nie erreicht (Browser navigiert weg).
    } catch (e) {
      return AuthFailure('Weiterleitung zu Keycloak fehlgeschlagen: $e');
    }
  }

  Future<AuthFailure?> _exchangeCode(String code) async {
    try {
      final verifier = pkceRead(_pkceVerifierKey);
      final expectedState = pkceRead(_pkceStateKey);
      final returnedState = Uri.base.queryParameters['state'];
      if (verifier == null) {
        _clearPkceState();
        return const AuthFailure(
          'PKCE Code Verifier fehlt — bitte erneut anmelden.',
        );
      }
      if (expectedState == null || returnedState != expectedState) {
        _clearPkceState();
        return const AuthFailure(
          'Ungültiger Login-Callback — bitte erneut anmelden.',
        );
      }

      _clearPkceState();

      final meta = await _getMetadata();
      final response = await http.post(
        meta.tokenEndpoint!,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'client_id': AppConfig.keycloakClientId,
          'redirect_uri': AppConfig.redirectUri,
          'code': code,
          'code_verifier': verifier,
        },
      );

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return AuthFailure(
          body['error_description']?.toString() ??
              'Token-Austausch fehlgeschlagen.',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _applyTokenData(data);
      clearCallbackUrl();

      if (data['refresh_token'] != null) {
        await _secureStorage.write(
          key: _refreshTokenKey,
          value: data['refresh_token'] as String,
        );
      }

      _authController.add(true);
      return null;
    } catch (e) {
      final message = e.toString();
      if (message.contains('XMLHttpRequest error') ||
          message.contains('Failed to fetch') ||
          message.contains('ClientException')) {
        return const AuthFailure(
          'Token-Austausch mit Keycloak wurde vom Browser blockiert. Bitte Web Origins und Redirect URIs im Keycloak-Client pruefen.',
        );
      }
      return AuthFailure('Token-Austausch fehlgeschlagen: $e');
    }
  }

  @override
  Future<void> logout() async {
    _accessToken = null;
    _accessTokenExpiry = null;
    _clearPkceState();
    await _secureStorage.delete(key: _refreshTokenKey);
    _authController.add(false);
  }

  @override
  Future<String?> getAccessToken() async {
    if (_isTokenValid()) return _accessToken;
    final refreshed = await refreshToken();
    return refreshed ? _accessToken : null;
  }

  @override
  Future<bool> refreshToken() async {
    final storedRefresh = await _secureStorage.read(key: _refreshTokenKey);
    if (storedRefresh == null) {
      _authController.add(false);
      return false;
    }

    try {
      final meta = await _getMetadata();
      final response = await http.post(
        meta.tokenEndpoint!,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'refresh_token',
          'client_id': AppConfig.keycloakClientId,
          'refresh_token': storedRefresh,
        },
      );

      if (response.statusCode != 200) {
        await logout();
        return false;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _applyTokenData(data);

      if (data['refresh_token'] != null) {
        await _secureStorage.write(
          key: _refreshTokenKey,
          value: data['refresh_token'] as String,
        );
      }

      _authController.add(true);
      return true;
    } catch (_) {
      await logout();
      return false;
    }
  }

  void _applyTokenData(Map<String, dynamic> data) {
    _accessToken = data['access_token'] as String?;
    final expiresIn = data['expires_in'];
    if (expiresIn != null) {
      _accessTokenExpiry = DateTime.now().add(
        Duration(seconds: (expiresIn as num).toInt()),
      );
    }
  }

  bool _isTokenValid() {
    if (_accessToken == null || _accessTokenExpiry == null) return false;
    return _accessTokenExpiry!.difference(DateTime.now()).inSeconds > 60;
  }

  bool get _hasPendingPkce =>
      pkceRead(_pkceVerifierKey) != null || pkceRead(_pkceStateKey) != null;

  bool get _hasAuthorizationCodeCallback =>
      Uri.base.queryParameters.containsKey('code');

  bool get _hasAuthorizationErrorCallback =>
      Uri.base.queryParameters.containsKey('error');

  bool get _isOnAuthRedirectUri {
    final expected = Uri.parse(AppConfig.redirectUri);
    final current = Uri.base;
    // Uri.parse('http://host') → path == "", Uri.base on '/' → path == "/".
    // Treat both as equivalent root paths.
    final expectedPath = expected.path.isEmpty ? '/' : expected.path;
    final currentPath = current.path.isEmpty ? '/' : current.path;
    return current.origin == expected.origin && currentPath == expectedPath;
  }

  void _clearPkceState() {
    pkceDelete(_pkceVerifierKey);
    pkceDelete(_pkceStateKey);
  }

  String _describeCallbackError(Uri callbackUri) {
    final description = callbackUri.queryParameters['error_description'];
    if (description != null && description.isNotEmpty) {
      return description;
    }

    final error = callbackUri.queryParameters['error'];
    if (error != null && error.isNotEmpty) {
      return error;
    }

    return 'Login wurde abgebrochen oder ist fehlgeschlagen.';
  }

  void dispose() => _authController.close();
}
