import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_quotes/model/movie_quote.dart';

class MovieQuoteDocumentManager {
  MovieQuote? latestMovieQuote;
  final CollectionReference _ref;

  static final instance = MovieQuoteDocumentManager._privateConstructor();
  MovieQuoteDocumentManager._privateConstructor()
      : _ref =
            FirebaseFirestore.instance.collection(kMovieQuotesCollectionPath);

  StreamSubscription startListening({
    required String documentId,
    required Function observer,
  }) {
    return _ref.doc(documentId).snapshots().listen(
        (DocumentSnapshot documentSnapshot) {
      latestMovieQuote = MovieQuote.from(documentSnapshot);
      observer();
    }, onError: (error) {
      print("Error getting the document $error");
    });

    // return _ref.snapshots().listen((QuerySnapshot querySnapshot) {
    //   latestMovieQuotes =
    //       querySnapshot.docs.map((doc) => MovieQuote.from(doc)).toList();
    //   observer();
    // }, onError: (error) {
    //   debugPrint("Error listening $error");
    // });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  void update({required String quote, required String movie}) {
    _ref.doc(latestMovieQuote!.documentId!).update({
      kMovieQuoteQuote: quote,
      kMovieQuoteMovie: movie,
      kMovieQuoteLastTouched: Timestamp.now(),
    }).then((_) {
      print("Finished updating the document");
    }).catchError((error) {
      print("There was an error adding the document $error");
    });
  }

  void delete() {
    _ref.doc(latestMovieQuote!.documentId!).delete();
  }

  void clearLatest() {
    latestMovieQuote = null;
  }

  bool get hasAuthorUid =>
      latestMovieQuote != null && latestMovieQuote!.authorUid.isNotEmpty;
  String get authorUid => latestMovieQuote?.authorUid ?? "";

  String get movie => latestMovieQuote?.movie ?? "";
  String get quote => latestMovieQuote?.quote ?? "";
}
