import 'package:flutter/material.dart';
import 'package:lightseed/src/ui/screens/main_screen.dart';
import 'package:lightseed/src/ui/screens/splash_screen.dart';

class AppRoutes {
  static const home = '/';
  static const splash = '/splash';

  static final List<NavigationDestination> destinations = [

    NavigationDestination(
      icon: Icon(Icons.history),
      label: 'Past',
    ),
    NavigationDestination(
      icon: Icon(Icons.today),
      label: 'Today',
    ),
    NavigationDestination(
      icon: Icon(Icons.trending_up),
      label: 'Future',
    ),
  ];

  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      splash: (context) => SplashScreen(),
      home: (context) => MyMainScreen(),
      // Add other routes here
    };
  }

}