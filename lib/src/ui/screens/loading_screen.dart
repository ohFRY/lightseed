import 'package:flutter/material.dart';
import 'package:lightseed/src/services/app_initialization_service.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;
import 'dart:async';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;
  String _loadingMessage = "Loading your personal data...";
  bool _initializationStarted = false;
  Timer? _networkPollTimer;

  @override
  void initState() {
    super.initState();
    
    // Use addPostFrameCallback to run code after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    if (_initializationStarted) return;
    _initializationStarted = true;
    
    try {
      // Safely check network status
      bool isOnline = true;  // Default to true
      try {
        final networkStatus = NetworkStatusProvider.instance;
        isOnline = networkStatus.isOnline;
      } catch (e) {
        debugPrint('Network status check failed: $e');
      }
      
      if (!isOnline) {
        // Show offline message
        setState(() {
          _isLoading = false;
          _loadingMessage = "You appear to be offline. Please check your connection.";
        });
        
        // Set up polling for network status
        _startNetworkPolling();
        return;
      }
      
      // App initialization
      final success = await AppInitializationService.initializeAppData(context);
      
      if (!mounted) return;
      
      if (success) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      } else {
        setState(() {
          _isLoading = false;
          _loadingMessage = "Something went wrong. Please try again.";
          _initializationStarted = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _loadingMessage = "Error: ${e.toString().substring(0, 
            math.min(50, e.toString().length))}...";
        _initializationStarted = false;
      });
    }
  }

  void _startNetworkPolling() {
    // Cancel existing timer if any
    _networkPollTimer?.cancel();
    
    _networkPollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      try {
        final networkStatus = NetworkStatusProvider.instance;
        if (networkStatus.isOnline && !_isLoading) {
          timer.cancel();
          setState(() {
            _isLoading = true;
            _loadingMessage = "Connection restored! Loading your data...";
          });
          _initializationStarted = false;
          _initializeApp();
        }
      } catch (e) {
        debugPrint('Network polling error: $e');
      }
    });
  }

  @override
  void dispose() {
    _networkPollTimer?.cancel();
    super.dispose();
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