import 'package:flutter/material.dart';
import 'api_service.dart';
import 'movie.dart';
import 'user_preferences.dart';
import 'recommendation_page.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = ApiService().fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular Movies')),
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
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                leading: Image.network('https://image.tmdb.org/t/p/w200${movie.posterPath}'),
                title: Text(movie.title),
                subtitle: Text(movie.overview),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      double userRating = 0;
                      return AlertDialog(
                        title: Text(movie.title),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(movie.overview),
                            TextField(
                              decoration: InputDecoration(labelText: 'Rate this movie (1-10)'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                userRating = double.tryParse(value) ?? 0;
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              UserPreferences.saveRating(movie.id, userRating);
                              Navigator.of(context).pop();
                            },
                            child: Text('Submit Rating'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RecommendationPage(userRating: userRating),
                                ),
                              );
                            },
                            child: Text('Get Recommendations'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}