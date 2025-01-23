import 'package:flutter/material.dart';
import 'package:lightseed/src/ui/screens/splash_screen.dart';
import 'package:lightseed/src/ui/app.dart';


void main() {
  runApp(MyAppWithSplashScreen());
}

class MyAppWithSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildMaterialApp(context, SplashScreen());
  }
}