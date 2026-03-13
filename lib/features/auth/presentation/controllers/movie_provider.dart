import 'dart:async';

import 'package:cine_verse/shared/services/favorites_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../data/models/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final String _apiKey = '789137b748377c5eede43ec1d00445cb';
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final FavoritesStorage _storage = FavoritesStorage();

  List<Movie> _popularMovies = [];
  List<Movie> _newMovies = [];
  List<Movie> _searchedMovies = [];
  List<Movie> _favoriteMovies = [];
  List<Movie> allMovies = [];
  bool _isLoading = false;

  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get newMovies => _newMovies;
  List<Movie> get searchedMovies => _searchedMovies;
  List<Movie> get favoriteMovies => _favoriteMovies;
  bool get isLoading => _isLoading;

  Timer? _debounce;

  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String popularUrl = '$_baseUrl/movie/popular?api_key=$_apiKey&language=en-US';
      final String newMoviesUrl = '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=en-US';

      final responses = await Future.wait([
        _dio.get(popularUrl),
        _dio.get(newMoviesUrl),
      ]);

      if (responses[0].statusCode == 200) {
        final List<dynamic> results = responses[0].data['results'];
        _popularMovies = results.map((json) => Movie.fromJson(json)).toList();
      }

      // 4. Обрабатываем новые фильмы (Now Playing)
      if (responses[1].statusCode == 200) {
        final List<dynamic> results = responses[1].data['results'];
        _newMovies = results.map((json) => Movie.fromJson(json)).toList();
      }

      print("Загружено: ${_popularMovies.length} популярных и ${_newMovies.length} новых фильмов");

    } catch (e) {
      print("Ошибка при загрузке: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }
    // Если запрос пустой, очищаем список и выходим
    if (query.isEmpty) {
      _searchedMovies = [];
      notifyListeners();
      return;
    }

    // Если таймер уже запущен — отменяем его
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _isLoading = true;
      notifyListeners();

      try {
        final String url = '$_baseUrl/search/movie?api_key=$_apiKey&query=$query&language=en-US';
        final response = await _dio.get(url);

        if (response.statusCode == 200) {
          final List<dynamic> results = response.data['results'];
          _searchedMovies = results.map((json) => Movie.fromJson(json)).toList();
        }
      } catch (e) {
        print("Ошибка поиска: $e");
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

// очищать таймер при уничтожении провайдера
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void clearSearch() {
    _searchedMovies = [];
    _debounce?.cancel();
    _isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(Movie movie) {
    final isExist = _favoriteMovies.any((m) => m.id == movie.id);
    if (isExist) {
      _favoriteMovies.removeWhere((m) => m.id == movie.id);
    } else {
      _favoriteMovies.add(movie);
    }
    _storage.saveFavorites(_favoriteMovies.map((m) => m.id).toList());
    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return _favoriteMovies.any((m) => m.id == movie.id);
  }

  Future<void> init() async {
    final savedIds = await _storage.loadFavorites();
    _favoriteMovies = allMovies.where((m) => savedIds.contains(m.id)).toList();
    notifyListeners();
  }
}