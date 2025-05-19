import 'package:bookbuddy/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorite = Provider.of<FavoriteProvider>(context).favoriteList;
    return Scaffold(
      body: ListView.builder(
        itemCount: favorite.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(favorite[index]['url']),
            ),

            trailing: IconButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Delete Book'),
                        content: const Text(
                          'Are you sure you want to remove this book from favorites?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                );
                if (confirm == true) {
                  Provider.of<FavoriteProvider>(
                    context,
                    listen: false,
                  ).removeBook(favorite[index]);
                }
              },
              icon: const Icon(Icons.delete),
              color: const Color.fromARGB(255, 141, 26, 17),
            ),
            title: Text(
              favorite[index]['bookName'],

              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text(favorite[index]['autherName']),
          );
        },
      ),
    );
  }
}
