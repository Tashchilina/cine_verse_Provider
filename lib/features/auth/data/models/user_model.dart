import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../domain/entities/user.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.lastLogin,
    required super.method,
    super.providers,
    super.displayName,
    super.photoURL,
  });

  factory UserModel.fromFirebase(firebase.User firebaseUser, String authMethod) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      // Используем время последнего входа из метаданных Firebase
      lastLogin: firebaseUser.metadata.lastSignInTime?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      method: authMethod, // Передаем метод (google, email и т.д.)
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      providers: firebaseUser.providerData.map((info) => info.providerId).toList(),
    );
  }

  // Метод для сохранения в Database (Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'lastLogin': lastLogin,
      'method': method,
      'displayName': displayName,
      'photoURL': photoURL,
      'providers': providers,
      'updatedAt': DateTime.now().toIso8601String(), // Полезно для аналитики
    };
  }
}