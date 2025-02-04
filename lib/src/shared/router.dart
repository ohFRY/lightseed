import 'package:flutter/material.dart';
import 'package:lightseed/src/ui/pages/today_page.dart';
import 'package:lightseed/src/ui/screens/account_screen.dart';
import 'package:lightseed/src/ui/screens/main_screen.dart';
import 'package:lightseed/src/ui/screens/sign_screen.dart';
import 'package:lightseed/src/ui/screens/splash_screen.dart';

class AppRoutes {
  static const home = '/';
  static const account = '/account';
  static const signIn = '/sign';
  static const splash = '/splash';
  static const main = '/main';

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
      home: (context) => TodayPage(),
      account: (context) => AccountScreen(),
      signIn: (context) => SignScreen(),
      splash: (context) => SplashScreen(),
      main: (context) => MyMainScreen(),
      // Add other routes here
    };
  }

}