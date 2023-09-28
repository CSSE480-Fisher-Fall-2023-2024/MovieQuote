import 'package:flutter/material.dart';
import 'package:movie_quotes/components/display_card.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Movie Quote"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        backgroundColor: Colors.black12,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              DisplayCard(
                title: "Quote:",
                iconData: Icons.format_quote_outlined,
                cardText: widget.movieQuote.quote,
              ),
              DisplayCard(
                title: "Movie:",
                iconData: Icons.movie_filter_outlined,
                cardText: widget.movieQuote.movie,
              ),
            ],
          ),
        ));
  }
}
