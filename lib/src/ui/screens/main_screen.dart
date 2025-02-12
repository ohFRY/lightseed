import 'package:flutter/material.dart';
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
    await Future.wait([
      Provider.of<TimelineState>(context, listen: false).refreshTimeline(),
      Provider.of<TodayPageState>(context, listen: false).fetchAllAffirmations(),
    ]);
  }

  Widget _buildPage(Widget page) {
    return RefreshIndicator(
      onRefresh: () => handleRefresh(context),
      child: page,
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return LayoutBuilder(
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
            appBar: AppBar(
              title: Text('Today'),
              automaticallyImplyLeading: false, // Remove back button
            ),
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
    );
  }

  void _onAnimationFinished() {
    setState(() {
      _animationPlayed = true;
    });
  }
}