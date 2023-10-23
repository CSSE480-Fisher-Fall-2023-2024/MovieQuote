import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:movie_quotes/components/login_button.dart';
import 'package:movie_quotes/pages/email_password_auth_page.dart';

class LoginFrontPage extends StatefulWidget {
  const LoginFrontPage({super.key});

  @override
  State<LoginFrontPage> createState() => _LoginFrontPageState();
}

class _LoginFrontPageState extends State<LoginFrontPage> {
  final kGoogleAuthClientId =
      "526561312700-vrkkg12vt662ki2e1smcp4bj9v9clije.apps.googleusercontent.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                "Movie Quotes",
                style: TextStyle(
                  fontSize: 56.0,
                  fontFamily: "Rowdies",
                ),
              ),
            ),
          ),
          LoginButton(
            text: "Log in",
            clickCallback: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const EmailPasswordAuthPage(isNewUser: false),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const EmailPasswordAuthPage(isNewUser: true),
                    ),
                  );
                },
                child: const Text("Sign up here"),
              )
            ],
          ),
          const SizedBox(
            height: 60.0,
          ),
          ElevatedButton(
            onPressed: () {
              print("TODO: Use Firebase UI Auth!");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SignInScreen(
                    providers: [
                      EmailAuthProvider(),
                      GoogleProvider(clientId: kGoogleAuthClientId),
                    ],
                    actions: [
                      // AuthStateChangeAction<SignedIn>((context, state) {
                      //   Navigator.of(context)
                      //       .popUntil((route) => route.isFirst);
                      // },)
                      AuthStateChangeAction(
                        (context, state) {
                          print(state);
                          if (state is SignedIn || state is UserCreated) {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            },
            child: const Text("Or sign in with Google"),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
