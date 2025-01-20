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
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Lato", "Noto Serif");
    // Create theme from MaterialTheme class
    MaterialTheme theme = MaterialTheme(textTheme);

    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "LightSeed",
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        home: MyMainScreen(),
      ),
    );
  }
}