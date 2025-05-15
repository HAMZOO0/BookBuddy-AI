import 'package:flutter/material.dart';

class VerticalBookCard extends StatelessWidget {
  final String url;
  final String bookName;
  final String autherName;

  const VerticalBookCard({
    super.key,
    required this.url,
    required this.bookName,
    required this.autherName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 220, // ← Fixed total height of card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book image (fixed height)
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Image.network(url, fit: BoxFit.cover),
          ),

          SizedBox(height: 5),

          // Book name (fixed height, optional)
          SizedBox(
            height: 30,
            child: Text(
              bookName,
              maxLines: 1,
              overflow:
                  TextOverflow
                      .ellipsis, //When the text is too long and doesn't fit in the given space, TextOverflow.ellipsis will cut it off and add three dots (…) at the end.
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),

          // Author name (fixed height)
          SizedBox(
            height: 20,
            child: Text(
              autherName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
