import 'package:cine_verse/features/auth/presentation/controllers/movie_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/build_favorite_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    final favorites = provider.favoriteMovies;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1D29),
      appBar: AppBar(
        title: const Text(
          'My Favorites',
          style: TextStyle(color: Colors.white70),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'You have not added any favorites yet',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final movie = favorites[index];
                return BuildFavoriteCard(context, movie, provider);
              },
            ),
    );
  }
}
