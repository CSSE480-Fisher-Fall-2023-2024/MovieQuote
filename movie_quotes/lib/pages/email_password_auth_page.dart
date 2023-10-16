import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:movie_quotes/components/login_button.dart';

class EmailPasswordAuthPage extends StatefulWidget {
  final bool isNewUser;
  const EmailPasswordAuthPage({
    super.key,
    required this.isNewUser,
  });

  @override
  State<EmailPasswordAuthPage> createState() => _EmailPasswordAuthPageState();
}

class _EmailPasswordAuthPageState extends State<EmailPasswordAuthPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailTextController.text = "a@b.co";
    passwordTextController.text = "123456";
    super.initState();
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isNewUser ? "Create a New User" : "Log in an Existing User"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailTextController,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !EmailValidator.validate(value)) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: "Enter an email address"),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: passwordTextController,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Passwords in Firebase must be at least 6 characters";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Passwords must be 6 characters or more"),
              ),
              const SizedBox(
                height: 50.0,
              ),
              LoginButton(
                text: widget.isNewUser ? "Create an account" : "Log in",
                clickCallback: () {
                  if (_formKey.currentState!.validate()) {
                    // The form is valid.  Go!
                    if (widget.isNewUser) {
                      print("TODO: Create a new user with Firebase");
                    } else {
                      print("TODO: Log in this existing user with Firebase");
                    }
                  } else {
                    // The form is invalid!  Maybe say something to the user.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid form entry")),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
