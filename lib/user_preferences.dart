import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> saveRating(int movieId, double rating) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('movie_$movieId', rating);
  }

  static Future<double?> getRating(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('movie_$movieId');
  }
}