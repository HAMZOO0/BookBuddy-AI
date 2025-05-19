import 'package:bookbuddy/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/chat_bot.dart';

class BookDetailPage extends StatelessWidget {
  final String url;
  final String bookName;
  final String autherName;
  final String bookRating;
  const BookDetailPage({
    super.key,
    required this.url,
    required this.bookName,
    required this.autherName,
    required this.bookRating,
  });
  // Removed redundant rating field; use local variable in build method instead.

  @override
  Widget build(BuildContext context) {
    // print(Provider.of<FavoriteProvider>(context).favoriteList);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Hamburger menu icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SizedBox(
          height: 30,
          child: Text(
            "Book Detail",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 0.0, right: 16.0),
            child: ClipRRect(child: Icon(Icons.favorite_border_outlined)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 220, 239, 247),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Image.network(
                  url,
                  height: 170,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              // Spacer(flex: 2),
              Text(
                bookName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(autherName, style: TextStyle(fontSize: 12)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final double rating =
                      double.tryParse(bookRating ?? '') ?? 0.0;
                  return Icon(
                    index < rating.round() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ),

              SizedBox(height: 10),
              // add to library
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final Map<String, dynamic> book = {
                      'url': url,
                      'bookName': bookName,
                      'autherName': autherName,
                    };
                    Provider.of<FavoriteProvider>(
                      context,
                      listen: false,
                    ).addBook(book);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Book Added Succeessfully!"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(231, 248, 183, 43),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: Icon(
                    Icons.library_add,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  label: Text(
                    "Add to Library",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              //* book summary etc ..
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 247, 241, 220),
                ),
                // Ensure ChatInterface expands to fit its content and doesn't overflow
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: 300, // adjust as needed
                  minWidth: double.infinity,
                ),
                child: ChatInterface(bookName: bookName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
