import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie.dart';

class ApiService {
  final String apiKey = 'YOUR_TMDB_API_KEY';  // Replace with your TMDB API key
  final String baseUrl = 'https://api.themoviedb.org/3/';

  Future<List<Movie>> fetchPopularMovies() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}movie/popular?api_key=$apiKey'));

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body)['results'];
        return jsonResponse.map((data) => Movie.fromJson(data)).toList();
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load movies');
    }
  }
}