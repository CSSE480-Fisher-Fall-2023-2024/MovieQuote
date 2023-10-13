import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isNewUser ? "Create a New User" : "Log in an Existing User"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
