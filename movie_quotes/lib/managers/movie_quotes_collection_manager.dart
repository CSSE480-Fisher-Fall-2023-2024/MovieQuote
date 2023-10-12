import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_quotes/model/movie_quote.dart';

class MovieQuotesCollectionManager {
  List<MovieQuote> latestMovieQuotes = [];
  final CollectionReference _ref;

  static final instance = MovieQuotesCollectionManager._privateConstructor();
  MovieQuotesCollectionManager._privateConstructor()
      : _ref =
            FirebaseFirestore.instance.collection(kMovieQuotesCollectionPath);

  StreamSubscription startListening(Function observer) {
    return _ref
        .orderBy(kMovieQuoteLastTouched, descending: true)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      latestMovieQuotes =
          querySnapshot.docs.map((doc) => MovieQuote.from(doc)).toList();
      observer();
    }, onError: (error) {
      debugPrint("Error listening $error");
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  void add({required String quote, required String movie}) {
    _ref.add({
      kMovieQuoteQuote: quote,
      kMovieQuoteMovie: movie,
      kMovieQuoteLastTouched: Timestamp.now(),
    }).then((docId) {
      print("Finished adding a document that now has id $docId");
    }).catchError((error) {
      print("There was an error adding the document $error");
    });
  }
}
