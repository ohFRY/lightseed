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

    // Authentication guard (simplified)
    final session = Supabase.instance.client.auth.currentSession;
    final isAuthenticated = session != null;

    // Map routes
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(), // Always show SplashScreen initially
          fullscreenDialog: true,
          maintainState: false,
        );
      case home:
        return FadePageRoute(page: MyMainScreen());
      case signin:
        return MaterialPageRoute(
          builder: (_) => PopScope(
            canPop: false, // Prevent back navigation
            child: SignScreen(),
          ),
          fullscreenDialog: true,
          maintainState: false,
        );
      case account:
        return MaterialPageRoute(builder: (_) => AccountScreen());
      default:
        // Default route: check authentication and navigate accordingly
        return MaterialPageRoute(
          builder: (_) => isAuthenticated ? MyMainScreen() : SignScreen(),
          fullscreenDialog: true,
          maintainState: false,
        );
    }
  }
}