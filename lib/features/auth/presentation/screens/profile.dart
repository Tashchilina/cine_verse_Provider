import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_notifier.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthNotifier>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29),
      body: Column(
        children: [
          const SizedBox(height: 50),
          // Фото, Имя и Ссылка
          CircleAvatar(
            radius: 50,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : null,
            child: user?.photoURL == null ? const Icon(Icons.person, size: 50) : null,
          ),
          const SizedBox(height: 15),
          Text(user?.name ?? "Guest", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(user?.userLink ?? "@username", style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 30),
          // Меню навигации [cite: 426, 427, 429]
          _buildMenuItem(Icons.edit, "Edit Profile", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage()))),
          _buildMenuItem(Icons.settings, "Settings", () {/* Навигация в Settings */}),
          _buildMenuItem(Icons.link, "Linked Accounts", () {/* Навигация в Linked Accounts */}),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }
}
