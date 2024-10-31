import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:movie_quotes/pages/movie_quotes_list_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Remember Don't use run due to network images.  Use:
// flutter run -d chrome --web-renderer html
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // From: https://github.com/firebase/FirebaseUI-Flutter/blob/main/docs/firebase-ui-storage/getting-started.md
  await FirebaseUIStorage.configure(
    FirebaseUIStorageConfiguration(
      storage: FirebaseStorage.instance,
      uploadRoot: FirebaseStorage.instance.ref("Users"),
      namingPolicy: const UuidFileUploadNamingPolicy(),
    ),
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
