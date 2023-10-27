import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_quotes/model/user_data.dart';

class UserDataDocumentManager {
  UserData? latestUserData;
  final CollectionReference _ref;

  static final instance = UserDataDocumentManager._privateConstructor();
  UserDataDocumentManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kUserDatasCollectionPath);

  StreamSubscription startListening({
    required String documentId,
    required Function observer,
  }) {
    return _ref.doc(documentId).snapshots().listen(
        (DocumentSnapshot documentSnapshot) {
      latestUserData = UserData.from(documentSnapshot);
      observer();
    }, onError: (error) {
      print("Error getting the document $error");
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  void update({required String displayName, String? imageUrl}) {
    final updateMap = {
      kUserDataDisplayName: displayName,
    };
    if (imageUrl != null) {
      updateMap[kUserDataImageUrl] = imageUrl;
    }
    _ref.doc(latestUserData!.documentId!).update(updateMap).then((_) {
      print("Finished updating the document");
    }).catchError((error) {
      print("There was an error adding the document $error");
    });
  }

  void clearLatest() {
    latestUserData = null;
  }

  bool get hasDisplayName =>
      latestUserData != null && latestUserData!.displayName.isNotEmpty;
  String get displayName => latestUserData?.displayName ?? "";

  bool get hasImageUrl =>
      latestUserData != null && latestUserData!.imageUrl.isNotEmpty;
  String get imageUrl => latestUserData?.imageUrl ?? "";
}
