import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';

Widget BuildMovieGrid(List<Movie> movies) {
  if (movies.isEmpty) return const Center(child: Text("Нет данных", style: TextStyle(color: Colors.white)));

  return SizedBox(
    height: 250,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      separatorBuilder: (_, __) => const SizedBox(width: 15),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            // Переход на Movie Details (согласно навигации 4.1)
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.posterPath,
                  height: 200,
                  width: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey, height: 200, width: 140),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 140,
                child: Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}