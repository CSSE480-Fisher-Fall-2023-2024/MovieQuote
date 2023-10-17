class AuthManager {
  static final instance = AuthManager._privateConstructor();
  AuthManager._privateConstructor();

  bool get isSignedIn => true;

  void signOut() {
    print("TODO: Sign out");
  }

  // Develop the UI for signed in
  // bool get isSignedIn => false; // Develop the UI for not signed in
}
