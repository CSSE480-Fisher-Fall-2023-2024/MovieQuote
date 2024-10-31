import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_quotes/managers/auth_manager.dart';
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

  void maybeAddNewUser() async {
    // Get the UserData document for the current user and see if it exist!
    // If it DOES exist do nothing
    // If if DOES NOT exist then make it. set of a Uid as the document id.
    DocumentSnapshot snapshot = await _ref.doc(AuthManager.instance.uid).get();
    if (snapshot.exists) {
      print("This UserData exist do nothing");
    } else {
      print("This is a new user. TODO: Make a doc");

      if (AuthManager.instance.uid.isNotEmpty) {
        createNewUser();
      }
    }
  }

  void createNewUser() {
    Map<String, Object> initialUserData = {
      kUserDataCreated: Timestamp.now(),
    };
    if (AuthManager.instance.hasDisplayName) {
      initialUserData[kUserDataDisplayName] = AuthManager.instance.displayName;
    }
    if (AuthManager.instance.hasImageUrl) {
      initialUserData[kUserDataImageUrl] = AuthManager.instance.imageUrl;
    }
    _ref.doc(AuthManager.instance.uid).set(initialUserData).catchError((error) {
      print("Error setting the document $error");
    });
  }

  bool get hasDisplayName =>
      latestUserData != null && latestUserData!.displayName.isNotEmpty;
  String get displayName => latestUserData?.displayName ?? "";

  bool get hasImageUrl =>
      latestUserData != null && latestUserData!.imageUrl.isNotEmpty;
  String get imageUrl => latestUserData?.imageUrl ?? "";
}
