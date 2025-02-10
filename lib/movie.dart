class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final List<String> genres;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      genres: List<String>.from(json['genre_ids'].map((x) => x.toString())), // Assuming genre_ids as integers
    );
  }
}