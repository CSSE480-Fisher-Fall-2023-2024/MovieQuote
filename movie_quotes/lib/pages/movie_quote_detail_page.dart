import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_quotes/components/author_box.dart';
import 'package:movie_quotes/components/display_card.dart';
import 'package:movie_quotes/components/movie_quote_dialog.dart';
import 'package:movie_quotes/managers/auth_manager.dart';
import 'package:movie_quotes/managers/movie_quote_document_manager.dart';
import 'package:movie_quotes/managers/movie_quotes_collection_manager.dart';
import 'package:movie_quotes/managers/user_data_document_manager.dart';
import 'package:movie_quotes/model/movie_quote.dart';

class MovieQuoteDetailPage extends StatefulWidget {
  // final MovieQuote movieQuote;
  final String documentId;

  const MovieQuoteDetailPage(
    this.documentId, {
    super.key,
  });

  @override
  State<MovieQuoteDetailPage> createState() => _MovieQuoteDetailPageState();
}

class _MovieQuoteDetailPageState extends State<MovieQuoteDetailPage> {
  final quoteTextController = TextEditingController();
  final movieTextController = TextEditingController();
  StreamSubscription? _movieQuoteSubscription;
  StreamSubscription? _userSubscription;

  @override
  void initState() {
    MovieQuoteDocumentManager.instance.clearLatest();
    UserDataDocumentManager.instance.clearLatest();

    MovieQuoteDocumentManager.instance.startListening(
      documentId: widget.documentId,
      observer: () {
        print("Got the quote!");

        if (MovieQuoteDocumentManager.instance.hasAuthorUid) {
          UserDataDocumentManager.instance.stopListening(_userSubscription);
          _userSubscription = UserDataDocumentManager.instance.startListening(
              documentId: MovieQuoteDocumentManager
                  .instance.latestMovieQuote!.authorUid,
              observer: () {
                setState(() {});
              });
        }
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    quoteTextController.dispose();
    movieTextController.dispose();
    MovieQuoteDocumentManager.instance.stopListening(_movieQuoteSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (MovieQuoteDocumentManager.instance.latestMovieQuote != null &&
        AuthManager.instance.isSignedIn &&
        AuthManager.instance.uid ==
            MovieQuoteDocumentManager.instance.latestMovieQuote!.authorUid) {
      actions = [
        IconButton(
          onPressed: () {
            showEditDialog();
          },
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            String tempQuote =
                MovieQuoteDocumentManager.instance.latestMovieQuote!.quote;
            String tempMovie =
                MovieQuoteDocumentManager.instance.latestMovieQuote!.movie;
            MovieQuoteDocumentManager.instance.delete();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Quote Deleted"),
              action: SnackBarAction(
                label: "Undo",
                onPressed: () {
                  MovieQuotesCollectionManager.instance.add(
                    quote: tempQuote,
                    movie: tempMovie,
                  );
                },
              ),
            ));
            Navigator.pop(context);
          },
          icon: const Icon(Icons.delete),
        ),
      ];
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Movie Quote"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: actions,
        ),
        backgroundColor: Colors.black12,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              DisplayCard(
                title: "Quote:",
                iconData: Icons.format_quote_outlined,
                cardText: MovieQuoteDocumentManager.instance.quote,
              ),
              DisplayCard(
                title: "Movie:",
                iconData: Icons.movie_filter_outlined,
                cardText: MovieQuoteDocumentManager.instance.movie,
              ),
              const Spacer(),
              AuthorBox(
                name: UserDataDocumentManager.instance.displayName,
                imageUrl: UserDataDocumentManager.instance.imageUrl,
              ),
            ],
          ),
        ));
  }

  void showEditDialog() {
    showDialog(
        context: context,
        builder: (context) {
          quoteTextController.text =
              MovieQuoteDocumentManager.instance.latestMovieQuote?.quote ?? "";
          movieTextController.text =
              MovieQuoteDocumentManager.instance.latestMovieQuote?.movie ?? "";

          return MovieQuoteDialog(
            quoteTextController: quoteTextController,
            movieTextController: movieTextController,
            isEditDialog: true,
            positiveActionCallback: () {
              MovieQuoteDocumentManager.instance.update(
                quote: quoteTextController.text,
                movie: movieTextController.text,
              );

              // setState(() {
              // widget.movieQuote.quote = quoteTextController.text;
              // widget.movieQuote.movie = movieTextController.text;
              // });
            },
          );
        });
  }
}
