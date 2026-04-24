import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_data.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_profile.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_settings.dart';

class UserDataModel {
  const UserDataModel({required this.profile, required this.settings});

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    final profileJson = json['profile'] as Map<String, dynamic>;
    final settingsJson = json['settings'] as Map<String, dynamic>;
    return UserDataModel(
      profile: UserProfile(
        sub: profileJson['sub'] as String,
        name: profileJson['name'] as String?,
        email: profileJson['email'] as String?,
        emailVerified: profileJson['email_verified'] as bool?,
      ),
      settings: UserSettings(
        preferredLlm: settingsJson['preferred_llm'] as String?,
        defaultTargets: settingsJson['default_targets'] != null
            ? Map<String, dynamic>.from(settingsJson['default_targets'] as Map)
            : null,
      ),
    );
  }

  final UserProfile profile;
  final UserSettings settings;

  UserData toEntity() => UserData(profile: profile, settings: settings);
}
