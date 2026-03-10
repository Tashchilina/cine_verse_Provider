import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_page.dart';
import '../screens/login_page.dart';
import 'auth_notifier.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Слушаем изменения в AuthNotifier
    final authNotifier = context.watch<AuthNotifier>();

    // Если данные пользователя есть — показываем Home, если нет — Login
    if (authNotifier.user != null) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}