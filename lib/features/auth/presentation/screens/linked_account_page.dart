import 'package:cine_verse/features/auth/presentation/controllers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LinkedAccountPage extends StatelessWidget {
  const LinkedAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthNotifier>();
    final user = auth.user;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29),
      appBar: AppBar(
        title: const Text(
          "Linked Accounts",
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "SOCIAL PROFILE LINK",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF252936),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, color: Colors.blueAccent),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Public Username / Link",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (user?.userLink != null && user!.userLink!.isNotEmpty)
                              ? user.userLink!
                              : "Not linked yet",
                          style: TextStyle(
                            color:
                                (user?.userLink != null &&
                                    user!.userLink!.isNotEmpty)
                                ? Colors.white70
                                : Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Your unique link is used to identify your profile to other CineVerse users.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
