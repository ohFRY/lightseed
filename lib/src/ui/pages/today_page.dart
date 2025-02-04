import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:lightseed/src/ui/screens/account_screen.dart';
import 'package:provider/provider.dart';
import '../../logic/today_page_state.dart';
import '../elements/animated_text_card.dart';

class TodayPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<TodayPageState>();
    var accountState = context.watch<AccountState>();
    Affirmation affirmation = appState.getCurrentAffirmation();

    IconData icon;
    if (appState.favorites.contains(affirmation)) {
      icon = Icons.bookmark;
    } else {
      icon = Icons.bookmark_outline;
    }

    String getTitle() {
      int hour = DateTime.now().hour;
      String greeting;
      if (hour < 12) {
        greeting = 'Good morning';
      } else if (hour < 17) {
        greeting = 'Good afternoon';
      } else if (hour < 20) {
        greeting = 'Good evening';
      } else {
        greeting = 'Good night';
      }

      String? fullName = accountState.user?.fullName;
      if (fullName != null && fullName.isNotEmpty) {
        String firstName = fullName.split(' ').first;
        return '$greeting, $firstName';
      } else {
        return greeting;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
        toolbarHeight: 100, // Set the height of the AppBar
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountScreen(),
                ),
              );
            },
          ),
        ],
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
