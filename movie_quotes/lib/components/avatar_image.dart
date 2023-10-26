import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const AvatarImage({
    this.radius = 80.0,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black45,
          width: 4.0,
        ),
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: radius,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: imageUrl.isEmpty
            ? Icon(
                Icons.person,
                size: 1.5 * radius,
              )
            : null,
      ),
    );
  }
}
