import 'package:flutter/material.dart';

class MovieQuoteDialog extends StatelessWidget {
  final TextEditingController quoteTextController;
  final TextEditingController movieTextController;
  final void Function() positiveActionCallback;
  final bool isEditDialog;

  const MovieQuoteDialog({
    super.key,
    required this.quoteTextController,
    required this.movieTextController,
    required this.positiveActionCallback,
    this.isEditDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditDialog ? "Edit this Quote" : "Create a Quote"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: quoteTextController,
            decoration: const InputDecoration(
              // hintText: "Enter your quote:",
              labelText: "Quote:",
            ),
          ),
          TextFormField(
            controller: movieTextController,
            decoration: const InputDecoration(
              // hintText: "Enter your quote:",
              labelText: "Movie:",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            positiveActionCallback();
            Navigator.pop(context);
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
