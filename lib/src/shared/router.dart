import 'package:flutter/material.dart';
import 'package:lightseed/src/shared/animated_routes.dart';
import 'package:lightseed/src/ui/screens/account_screen.dart';
import 'package:lightseed/src/ui/screens/main_screen.dart';
import 'package:lightseed/src/ui/screens/sign_screen.dart';
import 'package:lightseed/src/ui/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRoutes {
  static const home = '/';
  static const splash = '/splash';
  static const String signin = '/signin';
  static const String account = '/account';

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

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print('onGenerateRoute called with: ${settings.name}');
    // Check if user is authenticated for initial route
    if (settings.name == splash) {
      final session = Supabase.instance.client.auth.currentSession;
      return MaterialPageRoute(
        builder: (context) => session == null ? SignScreen() : SplashScreen(),
      );
    }

    // Map routes directly without using getRoutes
    switch (settings.name) {
      case splash:
        final session = Supabase.instance.client.auth.currentSession;
        return MaterialPageRoute(
          builder: (_) => session == null ? SignScreen() : MyMainScreen(),
        );
      case home:
        return FadePageRoute(page: MyMainScreen());
      case signin:
        return MaterialPageRoute(builder: (_) => SignScreen());
      case account:
        return MaterialPageRoute(builder: (_) => AccountScreen());
      default:
        return MaterialPageRoute(builder: (_) => SignScreen());
    }
  }

}