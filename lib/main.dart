import 'package:flutter/material.dart';
import 'package:lightseed/src/ui/screens/splash_screen.dart';


void main() {
  runApp(MyAppWithSplashScreen());
}

class MyAppWithSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}