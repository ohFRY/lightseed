import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lightseed/src/ui/screens/main_screen.dart';
import 'package:lightseed/src/ui/screens/sign_screen.dart';

class AuthStateListener extends StatefulWidget {
  final Widget child;

  AuthStateListener({required this.child});

  @override
  AuthStateListenerState createState() => AuthStateListenerState();
}

class AuthStateListenerState extends State<AuthStateListener> {
  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyMainScreen()),
        );
      } else if (event == AuthChangeEvent.signedOut) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}