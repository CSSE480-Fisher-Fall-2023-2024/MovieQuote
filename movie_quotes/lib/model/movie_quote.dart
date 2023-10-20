import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_quotes/model/firestore_model_utils.dart';

const kMovieQuotesCollectionPath = "MovieQuotes";
const kMovieQuoteAuthorUid = "authorUid";
const kMovieQuoteLastTouched = "lastTouched";
const kMovieQuoteMovie = "movie";
const kMovieQuoteQuote = "quote";

class MovieQuote {
  String? documentId;
  String authorUid;
  Timestamp lastTouched;
  String movie;
  String quote;

  MovieQuote({
    this.documentId,
    required this.authorUid,
    required this.lastTouched,
    required this.movie,
    required this.quote,
  });

  MovieQuote.from(DocumentSnapshot doc)
      : this(
            documentId: doc.id,
            authorUid:
                FirestoreModelUtils.getStringField(doc, kMovieQuoteAuthorUid),
            quote: FirestoreModelUtils.getStringField(doc, kMovieQuoteQuote),
            movie: FirestoreModelUtils.getStringField(doc, kMovieQuoteMovie),
            lastTouched: FirestoreModelUtils.getTimestampField(
                doc, kMovieQuoteLastTouched));

  // Preparing this for MUCH later.
  Map<String, Object?> toMap() => {
        kMovieQuoteAuthorUid: authorUid,
        kMovieQuoteLastTouched: lastTouched,
        kMovieQuoteMovie: movie,
        kMovieQuoteQuote: quote,
      };

  @override
  String toString() {
    return "Quote: $quote  Movie: $movie";
  }
}
