import 'package:isef01_second_brain_frontend/core/error/failure.dart';

abstract interface class AuthRepository {
  /// Startet den Authorization Code Flow + PKCE via Keycloak.
  /// Gibt [AuthFailure] zurück wenn der Login fehlschlägt, sonst null.
  Future<AuthFailure?> login();

  /// Revokiert alle Tokens und löscht den lokalen State.
  Future<void> logout();

  /// Gibt das aktuelle Access Token zurück — führt ggf. einen Silent Refresh
  /// durch wenn das Token bald abläuft (< 60 s Restlaufzeit).
  /// Gibt null zurück wenn keine gültige Session existiert.
  Future<String?> getAccessToken();

  /// Tauscht das gespeicherte Refresh Token gegen ein neues Access Token.
  /// Gibt true bei Erfolg, false wenn der Refresh fehlschlägt (Session abgelaufen).
  Future<bool> refreshToken();

  /// Ablaufzeitpunkt des aktuellen Access Tokens — null wenn kein Token im Speicher.
  DateTime? get tokenExpiry;

  /// Stream der Auth-Events: true = authentifiziert, false = abgemeldet.
  Stream<bool> get authStateChanges;

  /// Gibt true zurück wenn die aktuelle URL einen Keycloak-Callback enthält
  /// (d.h. die App wurde nach dem Login-Redirect neu geladen).
  bool get hasAuthCallback;
}
