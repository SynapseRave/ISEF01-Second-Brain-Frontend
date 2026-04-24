class UserProfile {
  const UserProfile({
    required this.sub,
    this.name,
    this.email,
    this.emailVerified,
  });

  final String sub;
  final String? name;
  final String? email;
  final bool? emailVerified;
}
