import 'package:cine_verse/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';


class AuthNotifier extends ChangeNotifier {
  final AuthRepository _repository;
  UserEntity? _user;

  AuthNotifier(this._repository) {
    _checkInitialAuth();
  }

  UserEntity? get user => _user;
  bool get isAuthenticated => _user != null;


  Future<void> _checkInitialAuth() async {
    _user = await _repository.getCurrentUser();
    notifyListeners();
  }

  bool _isLoading = false;
  String _errorMessage = '';
  String _verificationId = '';

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  String get verificationId => _verificationId;

  Future<void> signIn(
    String email,
    String password, {
    VoidCallback? onSuccess,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await _repository.signInWithEmail(email, password);

    await result.fold(
      (failure) async {
        _errorMessage = failure.message;
      },
      (userEntity) async {
        _user = userEntity;
        // СОХРАНЕНИЕ В DATABASE
        await _repository.saveUserToDatabase(userEntity, 'email');

        _isLoading = false;
        notifyListeners();

        if (onSuccess != null) onSuccess();
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle({VoidCallback? onSuccess}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await _repository.signInWithGoogle();

    await result.fold(
      (failure) async {
        // Проверка, если ошибка говорит, что такой email уже есть
        if (failure.message.contains('account-exists-with-different-credential')) {
          await _handleLinking(onSuccess);
        } else {
          _errorMessage = failure.message;
          _isLoading = false; // Останавливаем загрузку при ошибке
          notifyListeners();
        }
      },
      (user) async {
        await _repository.saveUserToDatabase(user, 'google');
        _user = user;
        _isLoading = false; // Сначала останавливаем загрузку и уведомляем слушателей
        notifyListeners();

        if (onSuccess != null) {
          Future.microtask(() => onSuccess());
        }
      },
    );
  }

  Future<void> verifyPhoneNumber(
    String phone, {
    required VoidCallback onCodeSent,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    await _repository.verifyPhoneNumber(
      phoneNumber: phone,
      onCodeSent: (id) {
        _verificationId = id;
        _isLoading = false;
        notifyListeners();
        onCodeSent();
      },
      onError: (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> confirmOtp(
    String smsCode, {
    required VoidCallback onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _repository.signInWithOtp(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    await result.fold(
      (failure) async {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (user) async {
        await _repository.saveUserToDatabase(user, 'phone');
        _user = user;
        _isLoading = false;
        notifyListeners();
        if (onSuccess != null) onSuccess();
      },
    );
  }

  Future<void> logout() async {
    await _repository.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> _handleLinking(VoidCallback? onSuccess) async {
    try {
      final result = await _repository.signInWithGoogle();

      await result.fold(
            (failure) async {
          _errorMessage = failure.message;
          _isLoading = false;
          notifyListeners();
        },
            (user) async {
          await _repository.saveUserToDatabase(user, 'google');
          _user = user;
          _isLoading = false;
          notifyListeners();

          if (onSuccess != null) {
            Future.microtask(() => onSuccess());
          }
        },
      );
    } catch (e) {
      _errorMessage = "Ошибка привязки аккаунта";
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateProfile({String? name, String? imageUrl, String? link}) {
    if (_user != null) {
      _user = _user!.copyWith(
        name: name,
        photoURL: imageUrl,
        userLink: link,
      );
      notifyListeners(); // Теперь AppBar и ProfilePage обновятся мгновенно
    }
  }
}
