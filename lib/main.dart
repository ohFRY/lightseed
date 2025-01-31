import 'package:flutter/material.dart';
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

  runApp(MyAppWithSplashScreen());
}

class MyAppWithSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildMaterialApp(context, SplashScreen());
  }
}