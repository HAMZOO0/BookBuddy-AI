import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> favoriteList = [];

  void addBook(Map<String, dynamic> book) {
    favoriteList.add(book);
    notifyListeners();
    // print(book);
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text("Book Added Succeessfully!")));
  }

  void removeBook(Map<String, dynamic> book) {
    favoriteList.remove(book);

    notifyListeners();
  }
}
