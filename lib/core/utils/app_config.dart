/// Zentraler Zugriffspunkt für alle --dart-define Konfigurationswerte.
///
/// Werte werden beim Build/Run von außen übergeben:
///   flutter run --dart-define=API_BASE_URL=http://localhost:8080
///
/// Niemals Secrets oder URLs hardcoden — immer über diese Klasse.
abstract final class AppConfig {
  /// Basis-URL des Second Brain Backends.
  /// Beispiel: http://localhost:8000 (dev), https://api.secondbrain.app (prod)
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// Basis-URL des Keycloak-Servers (Backend-Instanz, Port 8080).
  static const keycloakUrl = String.fromEnvironment(
    'KEYCLOAK_URL',
    defaultValue: 'http://localhost:8080',
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

  /// OAuth Client-ID für Google Calendar.
  static const googleCalendarClientId = String.fromEnvironment(
    'GOOGLE_CALENDAR_CLIENT_ID',
    defaultValue: '',
  );

  /// Optional explizite Redirect-URI für Google Calendar.
  /// Wenn leer, wird zur Laufzeit aus dem aktuellen Origin abgeleitet.
  static const googleCalendarRedirectUri = String.fromEnvironment(
    'GOOGLE_CALENDAR_REDIRECT_URI',
    defaultValue: '',
  );

  /// OAuth Client-ID für Microsoft OneNote.
  static const microsoftClientId = String.fromEnvironment(
    'MICROSOFT_CLIENT_ID',
    defaultValue: '',
  );

  /// Tenant für Microsoft OAuth, z. B. `common`, `organizations` oder Tenant-ID.
  static const microsoftTenantId = String.fromEnvironment(
    'MICROSOFT_TENANT_ID',
    defaultValue: 'common',
  );

  /// Optional explizite Redirect-URI für Microsoft OneNote.
  /// Wenn leer, wird zur Laufzeit aus dem aktuellen Origin abgeleitet.
  static const microsoftRedirectUri = String.fromEnvironment(
    'MICROSOFT_REDIRECT_URI',
    defaultValue: '',
  );

  /// true wenn die App im Debug-Modus läuft (flutter run, nicht flutter build).
  static const isDebug = bool.fromEnvironment(
    'dart.vm.product',
    defaultValue: true,
  );
}
