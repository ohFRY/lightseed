import 'package:flutter/material.dart';
import 'package:lightseed/src/shared/extensions.dart';
import 'package:provider/provider.dart';
import '../../logic/my_app_state.dart';
import '../../logic/my_favourites_page_state.dart';
import '../elements/navigation_rail.dart';
import '../elements/navigation_bar.dart';
import '../pages/generator_page.dart';
import '../pages/my_favourites_page.dart';

class MyMainScreen extends StatefulWidget {
  @override
  State<MyMainScreen> createState() => _MyMainScreenState();
}

class _MyMainScreenState extends State<MyMainScreen> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = ChangeNotifierProvider(
          create: (context) => MyFavouritesPageState(context.read<MyAppState>()),
          child: MyFavouritesPage(),
        );
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
}