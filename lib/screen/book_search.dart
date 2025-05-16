import 'package:flutter/material.dart';
import '../widget/book_card.dart';
import 'dart:convert'; // for json convertion
import 'package:http/http.dart' as http;

class BookSearch extends StatelessWidget {
  const BookSearch({super.key, required this.futureSearchResult});

  final Future<Map<String, dynamic>>? futureSearchResult;
  // final String rating;

  Future<double?> fetchBookRating(String key) async {
    final url = 'https://openlibrary.org$key/ratings.json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['summary']['average']; // null if no ratings
      } else {
        print('Failed to load rating');
        return null;
      }
    } catch (e) {
      print('Error fetching rating: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: futureSearchResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!['docs'].isEmpty) {
          return Center(child: Text('No results found.'));
        }

        final searchResults = snapshot.data!['docs'];

        return ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final book = searchResults[index];
            final title = book['title'] ?? 'No title';
            final authors = book['author_name'] as List<dynamic>?;
            final authorName =
                (authors != null && authors.isNotEmpty)
                    ? authors[0]
                    : 'Unknown Author';

            final coverId = book['cover_i'];
            final coverUrl =
                coverId != null
                    ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
                    : 'https://upload.wikimedia.org/wikipedia/commons/6/65/No-Image-Placeholder.svg';

            final String key = book['key'];
            print("title : $title");
            print("coverUrl : $coverUrl");
            print("authorName : $authorName");
            return FutureBuilder(
              future: fetchBookRating(key),
              builder: (context, snapshot) {
                final String rating =
                    snapshot.hasData ? snapshot.data!.toStringAsFixed(1) : '0';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BookCard(
                    url: coverUrl,
                    autherName: authorName,
                    bookName: title,
                    bookRating: rating,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
