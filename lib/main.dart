import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/logic/auth_state_listener.dart';
import 'package:lightseed/src/logic/timeline_state.dart';
import 'package:lightseed/src/logic/today_page_state.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:lightseed/src/ui/theme/theme.dart';
import 'package:lightseed/src/ui/theme/util.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lightseed/config.dart'; // Import the configuration file
//import 'package:flutter_web_plugins/url_strategy.dart'; // For deep links on web, to support Supabase auth


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('🚀 Starting app...');

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  final accountState = AccountState();
  await accountState.fetchUser(); // Ensure the user is fetched before using the state

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => accountState),
        ChangeNotifierProvider(
          create: (_) => TimelineState(AuthLogic.getValidUserId() ?? '')
        ),
        ChangeNotifierProvider(create: (_) => TodayPageState(accountState)),
      ],
      child: NetworkStatus(
        child: MyAppWithSplashScreen(),
      ),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final supabase = Supabase.instance.client;

class MyAppWithSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthStateListener(
      child: MaterialApp(
        title: 'LightSeed',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: _buildThemeData(context, Brightness.light),
        darkTheme: _buildThemeData(context, Brightness.dark),
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: AppRoutes.splash,
      ),
    );
  }

  ThemeData _buildThemeData(BuildContext context, Brightness brightness) {
    final textTheme = createTextTheme(context, "Lato", "Pacifico");
    final theme = MaterialTheme(textTheme);
    return brightness == Brightness.light ? theme.light() : theme.dark();
  }
}