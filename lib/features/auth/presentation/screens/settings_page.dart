import 'package:cine_verse/features/auth/presentation/controllers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/build_settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.read<AuthNotifier>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29),
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Settings',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            BuildSettingsItem(
              icon: Icons.logout,
              title: "Sign out",
              titleColor: Colors.redAccent,
              onTap: () async {
                await authNotifier.logout();
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
