import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/my_favourites_page_state.dart';

class MyFavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyFavouritesPageState>();

    return Scaffold(
      body: Center(
        child: appState.favorites.isEmpty
            ? Text('No favorites yet.')
            : ListView(
                children: [
                  ListTile(
                    title: Text('Your saved affirmations', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  for (var fav in appState.favorites)
                    ListTile(
                      title: Text(fav.content),
                      titleTextStyle: Theme.of(context).textTheme.headlineMedium,
                        trailing: IconButton(
                        icon: Icon(Icons.bookmark),// Adjust the padding to align with the title
                        onPressed: () {
                          appState.removeFavorite(fav);
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}