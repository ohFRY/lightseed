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
import 'package:lightseed/src/ui/screens/emotion_log_screen.dart';
import 'package:provider/provider.dart';
import '../../logic/today_page_state.dart';
import '../elements/animated_text_card.dart';
import 'package:flutter/services.dart' show HapticFeedback;

class TodayPage extends StatefulWidget {
  final bool animationPlayed;
  final VoidCallback onAnimationFinished;

  const TodayPage(
      {super.key,
      required this.animationPlayed,
      required this.onAnimationFinished});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

// Add a field to track the listener
class _TodayPageState extends State<TodayPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GlobalKey _fabKey = GlobalKey();
  Function? _timelineListener; // Add this to track the listener
  TimelineState? _timelineState; // Add this to track the TimelineState

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Load emotions after the timeline has been loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final timelineState = Provider.of<TimelineState>(context, listen: false);
      final todayState = Provider.of<TodayPageState>(context, listen: false);
      
      // If timeline already has items, load emotions now
      if (timelineState.items.isNotEmpty) {
        todayState.loadTodayEmotions();
      } else {
        // Otherwise, wait until the timeline loads items
        // Use a one-time listener to avoid memory leaks
        _listenForTimelineItems(timelineState, todayState);
      }
    });
  }

  // Modify the _listenForTimelineItems method

void _listenForTimelineItems(TimelineState timelineState, TodayPageState todayState) {
  // Use a local variable to track if we've loaded emotions
  bool emotionsLoaded = false;
  
  void listener() {
    // Check if timeline has items and we haven't loaded emotions yet
    if (timelineState.items.isNotEmpty && !emotionsLoaded) {
      emotionsLoaded = true;
      
      // Only listen for the first successful load
      timelineState.removeListener(listener);
      _timelineListener = null; // Clear the reference
      
      // Load emotions
      if (mounted) {
        // Add a slight delay to avoid UI jank
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            todayState.loadTodayEmotions();
          }
        });
      }
    }
  }
  
  // Store references for cleanup
  _timelineState = timelineState;
  _timelineListener = listener;
  
  // Add the listener
  timelineState.addListener(listener);
}

  @override
  void dispose() {
    // Clean up the timeline listener if it exists
    if (_timelineListener != null && _timelineState != null) {
      _timelineState!.removeListener(_timelineListener as void Function());
    }
    
    _animationController.dispose();
    super.dispose();
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
            child: Text(
                'Failed to load affirmations. Please check your connection.'),
          ),
        );
      }

      // Rest of your existing builder logic...
      Affirmation currentAffirmation = todayState.currentAffirmation;
      bool isSaved = timelineState.items.any((item) =>
          item.type == TimelineItemType.affirmation &&
          item.metadata['affirmation_id'] == currentAffirmation.id);

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
                            final savedItem = timelineState.items.firstWhere(
                                (item) =>
                                    item.type == TimelineItemType.affirmation &&
                                    item.metadata['affirmation_id'] ==
                                        currentAffirmation.id);
                            await timelineState.removeFromTimeline(savedItem);
                          } else {
                            await timelineState
                                .addToTimeline(TimelineItem.fromAffirmation(
                              currentAffirmation,
                              supabase.auth.currentUser!.id,
                            ));
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
                        width:
                            600, // Set a fixed width to align with the affirmation container
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Emotions",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              spacing: 8.0,
                              children: () {
                                // Get emotion counts
                                final counts = todayState.getEmotionCounts();

                                // Create a set of unique emotion IDs
                                final uniqueEmotionIds = todayState
                                    .todayEmotions
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
          key: _fabKey, // Add the key to the FAB
          onPressed: () {
            // Provide haptic feedback
            HapticFeedback.mediumImpact();

            // Get FAB position using the key before navigation
            final RenderBox? renderBox = _fabKey.currentContext?.findRenderObject() as RenderBox?;
            final Offset? position = renderBox?.localToGlobal(Offset.zero);
            final Size? size = renderBox?.size;

            // Calculate center of FAB
            final Offset center = position != null && size != null
                ? Offset(position.dx + size.width / 2, position.dy + size.height / 2)
                : Offset(MediaQuery.of(context).size.width - 56, 
                         MediaQuery.of(context).size.height - 56);

            // Use PageRouteBuilder for custom transition
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const EmotionLogScreen(),
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  // Starting position (where FAB is)
                  final begin = Rect.fromCircle(
                      center: center, 
                      radius: 28.0);
                      
                  // Rest of the animation code remains the same
                  final end = Rect.fromLTWH(
                      0, 0,
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height);

                  final rectAnimation = RectTween(begin: begin, end: end)
                      .animate(CurvedAnimation(
                          parent: animation, curve: Curves.easeInOut));

                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, _) {
                      final rect = rectAnimation.value ?? end;

                      return Stack(
                        children: [
                          Positioned(
                            left: rect.left,
                            top: rect.top,
                            width: rect.width,
                            height: rect.height,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Tween<double>(begin: 56.0, end: 0.0)
                                      .animate(animation)
                                      .value),
                              child: Material(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: child,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ).then((result) {
              // Only refresh when result is explicitly true (emotions were added)
              if (result == true && context.mounted) {
                Provider.of<TodayPageState>(context, listen: false)
                    .refreshTodayEmotions();
              }
              // Don't do anything for other results
            });
          },
          child: const Icon(Icons.mood),
        ),
      );
    });
  }

  String getTitle(AccountState accountState) {
    int hour = DateTime.now().hour;
    String greeting = _getGreeting(hour);

    // Only append name if we have it
    if (accountState.user?.fullName != null &&
        accountState.user!.fullName!.isNotEmpty) {
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
