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
                    title: Text('Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Your favorite affirmations'),
                    trailing: Text('${appState.favorites.length}'),
                  ),
                  for (var fav in appState.favorites)
                    ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text(fav.content),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
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