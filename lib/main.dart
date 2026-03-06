import 'package:cine_verse/features/auth/presentation/controllers/auth_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/dependency_injection.dart';
import 'features/auth/presentation/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => sl<AuthNotifier>())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cine Verse',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        ),
        home: LoginPage(),
      ),
    );
  }
}
