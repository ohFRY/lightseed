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
    final session = Supabase.instance.client.auth.currentSession;
    final isAuthenticated = session != null;

    if (isAuthenticated) {
      setState(() {
        _initialRoute = AppRoutes.home; // Set initial route to home
      });
    } else {
      setState(() {
        _initialRoute = AppRoutes.signin; // Set initial route to signin
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "LightSeed",
        theme: _buildThemeData(context, View.of(context).platformDispatcher.platformBrightness),
        onGenerateRoute: AppRoutes.onGenerateRoute,
home: NetworkStatus( // Wrap the home with NetworkStatus
        child: Navigator(
          onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: _initialRoute,
        ),
      ),
    );
  }

  ThemeData _buildThemeData(BuildContext context, Brightness brightness) {
    final textTheme = createTextTheme(context, "Lato", "Pacifico");
    final theme = MaterialTheme(textTheme);
    return brightness == Brightness.light ? theme.light() : theme.dark();
  }
}
