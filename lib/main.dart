import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import './screen/home_page.dart';
import './provider/favorite_provider.dart';
// Here i am using provider for staemangment  there are 3 types of providers :
// ChangeNotifierProvider
// FutureProvider
// StreamProvider

void main() async {
  await dotenv.load(fileName: ".env"); // Load .env

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Color creamColor = Color.fromRGBO(
      248,
      228,
      192,
      1,
    ); // Classic cream color

    return ChangeNotifierProvider(
      create:
          (context) =>
              FavoriteProvider(), //FavoriteProvider(it extends from ChangeNotifier)   use to notifiy the changes
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "BookBuddy	",
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Lato',
          scaffoldBackgroundColor: creamColor, // Sets app background
          colorScheme: ColorScheme.light(
            surface: const Color.fromRGBO(
              248,
              228,
              192,
              1,
            ), // Cards/sheets color / app bar background colr
            primary: const Color.fromARGB(255, 220, 145, 6),
            onPrimary: Colors.white, // Icon color on primary
          ),
          textTheme: const TextTheme(
            bodySmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        // home: const BookDetailPage(
        //   bookName: "People Magnet",
        //   autherName: "Dale Carnigy",
        //   url:
        //       "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1561188423l/50841095.jpg",
        //   bookRating: " 5",
        // ),
        home: const HomePage(),
        // home: const (),
      ),
    );
  }
}
