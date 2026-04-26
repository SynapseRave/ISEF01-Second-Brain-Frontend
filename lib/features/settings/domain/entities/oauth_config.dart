class OAuthConfig {
  const OAuthConfig({
    required this.googleCalendarClientId,
    required this.microsoftClientId,
    required this.microsoftTenantId,
  });

  final String googleCalendarClientId;
  final String microsoftClientId;
  final String microsoftTenantId;
}
