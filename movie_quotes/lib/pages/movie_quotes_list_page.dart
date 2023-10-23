import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_quotes/components/list_page_drawer.dart';
import 'package:movie_quotes/components/movie_quote_dialog.dart';
import 'package:movie_quotes/components/movie_quote_row.dart';
import 'package:movie_quotes/managers/auth_manager.dart';
import 'package:movie_quotes/managers/movie_quotes_collection_manager.dart';
import 'package:movie_quotes/model/movie_quote.dart';
import 'package:movie_quotes/pages/login_front_page.dart';
import 'package:movie_quotes/pages/movie_quote_detail_page.dart';

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:movie_quotes/pages/profile_page.dart';

class MovieQuotesListPage extends StatefulWidget {
  const MovieQuotesListPage({super.key});

  @override
  State<MovieQuotesListPage> createState() => _MovieQuotesListPageState();
}

class _MovieQuotesListPageState extends State<MovieQuotesListPage> {
  // final List<MovieQuote> quotes = []; // No Firebase, local data!
  final quoteTextController = TextEditingController();
  final movieTextController = TextEditingController();

  // Not actually need after the Firebase UI Firestore refactor
  StreamSubscription? movieQuotesSubscription;

  UniqueKey? _loginUniqueKey;
  UniqueKey? _logoutUniqueKey;

  bool _isShowingAllQuotes = true;

  @override
  void dispose() {
    quoteTextController.dispose();
    movieTextController.dispose();

    // Not actually need after the Firebase UI Firestore refactor
    MovieQuotesCollectionManager.instance
        .stopListening(movieQuotesSubscription);

    AuthManager.instance.removeObserver(_loginUniqueKey);
    AuthManager.instance.removeObserver(_logoutUniqueKey);

    super.dispose();
  }

  @override
  void initState() {
    // Not actually need after the Firebase UI Firestore refactor
    movieQuotesSubscription =
        MovieQuotesCollectionManager.instance.startListening(() {
      print("Got some quotes!");
      setState(() {});
    });

    _loginUniqueKey = AuthManager.instance.addLoginObserver(() {
      setState(() {});
    });

    _logoutUniqueKey = AuthManager.instance.addLogoutObserver(() {
      setState(() {
        _isShowingAllQuotes = true;
      });
    });

    // Spike solution to see my cloud quotes here!
    // FirebaseFirestore.instance
    //     .collection("MovieQuotes")
    //     .snapshots()
    //     .listen((QuerySnapshot querySnapshot) {
    //   print(querySnapshot.docs);
    //   print(querySnapshot.docs.length);
    //   for (final doc in querySnapshot.docs) {
    //     print(doc.data());
    //   }
    // });

    // quotes.add(MovieQuote(
    //   quote: "I'll be back",
    //   movie: "The Terminator",
    // ));
    // quotes.add(MovieQuote(
    //   quote: "Everything is Awesome",
    //   movie: "The Lego Movie",
    // ));
    // quotes.add(MovieQuote(
    //   quote:
    //       "Hello. My name is Inigo Montoya. You killed my father. Prepare to die.",
    //   movie: "The Princess Bride",
    // ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Quotes"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: AuthManager.instance.isSignedIn
            ? null
            : [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginFrontPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.login),
                )
              ],
      ),
      body: FirestoreListView<MovieQuote>(
        query: _isShowingAllQuotes
            ? MovieQuotesCollectionManager.instance.allMovieQuotesQuery
            : MovieQuotesCollectionManager.instance.onlyMyMovieQuotesQuery,
        itemBuilder: (context, snapshot) {
          // Data is now typed!  The data is already a MovieQuote
          MovieQuote mq = snapshot.data();
          return MovieQuoteRow(
            movieQuote: mq,
            onTapCallback: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return MovieQuoteDetailPage(mq.documentId!);
                }),
              );
            },
          );
        },
      ),
      drawer: AuthManager.instance.isSignedIn
          ? ListPageDrawer(
              goToProfilePageCallback: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
              showOnlyMineCallback: () {
                print("Pressed on only my quotes");
                setState(() {
                  _isShowingAllQuotes = false;
                });
              },
              showAllCallback: () {
                print("Pressed on show all quotes");
                setState(() {
                  _isShowingAllQuotes = true;
                });
              },
            )
          : null,
      // body: ListView(
      //   children: MovieQuotesCollectionManager.instance.latestMovieQuotes
      //       .map((mq) => MovieQuoteRow(
      //             movieQuote: mq,
      //             onTapCallback: () async {
      //               await Navigator.push(
      //                 context,
      //                 MaterialPageRoute(builder: (context) {
      //                   return MovieQuoteDetailPage(mq.documentId!);
      //                 }),
      //               );
      //               setState(() {});
      //             },
      //           ))
      //       .toList(),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (AuthManager.instance.isSignedIn) {
            showAddQuoteDialog();
          } else {
            showPleaseSignInDialog();
          }
        },
        tooltip: "Add a Quote",
        child: const Icon(Icons.add),
      ),
    );
  }

  void showPleaseSignInDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login required"),
          content: const Text(
              "You must be signed in to post.  Would you like to sign in now?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginFrontPage(),
                  ),
                );
              },
              child: const Text("Go to Login Page"),
            ),
          ],
        );
      },
    );
  }

  void showAddQuoteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          quoteTextController.text = "";
          movieTextController.text = "";
          return MovieQuoteDialog(
            quoteTextController: quoteTextController,
            movieTextController: movieTextController,
            positiveActionCallback: () {
              MovieQuotesCollectionManager.instance.add(
                quote: quoteTextController.text,
                movie: movieTextController.text,
              );

              // setState(() {
              //   quotes.add(
              //     MovieQuote(
              //       quote: quoteTextController.text,
              //       movie: movieTextController.text,
              //     ),
              //   );
              // });

              // Spike to make sure we are connected.
              // final ref = FirebaseFirestore.instance.collection("MovieQuotes");
              // ref.add({
              //   "quote": quoteTextController.text,
              //   "movie": movieTextController.text,
              //   "lastTouched": Timestamp.now(),
              // });
            },
          );
        });
  }
}
