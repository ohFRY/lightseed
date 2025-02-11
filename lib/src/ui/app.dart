import 'package:flutter/material.dart';
import 'package:lightseed/src/services/network/network_status_service.dart'; // Import NetworkStatus
import 'package:lightseed/src/shared/router.dart';
import 'package:lightseed/src/ui/theme/theme.dart';
import 'package:lightseed/src/ui/theme/util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _initialRoute = AppRoutes.splash; // Default to splash screen

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    debugPrint('🔑 Checking authentication...');
    try {
      final session = Supabase.instance.client.auth.currentSession;
      final isAuthenticated = session != null;
      debugPrint('🔑 Session exists: $isAuthenticated');

      setState(() {
        _initialRoute = isAuthenticated ? AppRoutes.home : AppRoutes.signin;
      });
    } catch (e) {
      debugPrint('❌ Error checking authentication: $e');
      // If we can't check auth (offline), but have cached session, allow home access
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        debugPrint('🔑 Using cached session');
        setState(() {
          _initialRoute = AppRoutes.home;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "LightSeed",
      theme: _buildThemeData(context, View.of(context).platformDispatcher.platformBrightness),
      builder: (context, child) {
        return ScaffoldMessenger( // Replace with MaterialApp's scaffoldMessengerKey
          key: GlobalKey<ScaffoldMessengerState>(),
          child: Scaffold( // Add Scaffold here
            body: NetworkStatus(
              child: child ?? const SizedBox(),
            ),
          ),
        );
      },
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: _initialRoute,
    );
  }

  ThemeData _buildThemeData(BuildContext context, Brightness brightness) {
    final textTheme = createTextTheme(context, "Lato", "Pacifico");
    final theme = MaterialTheme(textTheme);
    return brightness == Brightness.light ? theme.light() : theme.dark();
  }
}
