import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/saved_affirmations_state.dart';

class SavedAffirmationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<SavedAffirmationsState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
      ),
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