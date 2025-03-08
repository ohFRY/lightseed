import 'package:flutter/material.dart';
import 'package:lightseed/src/ui/screens/account_screen.dart';
import 'package:lightseed/src/ui/screens/loading_screen.dart';
import 'package:lightseed/src/ui/screens/main_screen.dart';
import 'package:lightseed/src/ui/screens/sign_screen.dart';
import 'package:lightseed/src/ui/screens/splash_screen.dart';
import 'package:lightseed/src/ui/screens/emotion_log_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppRoutes {
  static const home = '/';
  static const splash = '/splash';
  static const String signin = '/signin';
  static const String account = '/account';
  static const String accountSetup = '/account-setup';
  static const String emotionLog = '/emotion-log';
  static const String loading = '/loading';

  static final List<NavigationDestination> destinations = [
    NavigationDestination(
      icon: Icon(Icons.history),
      label: 'Past',
    ),
    NavigationDestination(
      icon: Icon(Icons.today),
      label: 'Present',
    ),
    NavigationDestination(
      icon: Icon(Icons.trending_up),
      label: 'Future',
    ),
  ];

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    debugPrint('onGenerateRoute called with: ${settings.name}');
    debugPrint('Stack trace at route generation: ${StackTrace.current}');

    // Special case handling for account setup after signup
    if (settings.name == accountSetup) {
      return MaterialPageRoute(
        builder: (_) => AccountScreen(isFromSignUp: true),
        fullscreenDialog: true,
      );
    }

    // Authentication guard (simplified)
    final session = Supabase.instance.client.auth.currentSession;
    final isAuthenticated = session != null;

    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          fullscreenDialog: true,
          maintainState: false,
        );
        
      case home:
        // Use pushAndRemoveUntil to clear the stack
        return MaterialPageRoute(
          builder: (_) => const MyMainScreen(),
          maintainState: false,
        );
        
      case signin:
        return MaterialPageRoute(
          builder: (_) => PopScope(
            canPop: false,
            child: SignScreen(),
          ),
          fullscreenDialog: true,
          maintainState: false,
        );
        
      // account route can stay in the switch statement
      case account:
        return MaterialPageRoute(
          builder: (_) => AccountScreen(),
          fullscreenDialog: true,
        );

      case emotionLog:
        return MaterialPageRoute(
          builder: (_) => const EmotionLogScreen(),
          fullscreenDialog: true,
        );

      case AppRoutes.loading:
        return MaterialPageRoute(
          builder: (context) => const LoadingScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => isAuthenticated ? const MyMainScreen() : SignScreen(),
          maintainState: false,
        );
    }
  }
}