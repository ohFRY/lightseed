import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:lightseed/src/logic/auth_state_listener.dart';
import 'package:lightseed/src/logic/timeline_state.dart';
import 'package:lightseed/src/logic/today_page_state.dart';
import 'package:lightseed/src/ui/app.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lightseed/config.dart'; // Import the configuration file
//import 'package:flutter_web_plugins/url_strategy.dart'; // For deep links on web, to support Supabase auth


Future<void> main() async {
  
  //if (kIsWeb) usePathUrlStrategy();
  //WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimelineState()),
        ChangeNotifierProvider(create: (_) => TodayPageState()),
        ChangeNotifierProvider(create: (_) => AccountState()),
      ],
      child: MyAppWithSplashScreen(),
    ),
  );
}

final supabase = Supabase.instance.client;

class MyAppWithSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthStateListener(
        child: MyApp(),
      );
  }
}