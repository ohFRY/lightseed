import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/ui/screens/splash_screen.dart';
import 'package:lightseed/src/ui/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lightseed/config.dart'; // Import the configuration file



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Listen for auth state changes
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;
    final Session? session = data.session;
    
    if (event == AuthChangeEvent.signedIn && session != null) {
      final user = session.user;
      print('User signed in: ${user.email}');
      
      // Optionally, call your function to save additional user data
      AuthLogic.saveUserData(user);
    } else if (event == AuthChangeEvent.signedOut) {
      print('User signed out.');
    }
  });

  runApp(MyAppWithSplashScreen());
}

class MyAppWithSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildMaterialApp(context, SplashScreen());
  }
}