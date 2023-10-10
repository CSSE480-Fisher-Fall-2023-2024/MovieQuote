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
    return _ref.snapshots().listen((QuerySnapshot querySnapshot) {
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
}
