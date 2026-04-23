import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_profile.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_settings.dart';

class UserData {
  const UserData({required this.profile, required this.settings});

  final UserProfile profile;
  final UserSettings settings;
}
