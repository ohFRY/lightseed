import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/my_generator_page_state.dart';
import '../elements/big_card.dart';
import '../elements/custom_app_bar.dart';

class GeneratorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    String text = appState.getCurrentAffirmation();

    IconData icon;
    if (appState.favorites.contains(text)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: Icons.menu,
        title: 'Generator',
        rightIcon: Icons.refresh,
        onLeftIconPressed: () {
          // Handle left icon press for GeneratorPage
        },
        onRightIconPressed: () {
          // Handle right icon press for GeneratorPage
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Creative affirmation of the day:'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BigCard(text: text),
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
