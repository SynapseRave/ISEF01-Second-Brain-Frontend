/// Zentraler Zugriffspunkt für alle --dart-define Konfigurationswerte.
///
/// Werte werden beim Build/Run von außen übergeben:
///   flutter run --dart-define=API_BASE_URL=http://localhost:8080
///
/// Niemals Secrets oder URLs hardcoden — immer über diese Klasse.
abstract final class AppConfig {
  /// Basis-URL des Second Brain Backends.
  /// Beispiel: http://localhost:8080 (dev), https://api.secondbrain.app (prod)
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  /// Basis-URL des Keycloak-Servers.
  static const keycloakUrl = String.fromEnvironment(
    'KEYCLOAK_URL',
    defaultValue: 'http://localhost:8180',
  );

  /// Name des Keycloak-Realms.
  static const keycloakRealm = String.fromEnvironment(
    'KEYCLOAK_REALM',
    defaultValue: 'second-brain',
  );

  /// Client-ID der Flutter-App in Keycloak.
  static const keycloakClientId = String.fromEnvironment(
    'KEYCLOAK_CLIENT_ID',
    defaultValue: 'frontend',
  );

  /// Redirect-URI die nach dem Keycloak-Login aufgerufen wird.
  /// Muss exakt so in Keycloak als "Valid Redirect URI" eingetragen sein.
  /// Dev-Start: flutter run -d chrome --web-port=3000
  static const redirectUri = String.fromEnvironment(
    'REDIRECT_URI',
    defaultValue: 'http://localhost:3000',
  );

  /// true wenn die App im Debug-Modus läuft (flutter run, nicht flutter build).
  static const isDebug = bool.fromEnvironment(
    'dart.vm.product',
    defaultValue: true,
  );
}
