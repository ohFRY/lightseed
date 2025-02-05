import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        print('Navigating to main screen');
        Provider.of<AccountState>(context, listen: false).setUserFromSupabase(session.user);
/*         Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyApp()),
        ); */
      } else if (event == AuthChangeEvent.signedOut) {
        if (!mounted) return;
        print('Navigating to sign-in screen');
        Provider.of<AccountState>(context, listen: false).clearUser();
        Navigator.of(context).pop();
        /* Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignScreen()),
        ); */
      }
    });

/*     // Check the initial authentication state
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignScreen()),
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AccountState>(context, listen: false).setUserFromSupabase(session.user);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyMainScreen()),
        );
      });
    }  */

  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}