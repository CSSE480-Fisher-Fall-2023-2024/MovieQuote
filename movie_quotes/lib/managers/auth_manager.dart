import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthManager {
  static final instance = AuthManager._privateConstructor();
  AuthManager._privateConstructor();

  StreamSubscription? _authSubcription;
  User? _user;

  final Map<UniqueKey, Function> _loginObservers = {};
  final Map<UniqueKey, Function> _logoutObservers = {};

  void beginListening() {
    if (_authSubcription != null) {
      return; // Already listening, avoid 2 subscriptions
    }
    _authSubcription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      final isLogin = user != null && _user == null;
      final isLogout = user == null && _user != null;
      _user = user;

      if (isLogin) {
        // Inform the login observers
        print("Log in occurred");
        for (Function observer in _loginObservers.values) {
          observer();
        }
      } else if (isLogout) {
        // Inform the logout observers.
        print("Log out occurred");
        for (Function observer in _logoutObservers.values) {
          observer();
        }
      } else {
        print("Double call, which is ignored, to the auth state");
      }
    });
  }

  void stopListening() {
    _authSubcription?.cancel();
    _authSubcription = null;
  }

  UniqueKey addLoginObserver(Function observer) {
    beginListening(); // Just in case
    // Make a map of UniqueKeys to login observers
    UniqueKey key = UniqueKey();
    _loginObservers[key] = observer;
    return key;
  }

  UniqueKey addLogoutObserver(Function observer) {
    beginListening(); // Just in case
    // Make a map of UniqueKeys to logout observers
    UniqueKey key = UniqueKey();
    _logoutObservers[key] = observer;
    return key;
  }

  void removeObserver(UniqueKey? keyToRemove) {
    _loginObservers.remove(keyToRemove); // Note 1 of this works
    _logoutObservers.remove(keyToRemove); // The other is a no-op
  }

  void createUserWithEmailPassword({
    required BuildContext context,
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
        _showAuthError(context, "The password provided is too weak.");
      } else if (e.code == "email-already-in-use") {
        _showAuthError(context, "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  void loginExistingUserWithEmailPassword({
    required BuildContext context,
    required String emailAddress,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      print("Finished sign in");
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "user-not-found") {
        _showAuthError(context, "No user found for that email.");
      } else if (e.code == "wrong-password") {
        _showAuthError(context, "Wrong password provided for that user.");
      } else if (e.code == "invalid-login-credentials") {
        _showAuthError(context, "Invalid login credentials");
      } else {
        _showAuthError(context, e.toString());
      }
    } catch (e) {
      _showAuthError(context, e.toString());
    }
  }

  void signOut() {
    print("Signing out");
    FirebaseAuth.instance.signOut();
  }

  void _showAuthError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Develop the UI for signed in
  // bool get isSignedIn => false; // Develop the UI for not signed in

  bool get isSignedIn => _user != null;
  String get uid => _user?.uid ?? "";
  String get email => _user?.email ?? "";

  bool get hasDisplayName =>
      _user != null &&
      _user!.displayName != null &&
      _user!.displayName!.isNotEmpty;

  String get displayName => _user?.displayName ?? "";

  bool get hasImageUrl =>
      _user != null && _user!.photoURL != null && _user!.photoURL!.isNotEmpty;

  String get imageUrl => _user?.photoURL ?? "";
}
