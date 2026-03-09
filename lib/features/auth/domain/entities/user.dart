class UserEntity {
  final String id;
  final String email;
  final String lastLogin;
  final String method;
  final List<String>? providers;
  final String? displayName;
  final String? photoURL;

  const UserEntity({
    required this.id,
    required this.email,
    required this.lastLogin,
    required this.method,
    this.providers,
    this.displayName,
    this.photoURL,
  });
}