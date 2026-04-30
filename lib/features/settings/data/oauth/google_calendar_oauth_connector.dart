import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/app/router.dart';
import 'package:isef01_second_brain_frontend/core/auth/platform/browser_redirect_stub.dart'
    if (dart.library.js_interop) 'package:isef01_second_brain_frontend/core/auth/platform/browser_redirect_web.dart';
import 'package:isef01_second_brain_frontend/core/auth/platform/pkce_storage_stub.dart'
    if (dart.library.js_interop) 'package:isef01_second_brain_frontend/core/auth/platform/pkce_storage_web.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/core/utils/app_config.dart';
import 'package:isef01_second_brain_frontend/features/settings/data/datasources/auth_remote_datasource.dart';
import 'package:isef01_second_brain_frontend/features/settings/data/datasources/config_remote_datasource.dart';
import 'package:isef01_second_brain_frontend/features/settings/data/oauth/oauth_pkce.dart';

@lazySingleton
class GoogleCalendarOAuthConnector {
  const GoogleCalendarOAuthConnector(this._configDs, this._authDs);

  final ConfigRemoteDatasource _configDs;
  final AuthRemoteDatasource _authDs;

  static const _serviceKey = 'google_calendar';
  static const _authorizationEndpoint =
      'https://accounts.google.com/o/oauth2/v2/auth';
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

  Future<Failure?> complete(Uri callbackUri) async {
    final state = callbackUri.queryParameters['state'];
    final code = callbackUri.queryParameters['code'];
    final verifier = pkceRead(_verifierStorageKey);
    final expectedState = pkceRead(_stateStorageKey);

    try {
      if (callbackUri.queryParameters.containsKey('error')) {
        return AuthFailure(describeOAuthCallbackError(callbackUri));
      }
      if (verifier == null || expectedState == null) {
        return const AuthFailure(
          'Der Google-Connect-Flow ist nicht mehr gueltig. Bitte erneut verbinden.',
        );
      }
      if (state != expectedState) {
        return const AuthFailure(
          'Ungueltiger Google-Callback erkannt. Bitte erneut verbinden.',
        );
      }
      if (code == null || code.isEmpty) {
        return const AuthFailure(
          'Google hat keinen Authorization Code zurueckgegeben.',
        );
      }

      await _authDs.exchangeGoogleToken(
        code: code,
        codeVerifier: verifier,
        redirectUri: _redirectUri,
      );
      return null;
    } on DioException catch (e) {
      final detail = (e.response?.data as Map<String, dynamic>?)?['detail']
          ?.toString();
      return AuthFailure(detail ?? 'Google-Token-Austausch fehlgeschlagen.');
    } catch (e) {
      return AuthFailure('Google-Token-Austausch fehlgeschlagen: $e');
    } finally {
      pkceDelete(_verifierStorageKey);
      pkceDelete(_stateStorageKey);
    }
  }

  Future<String> _resolveClientId() async {
    try {
      final config = await _configDs.getOAuthConfig();
      if (config.googleCalendarClientId.isNotEmpty) {
        return config.googleCalendarClientId;
      }
    } catch (_) {
      // ignore - fall through to dart-define fallback
    }
    return AppConfig.googleCalendarClientId;
  }

  String get _redirectUri {
    if (AppConfig.googleCalendarRedirectUri.isNotEmpty) {
      return AppConfig.googleCalendarRedirectUri;
    }
    return '${Uri.base.origin}${AppRoutes.googleCalendarCallback}';
  }
}
