import 'package:flutter/material.dart';
import 'package:movie_quotes/components/movie_quote_row.dart';
import 'package:movie_quotes/model/movie_quote.dart';

class MovieQuotesListPage extends StatefulWidget {
  const MovieQuotesListPage({super.key});

  @override
  State<MovieQuotesListPage> createState() => _MovieQuotesListPageState();
}

class _MovieQuotesListPageState extends State<MovieQuotesListPage> {
  final List<MovieQuote> quotes = []; // No Firebase, local data!

  @override
  void initState() {
    quotes.add(MovieQuote(
      quote: "I'll be back",
      movie: "The Terminator",
    ));
    quotes.add(MovieQuote(
      quote: "Everything is Awesome",
      movie: "The Lego Movie",
    ));
    quotes.add(MovieQuote(
      quote:
          "Hello. My name is Inigo Montoya. You killed my father. Prepare to die.",
      movie: "The Princess Bride",
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Quotes"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: quotes
            .map((mq) => MovieQuoteRow(
                  movieQuote: mq,
                  onTapCallback: () {
                    print("Show the detail page for $mq");
                  },
                ))
            .toList(),
      ),
    );
  }
}
