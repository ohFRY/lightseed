import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Lottie Animation as Background
          Lottie.asset(
            'assets/animations/bg-waves-themed.json',
            fit: BoxFit.cover,
          ),

          // Centered Text
          Center(
            child: Text(
              "No internet connection",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Adjust color as needed
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}