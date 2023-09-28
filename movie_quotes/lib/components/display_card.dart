import 'package:flutter/material.dart';

class DisplayCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String cardText;

  const DisplayCard({
    super.key,
    required this.title,
    required this.iconData,
    required this.cardText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                // TODO: Figure out custom fonts!
                fontFamily: "Caveat",
                fontSize: 30.0,
                fontWeight: FontWeight.w600),
          ),
          Card(
            // color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(iconData),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Expanded(
                    child: Text(cardText),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
