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

    String getTitle() {
      int hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Good morning';
      } else if (hour < 17) {
        return 'Good afternoon';
      } else if (hour < 20) {
        return 'Good evening';
      } else {
        return 'Good night';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
        toolbarHeight: 100, // Set the height of the AppBar
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AnimatedTextCard(
                text: affirmation.content,
                icon: icon,
                onIconPressed: () {
                  appState.toggleFavorite();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
