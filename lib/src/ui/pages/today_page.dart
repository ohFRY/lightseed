import 'package:flutter/material.dart';
import 'package:lightseed/main.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:lightseed/src/logic/timeline_state.dart';
import 'package:lightseed/src/models/timeline_item.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:lightseed/src/shared/extensions.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:lightseed/src/ui/elements/emotion_chip.dart';
import 'package:provider/provider.dart';
import '../../logic/today_page_state.dart';
import '../elements/animated_text_card.dart';

class TodayPage extends StatefulWidget {
  final bool animationPlayed;
  final VoidCallback onAnimationFinished;

  const TodayPage({super.key, required this.animationPlayed, required this.onAnimationFinished});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  @override
  void initState() {
    super.initState();
    // Load emotions once when the page is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodayPageState>(context, listen: false).loadTodayEmotions();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Simply use the existing providers
    return Consumer3<TodayPageState, TimelineState, AccountState>(
      builder: (context, todayState, timelineState, accountState, child) {
        // Your existing Consumer3 builder code here, without the ChangeNotifierProvider
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
        
        // Rest of your existing builder logic...
        Affirmation currentAffirmation = todayState.currentAffirmation;
        bool isSaved = timelineState.items.any((item) => 
          item.type == TimelineItemType.affirmation && 
          item.metadata['affirmation_id'] == currentAffirmation.id
        );
        
        return Scaffold(
          appBar: AppBar(
            title: Text(getTitle(accountState)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                padding: const EdgeInsets.all(16.0),
                tooltip: 'Account',
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
                    SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                              final savedItem = timelineState.items.firstWhere((item) =>
                                item.type == TimelineItemType.affirmation &&
                                item.metadata['affirmation_id'] == currentAffirmation.id
                              );
                              await timelineState.removeFromTimeline(savedItem);
                            } else {
                              await timelineState.addToTimeline(
                                TimelineItem.fromAffirmation(
                                  currentAffirmation,
                                  supabase.auth.currentUser!.id,
                                )
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
                        animationPlayed: widget.animationPlayed,
                        onAnimationFinished: widget.onAnimationFinished,
                      ),
                    ),
                    // Display today's logged emotions here
                    if (todayState.todayEmotions.isNotEmpty)
                    Center(
                      child: Container(
                        width: 600, // Set a fixed width to align with the affirmation container
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Emotions",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              spacing: 8.0,
                              children: () {
                                // Get emotion counts
                                final counts = todayState.getEmotionCounts();
                                
                                // Create a set of unique emotion IDs
                                final uniqueEmotionIds = todayState.todayEmotions
                                    .map((e) => e.id)
                                    .toSet();
                                    
                                // Map each unique emotion to a chip
                                return uniqueEmotionIds.map((id) {
                                  // Find the emotion object for this ID
                                  final emotion = todayState.todayEmotions
                                      .firstWhere((e) => e.id == id);
                                      
                                  // Get the count for this emotion
                                  final count = counts[id] ?? 0;
                                  
                                  return EmotionChip(
                                    label: emotion.name,
                                    count: count,
                                    emotion: emotion,
                                    // No need for selection or onTap since these are just displays
                                  );
                                }).toList();
                              }(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.emotionLog).then((result) {
              if (result == true) {
                // Refresh emotions when returning with success
                if (context.mounted) Provider.of<TodayPageState>(context, listen: false).refreshTodayEmotions();
              }
            });
            },
            child: const Icon(Icons.mood),
          ),
        );
      }
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