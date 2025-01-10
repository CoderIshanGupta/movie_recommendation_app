import 'package:flutter/material.dart';
import 'api_service.dart';
import 'movie.dart';

class RecommendationPage extends StatelessWidget {
  final double userRating;

  RecommendationPage({required this.userRating});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recommended Movies')),
      body: FutureBuilder<List<Movie>>(
        future: ApiService().fetchPopularMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found.'));
          }

          final movies = snapshot.data!;
          final recommendedMovies = movies.where((movie) => movie.genres.contains('Action')).toList();

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
      ),
    );
  }
}