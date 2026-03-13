import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavoritesStorage {
  final _storage = const FlutterSecureStorage();
  static const _key = 'favorite_movies_ids';

  // Сохранить список ID
  Future<void> saveFavorites(List<int> ids) async {
    String jsonString = jsonEncode(ids);
    await _storage.write(key: _key, value: jsonString);
  }

  // Загрузить список ID
  Future<List<int>> loadFavorites() async {
    String? jsonString = await _storage.read(key: _key);
    if (jsonString == null) return [];
    List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.cast<int>();
  }
}
