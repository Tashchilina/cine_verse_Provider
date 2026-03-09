import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDatasource(this._firebaseAuth, this._googleSignIn);

  Future<UserCredential> signInWithEmail(String email, String password) async {
    // Здесь rethrow не нужен, так как ошибка сама пробросится в Repository
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // 1. Начинаем процесс выбора аккаунта
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Вход отменен пользователем',
        );
      }

      // 2. Получаем токены аутентификации
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Проверка наличия токенов (защита от крешей)
      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Отсутствуют токены аутентификации Google',
        );
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 3. Авторизуемся в Firebase с полученными данными
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow; // Пробрасываем типизированную ошибку Firebase в репозиторий
    } catch (e) {
      // Если упало что-то специфичное для GoogleSignIn (например, нет сервисов Google)
      throw FirebaseAuthException(
        code: 'google_sign_in_failed',
        message: e.toString(),
      );
    }
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException e) onError,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Можно оставить пустым или реализовать авто-вход
      },
      verificationFailed: onError,
      codeSent: (verificationId, resendToken) => onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<UserCredential> signInWithOtp(
    String verificationId,
    String smsCode,
  ) async {
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    // Изменение: используем signOut для выхода,
    // или disconnect(), если хотим полностью разорвать связь с текущим Google-аккаунтом
    await _googleSignIn.signOut();
  }
}
