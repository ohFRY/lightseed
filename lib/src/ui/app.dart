import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/my_app_state.dart';
import 'package:lightseed/src/ui/theme/theme.dart';
import 'package:lightseed/src/ui/theme/util.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: buildMaterialApp(context, MyMainScreen()),
    );
  }
}

MaterialApp buildMaterialApp(BuildContext context, Widget home) {
  final brightness = View.of(context).platformDispatcher.platformBrightness;
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "LightSeed",
    theme: _buildThemeData(context, brightness),
    home: home,
  );
}

ThemeData _buildThemeData(BuildContext context, Brightness brightness) {
  final textTheme = createTextTheme(context, "Lato", "Pacifico");
  final theme = MaterialTheme(textTheme);
  return brightness == Brightness.light ? theme.light() : theme.dark();
}