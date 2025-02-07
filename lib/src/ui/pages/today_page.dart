import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:lightseed/src/logic/timeline_state.dart';
import 'package:lightseed/src/models/timeline_item.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:provider/provider.dart';
import '../../logic/today_page_state.dart';
import '../elements/animated_text_card.dart';

class TodayPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var todayState = context.watch<TodayPageState>();
    var timelineState = context.watch<TimelineState>();
    var accountState = context.watch<AccountState>();
    
    Affirmation currentAffirmation = todayState.currentAffirmation;
    bool isSaved = timelineState.items
        .any((item) => item.type == TimelineItemType.affirmation && 
                       item.id == currentAffirmation.id);

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
              Navigator.of(context).pushNamed(AppRoutes.account);
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
                text: currentAffirmation.content,
                icon: isSaved ? Icons.bookmark : Icons.bookmark_outline,
                onIconPressed: () {
                  if (isSaved) {
                    timelineState.removeFromTimeline(TimelineItem.fromAffirmation(currentAffirmation));
                  } else {
                    timelineState.addToTimeline(TimelineItem.fromAffirmation(currentAffirmation));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
