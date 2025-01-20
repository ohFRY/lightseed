import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/logic/my_app_state.dart';
import 'src/logic/my_favourites_page_state.dart';
import 'src/ui/elements/navigation_rail.dart';
import 'src/ui/elements/navigation_bar.dart';
import 'src/ui/pages/generator_page.dart';
import 'src/ui/pages/my_favourites_page.dart';
import 'src/ui/theme/theme.dart';
import 'src/ui/theme/util.dart';

void main() {
  runApp(MyApp());
}

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
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = ChangeNotifierProvider(
          create: (context) => MyFavouritesPageState(context.read<MyAppState>()),
          child: MyFavouritesPage(),
        );
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          // Desktop
          return Scaffold(
            body: Row(
              children: [
                CustomNavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  extended: true,
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        } else if (constraints.maxWidth >= 600) {
          // Tablet
          return Scaffold(
            body: Row(
              children: [
                CustomNavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  extended: false,
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        } else {
          // Mobile
          return Scaffold(
            body: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
            bottomNavigationBar: CustomNavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          );
        }
      },
    );
  }
}