class UserSettings {
  const UserSettings({this.preferredLlm, this.defaultTargets});

  final String? preferredLlm;
  final Map<String, dynamic>? defaultTargets;
}
