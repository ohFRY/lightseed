import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../shared/router.dart'; // Import the router file

class AuthStateListener extends StatefulWidget {
  final Widget child;

  const AuthStateListener({required this.child, super.key});

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
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      } else if (event == AuthChangeEvent.signedOut) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.signIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}