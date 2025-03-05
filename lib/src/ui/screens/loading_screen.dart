import 'package:flutter/material.dart';
import 'package:lightseed/src/services/app_initialization_service.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;
  String _loadingMessage = "Loading your personal data...";

  @override
  void initState() {
    super.initState();
    
    // Use addPostFrameCallback to run code after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Start loading data
      final success = await AppInitializationService.initializeAppData(context);
      
      if (!mounted) return;
      
      if (success) {
        // Navigate to home screen
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else {
        // Show retry option
        setState(() {
          _isLoading = false;
          _loadingMessage = "Something went wrong. Please try again.";
        });
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _loadingMessage = "Error: ${e.toString().substring(0, 
            math.min(50, e.toString().length))}...";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use the same animation as your splash screen for consistency
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                "assets/animations/sun_breathing.json",
                fit: BoxFit.contain,
),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _loadingMessage,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            if (!_isLoading)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _loadingMessage = "Loading your personal data...";
                  });
                  _initializeApp();
                },
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }
}