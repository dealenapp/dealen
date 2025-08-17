import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesService {
  static const _keyDe = 'favorite_words_de';
  static const _keyEn = 'favorite_words_en';

  // ---- Немецкий ----
  static Future<List<Map<String, dynamic>>> getFavoritesDe() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyDe);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<void> toggleFavoriteDe(Map<String, dynamic> word) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoritesDe();
    final exists = favorites.any((w) => w['DeWord'] == word['DeWord']);

    if (exists) {
      favorites.removeWhere((w) => w['DeWord'] == word['DeWord']);
    } else {
      favorites.add(word);
    }
    await prefs.setString(_keyDe, jsonEncode(favorites));
  }

  static Future<bool> isFavoriteDe(String deWord) async {
    final favorites = await getFavoritesDe();
    return favorites.any((w) => w['DeWord'] == deWord);
  }

  // ---- Английский ----
  static Future<List<Map<String, dynamic>>> getFavoritesEn() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyEn);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<void> toggleFavoriteEn(Map<String, dynamic> word) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoritesEn();
    final exists = favorites.any((w) => w['word'] == word['word']);

    if (exists) {
      favorites.removeWhere((w) => w['word'] == word['word']);
    } else {
      favorites.add(word);
    }
    await prefs.setString(_keyEn, jsonEncode(favorites));
  }

  static Future<bool> isFavoriteEn(String enWord) async {
    final favorites = await getFavoritesEn();
    return favorites.any((w) => w['word'] == enWord);
  }
}
