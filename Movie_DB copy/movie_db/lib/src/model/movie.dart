class Movie {
  final String title;
  final String detail;

  Movie({required this.title, required this.detail});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(title: json['title'], detail: json['overview']);
  }
}
