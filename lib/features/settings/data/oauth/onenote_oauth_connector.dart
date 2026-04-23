import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/app/router.dart';
import 'package:isef01_second_brain_frontend/core/auth/platform/browser_redirect_stub.dart'
    if (dart.library.js_interop) 'package:isef01_second_brain_frontend/core/auth/platform/browser_redirect_web.dart';
import 'package:isef01_second_brain_frontend/core/auth/platform/pkce_storage_stub.dart'
    if (dart.library.js_interop) 'package:isef01_second_brain_frontend/core/auth/platform/pkce_storage_web.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/core/utils/app_config.dart';
import 'package:isef01_second_brain_frontend/features/settings/data/oauth/oauth_pkce.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/oauth_credential_bundle.dart';

@lazySingleton
class OneNoteOAuthConnector {
  static const _serviceKey = 'onenote';
  static const _scopes = 'offline_access openid profile Notes.ReadWrite';
  static const _verifierStorageKey = '${_serviceKey}_pkce_verifier';
  static const _stateStorageKey = '${_serviceKey}_oauth_state';

  Future<Failure?> start() async {
    if (AppConfig.microsoftClientId.isEmpty) {
      return const ValidationFailure(
        'MICROSOFT_CLIENT_ID fehlt in den dart-defines.',
      );
    }

    try {
      final verifier = OAuthPkce.randomBase64(32);
      final state = OAuthPkce.randomBase64(16);
      pkceWrite(_verifierStorageKey, verifier);
      pkceWrite(_stateStorageKey, state);

      final authUri = Uri.parse(_authorizationEndpoint).replace(
        queryParameters: {
          'client_id': AppConfig.microsoftClientId,
          'response_type': 'code',
          'redirect_uri': _redirectUri,
          'response_mode': 'query',
          'scope': _scopes,
          'state': state,
          'code_challenge': OAuthPkce.s256Challenge(verifier),
          'code_challenge_method': 'S256',
        },
      );

      redirectBrowser(authUri.toString());
      return null;
    } catch (e) {
      return AuthFailure('OneNote Connect konnte nicht gestartet werden: $e');
    }
  }

  Future<(OAuthCredentialBundle?, Failure?)> complete(Uri callbackUri) async {
    final state = callbackUri.queryParameters['state'];
    final code = callbackUri.queryParameters['code'];
    final verifier = pkceRead(_verifierStorageKey);
    final expectedState = pkceRead(_stateStorageKey);

    try {
      if (callbackUri.queryParameters.containsKey('error')) {
        return (
          null,
          AuthFailure(describeOAuthCallbackError(callbackUri)),
        );
      }
      if (verifier == null || expectedState == null) {
        return (
          null,
          const AuthFailure(
            'Der OneNote-Connect-Flow ist nicht mehr gültig. Bitte erneut verbinden.',
          ),
        );
      }
      if (state != expectedState) {
        return (
          null,
          const AuthFailure(
            'Ungültiger OneNote-Callback erkannt. Bitte erneut verbinden.',
          ),
        );
      }
      if (code == null || code.isEmpty) {
        return (
          null,
          const AuthFailure(
            'Microsoft hat keinen Authorization Code zurückgegeben.',
          ),
        );
      }

      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': AppConfig.microsoftClientId,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': _redirectUri,
          'code_verifier': verifier,
          'scope': _scopes,
        },
      );

      final body = _decodeBody(response.body);
      if (response.statusCode != 200) {
        return (
          null,
          AuthFailure(
            describeTokenExchangeError(
              body,
              fallback: 'Microsoft-Token-Austausch fehlgeschlagen.',
            ),
          ),
        );
      }

      final accessToken = body?['access_token']?.toString();
      final refreshToken = body?['refresh_token']?.toString();
      final expiresIn = int.tryParse(body?['expires_in']?.toString() ?? '');
      if (accessToken == null || refreshToken == null || expiresIn == null) {
        return (
          null,
          const AuthFailure(
            'Microsoft hat keine vollständigen Tokens zurückgegeben.',
          ),
        );
      }

      return (
        OAuthCredentialBundle(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresAt: DateTime.now().toUtc().add(Duration(seconds: expiresIn)),
        ),
        null,
      );
    } catch (e) {
      return (
        null,
        AuthFailure('Microsoft-Token-Austausch fehlgeschlagen: $e'),
      );
    } finally {
      pkceDelete(_verifierStorageKey);
      pkceDelete(_stateStorageKey);
    }
  }

  String get _authorizationEndpoint =>
      'https://login.microsoftonline.com/${AppConfig.microsoftTenantId}/oauth2/v2.0/authorize';

  String get _tokenEndpoint =>
      'https://login.microsoftonline.com/${AppConfig.microsoftTenantId}/oauth2/v2.0/token';

  String get _redirectUri {
    if (AppConfig.microsoftRedirectUri.isNotEmpty) {
      return AppConfig.microsoftRedirectUri;
    }
    return '${Uri.base.origin}${AppRoutes.oneNoteCallback}';
  }

  Map<String, dynamic>? _decodeBody(String body) {
    if (body.isEmpty) return null;
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : null;
  }
}
