import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/today_page_state.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:lightseed/src/ui/theme/theme.dart';
import 'package:lightseed/src/ui/theme/util.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodayPageState(),
      child: buildMaterialApp(context),
    );
  }
}

MaterialApp buildMaterialApp(BuildContext context) {
  final brightness = View.of(context).platformDispatcher.platformBrightness;
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "LightSeed",
    theme: _buildThemeData(context, brightness),
    onGenerateRoute: AppRoutes.onGenerateRoute,
    initialRoute: AppRoutes.splash,
  );
}

ThemeData _buildThemeData(BuildContext context, Brightness brightness) {
  final textTheme = createTextTheme(context, "Lato", "Pacifico");
  final theme = MaterialTheme(textTheme);
  return brightness == Brightness.light ? theme.light() : theme.dark();
}