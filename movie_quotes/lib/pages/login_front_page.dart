import 'package:flutter/material.dart';
import 'package:movie_quotes/components/login_button.dart';

class LoginFrontPage extends StatefulWidget {
  const LoginFrontPage({super.key});

  @override
  State<LoginFrontPage> createState() => _LoginFrontPageState();
}

class _LoginFrontPageState extends State<LoginFrontPage> {
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
                  // TODO: Set the font family to Rowdies
                ),
              ),
            ),
          ),
          LoginButton(
            text: "Log in",
            clickCallback: () {
              print("TODO: Go to the next page");
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  print("TODO: Go on to the page to Create an Account");
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
            },
            child: Text("Or sign in with Google"),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
