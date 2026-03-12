import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_page.dart';
import '../screens/login/phone_page.dart';
import '../screens/login_page.dart';
import 'auth_notifier.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Слушаем изменения в AuthNotifier
    final authNotifier = context.watch<AuthNotifier>();

    // 1. Если пользователя нет — на вход
    if (authNotifier.user == null) {
      return const LoginPage();
    }
    // 2. Если пользователь есть, но вошел через Google и ждет проверки телефона
    if (authNotifier.isWaitingForPhone) {
      return const PhonePage();
    }
    // 3. Если пользователь есть и телефон не нужен/подтвержден — домой
    return const HomePage();
  }
}
