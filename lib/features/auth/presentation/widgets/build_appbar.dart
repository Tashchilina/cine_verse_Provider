import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_notifier.dart';

PreferredSizeWidget BuildAppBar(BuildContext context) {
  final user = context.watch<AuthNotifier>().user;
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 15,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : null,
          child: user?.photoURL == null
              ? const Icon(Icons.movie, size: 20)
              : null,
        ),
        const SizedBox(width: 8),
        const Text('CineVerse', style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
      ],
    ),
  );
}