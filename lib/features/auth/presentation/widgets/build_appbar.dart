import 'package:flutter/material.dart';

PreferredSizeWidget BuildAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Row(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.white,
          radius: 15,
          child: Icon(Icons.movie, size: 20),
        ),
        const SizedBox(width: 8),
        const Text('CineVerse', style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
      ],
    ),
  );
}