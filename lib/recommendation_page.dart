import 'package:flutter/material.dart';
import 'api_service.dart';
import 'movie.dart';
import 'user_preferences.dart';

class RecommendationPage extends StatefulWidget {
  final double userRating;

  RecommendationPage({required this.userRating});

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = ApiService().fetchPopularMovies();
  }

  // Function to fetch user rating from SharedPreferences
  Future<double?> _getUserRating(int movieId) async {
    return await UserPreferences.getRating(movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recommended Movies')),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found.'));
          }

          final movies = snapshot.data!;

          // Filtering movies based on user rating and genre
          return FutureBuilder<List<Movie>>(
            future: _getFilteredMovies(movies),
            builder: (context, recommendationSnapshot) {
              if (recommendationSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (recommendationSnapshot.hasError) {
                return Center(child: Text('Error: ${recommendationSnapshot.error}'));
              }

              final recommendedMovies = recommendationSnapshot.data ?? [];

              return ListView.builder(
                itemCount: recommendedMovies.length,
                itemBuilder: (context, index) {
                  final movie = recommendedMovies[index];
                  return ListTile(
                    title: Text(movie.title),
                    subtitle: Text(movie.overview),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Movie>> _getFilteredMovies(List<Movie> movies) async {
    List<Movie> filteredMovies = [];

    for (var movie in movies) {
      final userRating = await _getUserRating(movie.id);

      // Add movie if it meets the rating and genre criteria
      if (userRating != null &&
          userRating >= widget.userRating &&
          movie.genres.contains('Action')) {
        filteredMovies.add(movie);
      }
    }

    return filteredMovies;
  }
}