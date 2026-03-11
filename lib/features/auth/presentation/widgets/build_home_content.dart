import 'package:cine_verse/features/auth/presentation/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/movie_provider.dart';
import 'build_movie_grid.dart';
import 'build_section_title.dart';

Widget BuildHomeContent(BuildContext context) {
  final movieProvider = context.watch<MovieProvider>();

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            readOnly: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
            decoration: InputDecoration(
              hintText: "The title or the name...",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ВСЕГДА показываем популярные
          BuildSectionTitle('Popular movies'),
          const SizedBox(height: 10),
          BuildMovieGrid(movieProvider.popularMovies),

          const SizedBox(height: 20),

          // ВСЕГДА показываем новые
          BuildSectionTitle('New movies'),
          const SizedBox(height: 10),
          BuildMovieGrid(movieProvider.newMovies),
        ],
      ),
    ),
  );
}