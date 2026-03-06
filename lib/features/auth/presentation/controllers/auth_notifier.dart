import 'package:cine_verse/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthRepository _repository;

  AuthNotifier(this._repository);

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await _repository.signInWithEmail(email, password);

    result.fold(
      (failure) => _errorMessage = failure.message,
      (user) => /* Навигация на Home */ null,
    );

    _isLoading = false;
    notifyListeners();
  }
}
