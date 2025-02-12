import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:lightseed/src/logic/timeline_state.dart';
import 'package:lightseed/src/models/timeline_item.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:lightseed/src/shared/extensions.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:provider/provider.dart';
import '../../logic/today_page_state.dart';
import '../elements/animated_text_card.dart';

class TodayPage extends StatelessWidget {
  final bool animationPlayed;
  final VoidCallback onAnimationFinished;

  const TodayPage({super.key, required this.animationPlayed, required this.onAnimationFinished});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);  // Remove redundant Scaffold
  }

  Widget _buildBody(BuildContext context) {
    var todayState = context.watch<TodayPageState>();
    var timelineState = context.watch<TimelineState>();
    var accountState = context.watch<AccountState>();
    var isOnline = NetworkStatus.of(context)?.isOnline ?? true;

    if (todayState.hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Today'),
        ),
        body: const Center(
          child: Text('Failed to load affirmations. Please check your connection.'),
        ),
      );
    }

    Affirmation currentAffirmation = todayState.currentAffirmation;
    bool isSaved = timelineState.items.any((item) => 
      item.type == TimelineItemType.affirmation && item.id == currentAffirmation.id
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle(accountState)),
        toolbarHeight: 100,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Start the check but don't await it
              NetworkStatus.checkStatus(context);
              
              final isOnline = NetworkStatus.of(context)?.isOnline ?? false;
              if (!isOnline) {
                context.showOfflineSnackbar();
                return;
              }
              
              Navigator.of(context).pushNamed(AppRoutes.account);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AnimatedTextCard(
                    text: currentAffirmation.content,
                    icon: isSaved ? Icons.bookmark : Icons.bookmark_outline,
                    onIconPressed: () async {
                      if (!isOnline) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cannot save while offline'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
      
                      try {
                        if (isSaved) {
                          await timelineState.removeFromTimeline(
                            TimelineItem.fromAffirmation(currentAffirmation)
                          );
                        } else {
                          await timelineState.addToTimeline(
                            TimelineItem.fromAffirmation(currentAffirmation)
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    animationPlayed: animationPlayed,
                    onAnimationFinished: onAnimationFinished,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getTitle(AccountState accountState) {
    int hour = DateTime.now().hour;
    String greeting = _getGreeting(hour);
    
    // Only append name if we have it
    if (accountState.user?.fullName != null && accountState.user!.fullName!.isNotEmpty) {
      return '$greeting ${accountState.user!.fullName!.split(' ').first}';
    }
    
    return greeting; // Return just greeting if no name available
  }

  String _getGreeting(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    if (hour < 20) return 'Good evening';
    return 'Good night';
  }

}