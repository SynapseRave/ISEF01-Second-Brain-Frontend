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
import 'package:isef01_second_brain_frontend/features/settings/data/datasources/config_remote_datasource.dart';
import 'package:isef01_second_brain_frontend/features/settings/data/oauth/oauth_pkce.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/oauth_credential_bundle.dart';

@lazySingleton
class GoogleCalendarOAuthConnector {
  const GoogleCalendarOAuthConnector(this._configDs);

  final ConfigRemoteDatasource _configDs;

  static const _serviceKey = 'google_calendar';
  static const _authorizationEndpoint =
      'https://accounts.google.com/o/oauth2/v2/auth';
  static const _tokenEndpoint = 'https://oauth2.googleapis.com/token';
  static const _scopes = 'https://www.googleapis.com/auth/calendar.events';
  static const _verifierStorageKey = '${_serviceKey}_pkce_verifier';
  static const _stateStorageKey = '${_serviceKey}_oauth_state';

  Future<Failure?> start() async {
    final clientId = await _resolveClientId();
    if (clientId.isEmpty) {
      return const ValidationFailure(
        'GOOGLE_CALENDAR_CLIENT_ID ist weder im Backend noch in den dart-defines konfiguriert.',
      );
    }

    try {
      final verifier = OAuthPkce.randomBase64(32);
      final state = OAuthPkce.randomBase64(16);
      pkceWrite(_verifierStorageKey, verifier);
      pkceWrite(_stateStorageKey, state);

      final authUri = Uri.parse(_authorizationEndpoint).replace(
        queryParameters: {
          'client_id': clientId,
          'redirect_uri': _redirectUri,
          'response_type': 'code',
          'scope': _scopes,
          'access_type': 'offline',
          'include_granted_scopes': 'true',
          'prompt': 'consent',
          'state': state,
          'code_challenge': OAuthPkce.s256Challenge(verifier),
          'code_challenge_method': 'S256',
        },
      );

      redirectBrowser(authUri.toString());
      return null;
    } catch (e) {
      return AuthFailure(
        'Google Calendar Connect konnte nicht gestartet werden: $e',
      );
    }
  }

  Future<(OAuthCredentialBundle?, Failure?)> complete(Uri callbackUri) async {
    final state = callbackUri.queryParameters['state'];
    final code = callbackUri.queryParameters['code'];
    final verifier = pkceRead(_verifierStorageKey);
    final expectedState = pkceRead(_stateStorageKey);

    try {
      if (callbackUri.queryParameters.containsKey('error')) {
        return (null, AuthFailure(describeOAuthCallbackError(callbackUri)));
      }
      if (verifier == null || expectedState == null) {
        return (
          null,
          const AuthFailure(
            'Der Google-Connect-Flow ist nicht mehr gültig. Bitte erneut verbinden.',
          ),
        );
      }
      if (state != expectedState) {
        return (
          null,
          const AuthFailure(
            'Ungültiger Google-Callback erkannt. Bitte erneut verbinden.',
          ),
        );
      }
      if (code == null || code.isEmpty) {
        return (
          null,
          const AuthFailure(
            'Google hat keinen Authorization Code zurückgegeben.',
          ),
        );
      }

      final clientId = await _resolveClientId();

      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': clientId,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': _redirectUri,
          'code_verifier': verifier,
        },
      );

      final body = _decodeBody(response.body);
      if (response.statusCode != 200) {
        return (
          null,
          AuthFailure(
            describeTokenExchangeError(
              body,
              fallback: 'Google-Token-Austausch fehlgeschlagen.',
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
            'Google hat keine vollständigen Tokens zurückgegeben.',
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
      return (null, AuthFailure('Google-Token-Austausch fehlgeschlagen: $e'));
    } finally {
      pkceDelete(_verifierStorageKey);
      pkceDelete(_stateStorageKey);
    }
  }

  /// Fetches the client ID from the backend at runtime.
  /// Falls back to the dart-define value for local development.
  Future<String> _resolveClientId() async {
    try {
      final config = await _configDs.getOAuthConfig();
      if (config.googleCalendarClientId.isNotEmpty) {
        return config.googleCalendarClientId;
      }
    } catch (_) {
      // ignore — fall through to dart-define fallback
    }
    return AppConfig.googleCalendarClientId;
  }

  String get _redirectUri {
    if (AppConfig.googleCalendarRedirectUri.isNotEmpty) {
      return AppConfig.googleCalendarRedirectUri;
    }
    return '${Uri.base.origin}${AppRoutes.googleCalendarCallback}';
  }

  Map<String, dynamic>? _decodeBody(String body) {
    if (body.isEmpty) return null;
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : null;
  }
}
