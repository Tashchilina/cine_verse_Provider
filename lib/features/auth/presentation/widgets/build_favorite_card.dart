import 'package:cine_verse/features/auth/data/models/movie_model.dart';
import 'package:cine_verse/features/auth/presentation/controllers/movie_provider.dart';
import 'package:flutter/material.dart';

Widget BuildFavoriteCard(
  BuildContext context,
  Movie movie,
  MovieProvider provider,
) {
  return GestureDetector(
    onTap: () {
      // Переход на детали при клике
    },
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: () => provider.toggleFavorite(movie),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Colors.red, size: 20),
            ),
          ),
        ),
      ],
    ),
  );
}
