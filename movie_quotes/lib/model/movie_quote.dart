class MovieQuote {
  String quote;
  String movie;

  MovieQuote({
    required this.quote,
    required this.movie,
  });

  @override
  String toString() {
    return "Quote: $quote  Movie: $movie";
  }
}
