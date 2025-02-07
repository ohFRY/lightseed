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

    // Authentication guard
    final session = Supabase.instance.client.auth.currentSession;
    final isAuthenticated = session != null;
    
    // Protected routes that require authentication
    final protectedRoutes = [home, account];

    // Redirect to signin if trying to access protected route while not authenticated
    if (protectedRoutes.contains(settings.name) && !isAuthenticated) {
      return MaterialPageRoute(
        builder: (_) => SignScreen(),
        fullscreenDialog: true,
        maintainState: false,
      );
    }

    // Check if user is authenticated for initial route
    if (settings.name == splash) {
      final session = Supabase.instance.client.auth.currentSession;
      return MaterialPageRoute(
        builder: (context) => session == null 
            ? SignScreen() 
            : SplashScreen(),
        fullscreenDialog: true,
        maintainState: false,
      );
    }

  // Map routes
  switch (settings.name) {
    case splash:
      return MaterialPageRoute(
        builder: (_) => isAuthenticated ? SplashScreen() : SignScreen(),
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
      return MaterialPageRoute(
        builder: (_) => isAuthenticated ? MyMainScreen() : SignScreen(),
          fullscreenDialog: true,
          maintainState: false,
      );
    }
  }

}