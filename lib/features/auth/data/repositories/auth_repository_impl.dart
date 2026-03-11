import 'package:cine_verse/core/errors/failures.dart';
import 'package:cine_verse/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cine_verse/features/auth/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';


class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    required this.remoteDatasource,
  })
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail(
      String email,
      String password,
      ) async {
    try {
      final credential = await remoteDatasource.signInWithEmail(
        email,
        password,
      );
      if (credential.user != null) {
        return Right(UserModel.fromFirebase(credential.user!, 'email'));
      } else {
        return Left(AuthFailure("Пользователь не найден после авторизации"));
      }
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return Left(AuthFailure("Произошла системная ошибка"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return Left(AuthFailure("Вход отменен"));

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        final userCredential = await currentUser.linkWithCredential(credential);
        return Right(UserModel.fromFirebase(userCredential.user!, 'google'));
      }

      try {
        final userCredential = await _firebaseAuth.signInWithCredential(credential);
        return Right(UserModel.fromFirebase(userCredential.user!, 'google'));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          return Left(AuthFailure(
              "Этот email уже зарегистрирован через пароль. Войдите по Email, а затем привяжите Google в профиле."
          ));
        }
        rethrow;
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        return Left(AuthFailure("Этот Google-аккаунт уже привязан к другой учетной записи."));
      }
      return Left(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    await remoteDatasource.signOut();
  }

  // Маппинг ошибок для пользователя
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'invalid-email':
        return 'Некорректный email';
      case 'user-disabled':
        return 'Аккаунт заблокирован';
      case 'ERROR_ABORTED_BY_USER':
        return 'Вход отменен';
      default:
        return 'Ошибка аутентификации ($code)';
    }
  }

  @override // Теперь это корректно переопределяет метод интерфейса
  Future<void> saveUserToDatabase(UserEntity user, String method) async {
    try {
      // Если user это UserModel, у которого есть toJson:
      if (user is UserModel) {
        final data = user.toJson();
        data['last_login'] =
            FieldValue.serverTimestamp(); // Обновляем время на стороне сервера
        data['auth_method'] = method;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .set(data, SetOptions(merge: true));
      } else {
        // Базовый вариант, если это просто Entity
        await FirebaseFirestore.instance.collection('users').doc(user.id).set({
          'email': user.email,
          'last_login': FieldValue.serverTimestamp(),
          'auth_method': method,
          'uid': user.id,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print("Ошибка при записи в БД: $e");
      // Здесь можно пробросить ошибку дальше, если это критично
    }
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(Failure failure) onError,
  }) async {
    await remoteDatasource.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onError: (authException) =>
          onError(AuthFailure(authException.message ?? "Ошибка")),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = await remoteDatasource.signInWithOtp(
        verificationId,
        smsCode,
      );
      return Right(UserModel.fromFirebase(credential.user!, 'phone'));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return Left(AuthFailure("Ошибка входа по коду"));
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      // Здесь 'unknown', так как мы не знаем метод входа при холодном старте,
      // либо можно расширить логику проверки providerData
      return UserModel.fromFirebase(firebaseUser, 'saved_session');
    }
    return null;
  }
}