import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_state_listener.dart';
import 'package:lightseed/src/logic/today_page_state.dart';
import 'package:lightseed/src/ui/screens/splash_screen.dart';
import 'package:lightseed/src/ui/app.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lightseed/config.dart'; // Import the configuration file
import 'package:flutter_web_plugins/url_strategy.dart'; // For deep links on web, to support Supabase auth


Future<void> main() async {
  if (kIsWeb) usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(
    // I needed to add a multiprovider because without it 
    // when on the splash screen and the user isn't logged in,
    // TodayPage is trying to be accessed and I'm getting an Exception that the provider doesn't exist
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodayPageState()),
        // Add other providers here if needed
      ],
      child: MyAppWithSplashScreen(),
    ),
  );
}

class MyAppWithSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthStateListener(
      child: buildMaterialApp(context, SplashScreen()),
    );
  }
}