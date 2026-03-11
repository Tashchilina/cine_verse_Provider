import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/build_home_content.dart';
import 'package:provider/provider.dart';
import '../widgets/build_home_content.dart';
import 'package:cine_verse/features/auth/presentation/controllers/movie_provider.dart';
import 'package:cine_verse/features/auth/presentation/widgets/build_movie_grid.dart';

import 'movie_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<MovieProvider>().searchMovies(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),

      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),

        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onSearchChanged,

          style: const TextStyle(color: Colors.white),

          decoration: const InputDecoration(
            hintText: "Search movie...",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: _buildBody(movieProvider),
      ),
    );
  }

  Widget _buildBody(MovieProvider provider) {
    if (_controller.text.trim().isEmpty) {
      return const Center(
        child: Text(
          "Start typing to search movies",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.searchedMovies.isEmpty) {
      return const Center(
        child: Text("Nothing found", style: TextStyle(color: Colors.grey)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 фильма в ряд
        childAspectRatio: 0.6, // Соотношение сторон для карточек
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: provider.searchedMovies.length,
      itemBuilder: (context, index) {
        final movie = provider.searchedMovies[index];
        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie))
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(movie.posterPath, fit: BoxFit.cover),
                ),
              ),
              Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        );
      },
    );
  }
}
