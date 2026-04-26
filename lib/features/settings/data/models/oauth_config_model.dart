import 'package:isef01_second_brain_frontend/features/settings/domain/entities/oauth_config.dart';

class OAuthConfigModel extends OAuthConfig {
  const OAuthConfigModel({
    required super.googleCalendarClientId,
    required super.microsoftClientId,
    required super.microsoftTenantId,
  });

  factory OAuthConfigModel.fromJson(Map<String, dynamic> json) =>
      OAuthConfigModel(
        googleCalendarClientId:
            (json['google_calendar_client_id'] as String?) ?? '',
        microsoftClientId: (json['microsoft_client_id'] as String?) ?? '',
        microsoftTenantId: (json['microsoft_tenant_id'] as String?) ?? 'common',
      );
}
