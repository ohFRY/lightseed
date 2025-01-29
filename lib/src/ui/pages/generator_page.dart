import 'package:flutter/material.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:provider/provider.dart';
import '../../logic/my_app_state.dart';
import '../elements/animated_text_card.dart';

class GeneratorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Affirmation affirmation = appState.getCurrentAffirmation();

    IconData icon;
    if (appState.favorites.contains(affirmation)) {
      icon = Icons.bookmark;
    } else {
      icon = Icons.bookmark_outline;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AnimatedTextCard(text: affirmation.content),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  tooltip: "Save",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
