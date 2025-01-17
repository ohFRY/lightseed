import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_flutter_app/logic/my_favourites_page_state.dart';
import 'package:first_flutter_app/ui/elements/custom_app_bar.dart';

class MyFavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyFavouritesPageState>();

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.menu,
        title: 'Favorites',
        rightIcon: Icons.delete,
        onLeftIconPressed: () {
          Navigator.pop(context);
        },
        onRightIconPressed: () {
          appState.clearFavorites();
        },
      ),
      body: Center(
        child: appState.favorites.isEmpty
            ? Text('No favorites yet.')
            : ListView(
                children: [
                  ListTile(
                    title: Text('Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Your favorite word pairs'),
                    trailing: Text('${appState.favorites.length}'),
                  ),
                  for (var fav in appState.favorites)
                    ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text(fav),
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