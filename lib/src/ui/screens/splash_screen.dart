import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lightseed/src/models/quote.dart';
import 'package:lightseed/src/ui/app.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late Future<Quote> _quoteFuture;

  @override
  void initState() {
    super.initState();
    _quoteFuture = getRandomDailyQuote();
    _initializeApp();
  }

  _initializeApp() async {
    // Simulate some background initialization work
    await Future.delayed(Duration(seconds: 4), () {});
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MyApp(),
        transitionDuration: const Duration(milliseconds: 1000),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quote>(
      future: _quoteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading quote"));
        } else {
          final quote = snapshot.data!;
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.displayMedium!,
                        textAlign: TextAlign.end,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            FadeAnimatedText(quote.quote, duration: const Duration(milliseconds: 4000), textAlign: TextAlign.center),
                          ],
                          totalRepeatCount: 1,
                        ),
                      ),
                    ),
                    
                    SizedBox(
                      height: 50,
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodyMedium!,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            FadeAnimatedText(quote.author, duration: const Duration(milliseconds: 4000), textAlign: TextAlign.right),
                          ],
                          totalRepeatCount: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: Lottie.asset(
                        "assets/animations/sun_breathing.json",
                        fit: BoxFit.fitWidth,
                        width: 300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
