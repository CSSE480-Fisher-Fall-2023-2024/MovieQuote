import 'package:firebase_auth/firebase_auth.dart';

class AuthManager {
  static final instance = AuthManager._privateConstructor();
  AuthManager._privateConstructor();

  void createUserWithEmailPassword({
    required String emailAddress,
    required String password,
  }) async {
    // From: https://firebase.google.com/docs/auth/flutter/password-auth
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        print("The password provided is too weak.");
      } else if (e.code == "email-already-in-use") {
        print("The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  bool get isSignedIn => false;

  void signOut() {
    print("TODO: Sign out");
  }

  // Develop the UI for signed in
  // bool get isSignedIn => false; // Develop the UI for not signed in
}
