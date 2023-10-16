import 'package:flutter/material.dart';
import 'package:movie_quotes/model/movie_quote.dart';
import 'package:movie_quotes/pages/login_front_page.dart';
import 'package:movie_quotes/pages/movie_quote_detail_page.dart';
import 'package:movie_quotes/pages/movie_quotes_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie Quotes",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MovieQuotesListPage(),
      // home: MovieQuoteDetailPage(MovieQuote(
      //   quote:
      //       "Hello. My name is Inigo Montoya. You killed my father. Prepare to die.",
      //   movie: "The Princess Bride",
      // )),
      // home: const LoginFrontPage(),
    );
  }
}
