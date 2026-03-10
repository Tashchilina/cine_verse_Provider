class Movie {
  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? '',
      posterPath: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}
