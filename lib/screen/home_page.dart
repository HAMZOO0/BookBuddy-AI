// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import '../widget/vertical_book_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for json convertion
import '../widget/book_card.dart';
import 'book_detail_page.dart';
import '../screen/book_search.dart';
import '../screen/favorite_page.dart';
import '../screen/chat_bot_interface.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textEditingController = TextEditingController();
  Future<Map<String, dynamic>>? futureSearchResult;
  String searchQuery = "";
  int currentPage = 0; // use for buttom_navigation_bar
  List<Widget> pages = const [FavoritePage(), ChatInterface()];

  final List<String> bookFilter = const [
    'All',
    'New Arrivals',
    'Best Sellers',
    'Fiction',
    'Non-Fiction',
    'Mystery',
    'Romance',
    'Science Fiction',
    'Fantasy',
    'History',
    'Self-Help',
  ];

  //    In Dart, instance members cannot be accessed directly when initializing another instance member. This is because instance members are not fully initialized until the class constructor has completed execution.
  // The initState method is called after all instance members are initialized but before the widget is built. This makes it the perfect place to initialize
  //   String selectedFilter = bookFilter[0];
  late String selectedFilter;

  Future<Map<String, dynamic>> fetchBookData({String? query}) async {
    String url;
    if (query == null || query.isEmpty) {
      url = "https://openlibrary.org/subjects/programming.json?limit=10";
    } else {
      // Search API endpoint with the search query
      url =
          "https://openlibrary.org/search.json?q=${Uri.encodeComponent(query)}&limit=10";
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // print('status code ---> ${response} ');
        return jsonData;
      } else {
        print('Failed to load data. Status Code: ${response.statusCode}');
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error fetching books: $e');
      throw Exception('Network error');
    }
  }

  Future<Map<String, dynamic>> fetchBookDataVerticalCards() async {
    const String url =
        "https://openlibrary.org/subjects/self_help.json?limit=10";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // print('status code ---> ${response} ');
        return jsonData;
      } else {
        print('Failed to load data. Status Code: ${response.statusCode}');
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error fetching books: $e');
      throw Exception('Network error');
    }
  }

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
  void initState() {
    super.initState();
    selectedFilter = bookFilter[0];
    // futureSearchResult = fetchBookData();
    // fetchBookData();
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
      futureSearchResult = fetchBookData(query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu), // Hamburger menu icon
          onPressed: () {},
        ),
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: textEditingController,

            decoration: InputDecoration(
              filled: true, // Required for fillColor to work
              fillColor: Colors.grey[200], // Light grey background
              hintText: 'Search books...',
              // border: InputBorder.none,
              hintStyle: TextStyle(color: const Color.fromARGB(179, 0, 0, 0)),
              prefixIcon: Icon(Icons.search),
              enabledBorder: OutlineInputBorder(
                // Default state
                borderSide: BorderSide(color: Color.fromRGBO(243, 233, 215, 1)),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),

                borderSide: BorderSide(color: Color.fromRGBO(243, 233, 215, 1)),
              ),
            ),
            // searching for query
            onSubmitted: onSearch,

            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                20.0,
              ), // Makes the image round
              child: Image.network(
                'https://avatars.githubusercontent.com/u/98114762?s=96&v=4',
                width: 40, // Adjusts the width
                height: 40, // Adjusts the height
                fit: BoxFit.cover, // Ensures the image fits within the bounds
              ),
            ),
          ),
        ],
      ),
      body:
          currentPage == 1
              ? FavoritePage()
              : currentPage == 2
              ? ChatInterface()
              : searchQuery.isEmpty
              ? FutureBuilder(
                future: Future.wait([
                  fetchBookData(),
                  fetchBookDataVerticalCards(),
                ]),
                builder: (context, snapshot) {
                  // print(snapshot?.data);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  final horizontalData = snapshot.data![0];
                  final verticalData = snapshot.data![1];
                  print("horizontalData === > $horizontalData");

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                "Popular Books ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: TextField(),
                            // ), // Expanded takes as much as poosbile space not entire space ..
                          ],
                        ),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: bookFilter.length,
                            itemBuilder: (context, index) {
                              String filter = bookFilter[index];
                              // print('this filter index : $filter');
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedFilter = filter;
                                    });
                                    // print('selectedFilter is $selectedFilter');
                                    // print("filter is $filter");
                                  },
                                  child: Chip(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor:
                                        selectedFilter == filter
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : Color.fromRGBO(244, 236, 221, 1),
                                    side: BorderSide(
                                      color: Color.fromRGBO(244, 236, 221, 1),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    label: Text(
                                      bookFilter[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        // VerticalBookCard(),
                        SizedBox(
                          height: 225,
                          child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,

                            itemBuilder: (context, index) {
                              final work = horizontalData['works'][index];
                              final String title = work['title'];
                              final String authorName =
                                  (work['authors'] as List).isNotEmpty
                                      ? (work['authors'][0]
                                          as Map<String, dynamic>)['name']
                                      : 'Unknown Author';
                              final int? coverId = work['cover_id'];

                              final String coverUrl =
                                  coverId != null
                                      ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
                                      : 'https://via.placeholder.com/150';

                              return GestureDetector(
                                onTap: () {
                                  print("===========> clink howa");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BookDetailPage(
                                          autherName: authorName,
                                          url: coverUrl,
                                          bookRating: "N/A",
                                          bookName: title,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: VerticalBookCard(
                                    url: coverUrl,
                                    autherName: authorName,
                                    bookName: title,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        // BookCard(),
                        ListView.builder(
                          shrinkWrap:
                              true, // Important! it use to  takes only the height it needs otherwise it widget dont know how much space shloud it take  and if we dont use then Crashes if inside Column, SingleChildScrollView, etc.
                          physics:
                              NeverScrollableScrollPhysics(), // This disables scrolling inside the nested list, and lets only the outer scroll view handle it.
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            final work = verticalData['works'][index];
                            final String title = work['title'];
                            final String authorName =
                                (work['authors'] as List).isNotEmpty
                                    ? (work['authors'][0]
                                        as Map<String, dynamic>)['name']
                                    : 'Unknown Author';
                            final int? coverId = work['cover_id'];

                            final String coverUrl =
                                coverId != null
                                    ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
                                    : 'https://via.placeholder.com/150 ';

                            final String key = work['key'];

                            // we use nested FutureBuilder and exprecting  to return double for our fetchBookRating() function
                            return FutureBuilder<double?>(
                              future: fetchBookRating(key),
                              builder: (context, snapshot) {
                                final String rating =
                                    snapshot.hasData
                                        ? snapshot.data!.toStringAsFixed(1)
                                        : '0';

                                // print('====> rating');

                                return GestureDetector(
                                  onTap: () {
                                    // print("===========> clink howa");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return BookDetailPage(
                                            autherName: authorName,
                                            url: coverUrl,
                                            bookRating: rating,
                                            bookName: title,
                                          );
                                        },
                                      ),
                                    );
                                  },
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
                        ),
                      ],
                    ),
                  );
                },
              )
              : BookSearch(futureSearchResult: futureSearchResult),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        currentIndex: currentPage,
        selectedFontSize: 16,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
        ],
      ),
    );
  }
}
