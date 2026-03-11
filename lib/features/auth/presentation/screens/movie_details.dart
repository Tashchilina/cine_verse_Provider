import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/movie_model.dart';
import '../controllers/movie_provider.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MovieProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        title: Text(movie.title, style: const TextStyle(color: Colors.white70)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white70),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              movie.posterPath,
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                movie.overview ?? 'The description is missing',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            IconButton(
              icon: Icon(
                provider.isFavorite(movie) ? Icons.favorite : Icons.favorite_border,
                color: provider.isFavorite(movie) ? Colors.red : Colors.white,
              ),
              onPressed: () => provider.toggleFavorite(movie),
            )
          ],
        ),
      ),
    );
  }
}
