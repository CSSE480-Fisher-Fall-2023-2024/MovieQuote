import 'package:flutter/material.dart';
import 'package:movie_quotes/components/login_button.dart';
import 'package:movie_quotes/pages/email_password_auth_page.dart';

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
