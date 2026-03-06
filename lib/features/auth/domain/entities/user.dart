class UserEntity {
  final String id;
  final String email;
  final List<String>? providers;
  final String? displayName;
  final String? photoURL;

  const UserEntity({
    required this.id,
    required this.email,
    this.providers,
    this.displayName,
    this.photoURL,
  });
}