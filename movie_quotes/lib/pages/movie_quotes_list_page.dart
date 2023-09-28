import 'package:flutter/material.dart';
import 'package:movie_quotes/components/movie_quote_row.dart';
import 'package:movie_quotes/model/movie_quote.dart';
import 'package:movie_quotes/pages/movie_quote_detail_page.dart';

class MovieQuotesListPage extends StatefulWidget {
  const MovieQuotesListPage({super.key});

  @override
  State<MovieQuotesListPage> createState() => _MovieQuotesListPageState();
}

class _MovieQuotesListPageState extends State<MovieQuotesListPage> {
  final List<MovieQuote> quotes = []; // No Firebase, local data!
  final quoteTextController = TextEditingController();
  final movieTextController = TextEditingController();

  @override
  void dispose() {
    quoteTextController.dispose();
    movieTextController.dispose();
    super.dispose();
  }

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return MovieQuoteDetailPage(mq);
                      }),
                    );
                  },
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddQuoteDialog();
        },
        tooltip: "Add a Quote",
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddQuoteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Create a Quote"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: quoteTextController,
                  decoration: const InputDecoration(
                    // hintText: "Enter your quote:",
                    labelText: "Quote:",
                  ),
                ),
                TextFormField(
                  controller: movieTextController,
                  decoration: const InputDecoration(
                    // hintText: "Enter your quote:",
                    labelText: "Movie:",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    quotes.add(
                      MovieQuote(
                        quote: quoteTextController.text,
                        movie: movieTextController.text,
                      ),
                    );
                    quoteTextController.text = "";
                    movieTextController.text = "";
                  });
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ],
          );
        });
  }
}
