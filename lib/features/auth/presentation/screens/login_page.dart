import 'package:cine_verse/features/auth/presentation/controllers/auth_notifier.dart';
import 'package:cine_verse/features/auth/presentation/screens/login/phone_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'login/email_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthNotifier>(
        builder: (context, auth, child) {
          if (auth.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/clickerhappy.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.4),

                    // Кнопка Google
                    _buildAuthButton(
                      text: 'Sign in with Google',
                      icon: FontAwesomeIcons.google,
                      onPressed: () {
                        auth.signInWithGoogle(
                            onSuccess: () {
                              if (!mounted) return;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const PhonePage()),
                                );
                              });
                            }
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Кнопка Email
                    _buildAuthButton(
                      text: 'Sign in with Email',
                      icon: Icons.mail,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmailPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // Кнопка Phone
                    _buildAuthButton(
                      text: 'Sign up with Phone',
                      icon: Icons.phone,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PhonePage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Вынес кнопку в метод, чтобы не дублировать код декораций
  Widget _buildAuthButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 350,
      height: 47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.1),
          // Прозрачность для красоты
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: 18),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
