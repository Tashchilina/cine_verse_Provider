class UserEntity {
  final String id;
  final String name;
  final String email;
  final String lastLogin;
  final String method;
  final List<String>? providers;
  final String? displayName;
  final String? photoURL;
  final String? userLink;
  final String? localPhotoPath;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.lastLogin,
    required this.method,
    this.providers,
    this.displayName,
    this.photoURL,
    this.userLink,
    this.localPhotoPath,
  });

  UserEntity copyWith({
    String? name,
    String? photoURL,
    String? userLink,
    String? localPhotoPath,
  }) {
    return UserEntity(
      id: this.id,
      email: this.email,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
      userLink: userLink ?? this.userLink,
      lastLogin: this.lastLogin,
      method: this.method,
      providers: providers ?? this.providers,
      displayName: displayName ?? this.displayName,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
    );
  }
}