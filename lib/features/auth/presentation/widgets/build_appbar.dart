import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_notifier.dart';

PreferredSizeWidget BuildAppBar(BuildContext context) {
  final auth = context.watch<AuthNotifier>();
  final user = auth.user;

  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundImage: auth.localPhotoPath != null
              ? FileImage(File(auth.localPhotoPath!))
              : (user?.photoURL != null ? NetworkImage(user!.photoURL!) : null) as ImageProvider?,
          child: (auth.localPhotoPath == null && user?.photoURL == null)
              ? const Icon(Icons.person, size: 20)
              : null,
        ),
        const SizedBox(width: 8),
        const Text('CineVerse', style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
      ],
    ),
  );
}