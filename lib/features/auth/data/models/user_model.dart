import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name, // Добавлено: обязательное поле из Entity
    required super.email,
    required super.lastLogin,
    required super.method,
    super.providers,
    super.displayName,
    super.photoURL,
    super.userLink, // Добавлено: для хранения ссылки/ника
  });

  factory UserModel.fromFirebase(firebase.User firebaseUser, String authMethod) {
    // Используем displayName или email (до @) как имя по умолчанию, если displayName пуст
    String defaultName = firebaseUser.displayName ??
        firebaseUser.email?.split('@')[0] ??
        'User';

    return UserModel(
      id: firebaseUser.uid,
      name: defaultName,
      email: firebaseUser.email ?? '',
      lastLogin: firebaseUser.metadata.lastSignInTime?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      method: authMethod,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      userLink: null,
      providers: firebaseUser.providerData.map((info) => info.providerId).toList(),
    );
  }


  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'lastLogin': lastLogin,
      'method': method,
      'displayName': displayName,
      'photoURL': photoURL,
      'userLink': userLink,
      'providers': providers,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  // Полезно добавить fromJson, если вы будете подтягивать данные из Firestore
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      lastLogin: json['lastLogin'] ?? '',
      method: json['method'] ?? '',
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      userLink: json['userLink'],
      providers: List<String>.from(json['providers'] ?? []),
    );
  }
}