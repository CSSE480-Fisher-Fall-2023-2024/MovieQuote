import 'package:flutter/material.dart';
import 'package:movie_quotes/components/display_card.dart';
import 'package:movie_quotes/components/movie_quote_dialog.dart';
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
  final quoteTextController = TextEditingController();
  final movieTextController = TextEditingController();

  @override
  void dispose() {
    quoteTextController.dispose();
    movieTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Movie Quote"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              onPressed: () {
                showEditDialog();
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Quote Deleted"),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      // Some code to undo the change.
                      print("TODO: Later restore with quote!");
                    },
                  ),
                ));
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
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

  void showEditDialog() {
    showDialog(
        context: context,
        builder: (context) {
          quoteTextController.text = widget.movieQuote.quote;
          movieTextController.text = widget.movieQuote.movie;

          return MovieQuoteDialog(
            quoteTextController: quoteTextController,
            movieTextController: movieTextController,
            isEditDialog: true,
            positiveActionCallback: () {
              setState(() {
                widget.movieQuote.quote = quoteTextController.text;
                widget.movieQuote.movie = movieTextController.text;
              });
            },
          );
        });
  }
}
