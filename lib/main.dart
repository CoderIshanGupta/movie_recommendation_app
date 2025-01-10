import 'package:flutter/material.dart';
import 'movie_list_page.dart';

void main() {
  runApp(MovieRecommendationApp());
}

class MovieRecommendationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Recommendation App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MovieListPage(),
    );
  }
}