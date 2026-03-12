import 'package:flutter/material.dart';

Widget BuildSettingsItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  Color titleColor = Colors.white70,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: titleColor),
    title: Text(title, style: TextStyle(color: titleColor, fontSize: 16)),
    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
    onTap: onTap,
  );
}
