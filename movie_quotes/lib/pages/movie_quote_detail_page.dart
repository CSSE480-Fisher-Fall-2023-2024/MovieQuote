import 'package:flutter/material.dart';
import 'package:movie_quotes/model/movie_quote.dart';

class MovieQuoteDetailPage extends StatefulWidget {
  final MovieQuote movieQuote;

  const MovieQuoteDetailPage(
    this.movieQuote, {
    super.key,
  });

  @override
  State<MovieQuoteDetailPage> createState() => _MovieQuoteDetailPageState();
}

class _MovieQuoteDetailPageState extends State<MovieQuoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.movieQuote.quote),
    );
  }
}
