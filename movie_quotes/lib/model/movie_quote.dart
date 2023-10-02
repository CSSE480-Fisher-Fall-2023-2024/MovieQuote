import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_quotes/model/firestore_model_utils.dart';

const kMovieQuotesCollectionPath = "MovieQuotes";
const kMovieQuoteQuote = "quote";
const kMovieQuoteMovie = "movie";
const kMovieQuoteLastTouched = "lastTouched";

class MovieQuote {
  String? documentId;
  String quote;
  String movie;
  Timestamp lastTouched;

  MovieQuote({
    this.documentId,
    required this.lastTouched,
    required this.movie,
    required this.quote,
  });

  MovieQuote.from(DocumentSnapshot doc)
      : this(
            documentId: doc.id,
            quote: FirestoreModelUtils.getStringField(doc, kMovieQuoteQuote),
            movie: FirestoreModelUtils.getStringField(doc, kMovieQuoteMovie),
            lastTouched: FirestoreModelUtils.getTimestampField(
                doc, kMovieQuoteLastTouched));

  // After Fall Break do the reverse of the above!

  @override
  String toString() {
    return "Quote: $quote  Movie: $movie";
  }
}
