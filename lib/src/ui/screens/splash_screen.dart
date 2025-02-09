import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lightseed/src/models/quote.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<void> _initializeApp() async {
    // Show quote for at least 4 seconds
    await Future.delayed(const Duration(seconds: 4));
    
    if (!mounted) return;

    // Check authentication status
    final session = Supabase.instance.client.auth.currentSession;
    final isAuthenticated = session != null;

    if (!mounted) return;

    // Navigate to appropriate screen and clear stack
    Navigator.pushNamedAndRemoveUntil(
      context,
      isAuthenticated ? AppRoutes.home : AppRoutes.signin,
      (route) => false,
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
                    // quote phrase
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
                    
                    // quote author
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
                    // Lottie animation
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
