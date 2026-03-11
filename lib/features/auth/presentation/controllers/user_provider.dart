import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _profileImageUrl;

  String? get profileImageUrl => _profileImageUrl;

  void updateProfileImage(String newPath) {
    _profileImageUrl = newPath;
    notifyListeners();
  }
}