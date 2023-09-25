import 'package:flutter/material.dart';
import 'package:movie_quotes/model/movie_quote.dart';

class MovieQuoteRow extends StatelessWidget {
  final MovieQuote movieQuote;
  final void Function() onTapCallback;

  const MovieQuoteRow({
    super.key,
    required this.movieQuote,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTapCallback,
      leading: const Icon(Icons.movie),
      title: Text(
        movieQuote.quote,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        movieQuote.movie,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
