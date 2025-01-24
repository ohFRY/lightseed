import 'package:flutter/material.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:provider/provider.dart';
import '../../logic/my_app_state.dart';
import '../elements/big_card.dart';

class GeneratorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Affirmation? affirmation = appState.getCurrentAffirmation();

    IconData icon;
    if (appState.favorites.contains(affirmation)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Creative affirmation of the day:'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BigCard(text: affirmation?.content ?? 'Loading...'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
