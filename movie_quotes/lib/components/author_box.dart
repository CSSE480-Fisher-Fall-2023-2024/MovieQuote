import 'package:flutter/material.dart';
import 'package:movie_quotes/components/avatar_image.dart';

class AuthorBox extends StatelessWidget {
  final String name;
  final String imageUrl;
  const AuthorBox({
    required this.name,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Author:"),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AvatarImage(
                  imageUrl: imageUrl,
                  radius: 50.0,
                ),
                Text(
                  name.isEmpty ? "Unknown" : name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
