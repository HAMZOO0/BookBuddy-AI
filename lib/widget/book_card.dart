import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String url;
  final String bookName;
  final String autherName;
  final String bookRating;
  const BookCard({
    super.key,
    required this.url,
    required this.bookName,
    required this.autherName,
    required this.bookRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 241, 220),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //book cover
          ClipRRect(
            //  use for borderRadius
            borderRadius: BorderRadius.circular(5),

            child: Image.network(
              url, // Example
              height: 170,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),

          // Title, Author, Rating
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  width: 170,
                  child: Text(
                    bookName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 170,

                  child: Text(
                    autherName,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    final String rawRating =
                        bookRating; // Assuming bookRating is a String?

                    // Parse the rating safely
                    final double rating =
                        double.tryParse(rawRating ?? '') ?? 0.0;
                    if (index < rating) {
                      return Icon(Icons.star, color: Colors.amber, size: 20);
                    } else if (index < rating + 0.5) {
                      return Icon(
                        Icons.star_half,
                        color: Colors.amber,
                        size: 20,
                      );
                    } else {
                      return Icon(
                        Icons.star_border,
                        color: Colors.grey[300],
                        size: 20,
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
          // Bookmark Icon
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(Icons.bookmark_border, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
