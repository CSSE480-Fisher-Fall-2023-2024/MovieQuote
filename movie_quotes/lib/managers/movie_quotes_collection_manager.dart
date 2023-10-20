import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_quotes/managers/auth_manager.dart';
import 'package:movie_quotes/model/movie_quote.dart';

class MovieQuotesCollectionManager {
  // Not actually need after the Firebase UI Firestore refactor
  List<MovieQuote> latestMovieQuotes = [];

  final CollectionReference _ref;

  static final instance = MovieQuotesCollectionManager._privateConstructor();
  MovieQuotesCollectionManager._privateConstructor()
      : _ref =
            FirebaseFirestore.instance.collection(kMovieQuotesCollectionPath);

  // Not actually need after the Firebase UI Firestore refactor
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

  // Not actually need after the Firebase UI Firestore refactor
  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  Query<MovieQuote> get allMovieQuotesQuery =>
      _ref.orderBy(kMovieQuoteLastTouched, descending: true).withConverter(
            fromFirestore: (snapshot, _) => MovieQuote.from(snapshot),
            toFirestore: (mq, _) => mq.toMap(),
          );

  Query<MovieQuote> get onlyMyMovieQuotesQuery => allMovieQuotesQuery
      .where(kMovieQuoteAuthorUid, isEqualTo: AuthManager.instance.uid);

  void add({required String quote, required String movie}) {
    _ref.add({
      kMovieQuoteAuthorUid: AuthManager.instance.uid,
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
