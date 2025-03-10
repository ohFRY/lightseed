import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:lightseed/src/shared/extensions.dart';
import 'package:lightseed/src/ui/screens/offline_screen.dart';
import 'package:provider/provider.dart';
import 'package:lightseed/src/logic/timeline_state.dart';
import 'package:lightseed/src/logic/today_page_state.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import '../elements/navigation_rail.dart';
import '../elements/navigation_bar.dart';
import '../pages/today_page.dart';
import '../pages/timeline_page.dart';

class MyMainScreen extends StatefulWidget {
  const MyMainScreen({super.key});

  @override
  State<MyMainScreen> createState() => MyMainScreenState();
}

class MyMainScreenState extends State<MyMainScreen> {
  var selectedIndex = 1;
  TodayPageState? _todayPageState;
/* 
  @override
  void initState() {
    super.initState();
    
    // Check if timeline is already populated before triggering refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final timelineState = Provider.of<TimelineState>(context, listen: false);
        // Only refresh if timeline is empty
        if (timelineState.items.isEmpty) {
          handleRefresh(context);
        }
      }
    });
  } */

  @override
  Widget build(BuildContext context) {
    // Get the AccountState once at the MainScreen level
    final accountState = Provider.of<AccountState>(context);
    // Create TodayPageState only once
    _todayPageState ??= TodayPageState(accountState);
    // Create TodayPageState provider at the MainScreen level
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TodayPageState(Provider.of<AccountState>(context, listen: false)),
        ),
      ],
      child: _buildMainScreenContent(context),
    );
  }


  bool _animationPlayed = false; // Add a flag to track if the animation has played

  static Future<void> handleRefresh(BuildContext context) async {
    final userId = AuthLogic.getValidUserId();
    if (userId == null) return;

    final isOnline = NetworkStatus.of(context)?.isOnline ?? false;
    if (!isOnline) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot refresh while offline')),
      );
      return;
    }

    if (!context.mounted) return;
    final todayPageState = Provider.of<TodayPageState>(context, listen: false);
    
    await Future.wait([
      Provider.of<TimelineState>(context, listen: false).refreshTimeline(),
      todayPageState.fetchAllAffirmations(),
      todayPageState.refreshTodayEmotions(), // Also refresh today's emotions
    ]);
  }

  Widget _buildPage(Widget page) {
    return RefreshIndicator(
      onRefresh: () => handleRefresh(context),
      child: page,
    );
  }

  Widget _buildMainScreenContent(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 1:
        page = _buildPage(TodayPage(
          animationPlayed: _animationPlayed, 
          onAnimationFinished: _onAnimationFinished
        ));
      case 0:
        page = _buildPage(TimelinePage());
      case 2:
        page = OfflineScreen();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.isDesktop) {
              // Desktop
              return Scaffold(
                body: Row(
                  children: [
                    CustomNavigationRail(
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                      extended: true,
                    ),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: page,
                      ),
                    ),
                  ],
                ),
              );
            } else if (constraints.isTablet) {
              // Tablet
              return Scaffold(
                body: Row(
                  children: [
                    CustomNavigationRail(
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                      extended: false,
                    ),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: page,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Mobile
              return Scaffold(
                body: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
                bottomNavigationBar: CustomNavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              );
            }
          },
        ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: StreamBuilder<bool>(
          stream: NetworkStatus.of(context)?.networkStatusStream,
          builder: (context, snapshot) {
            final timelineState = Provider.of<TimelineState>(context);
            final todayState = Provider.of<TodayPageState>(context);
            
            if ((timelineState.isLoading || todayState.isLoading) && 
                NetworkStatus.of(context)?.isOnline == true) {
              return LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha((0.4 * 255).toInt()),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      ],
    );
  }

  void _onAnimationFinished() {
    setState(() {
      _animationPlayed = true;
    });
  }
}