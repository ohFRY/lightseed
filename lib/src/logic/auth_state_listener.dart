import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:lightseed/src/models/user.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStateListener extends StatefulWidget {
  final Widget child;

  const AuthStateListener({required this.child, super.key});

  @override
  AuthStateListenerState createState() => AuthStateListenerState();
}

class AuthStateListenerState extends State<AuthStateListener> {
  late StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    super.initState();

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      _initializeUser(session.user);
    }

    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      print("AuthStateListener: received auth state change: ${data.event}");
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.signedOut:
          print('AuthStateListener: User signed out');
          if(!mounted) return;
          Provider.of<AccountState>(context, listen: false).clearUser();
          Navigator.of(context).pop();
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.signin, (route) => false);
          
        case AuthChangeEvent.signedIn:
          if (session != null) {
            if (event == AuthChangeEvent.signedIn) {
              if (!mounted) return;
              print('AuthStateListener: User signed in with ID: ${session.user.id}');
              
              try {
                // Fetch profile data first
                final userData = await Supabase.instance.client
                    .from('profiles')
                    .select()
                    .eq('id', session.user.id)
                    .single();
                print('Profile data fetched: $userData');
                
                final appUser = AppUser(
                  id: session.user.id,
                  email: session.user.email ?? '',
                  fullName: userData['full_name'] ?? '',
                );
                
                if (!mounted) return;
                Provider.of<AccountState>(context, listen: false).setUser(appUser);
              } catch (e) {
                print('Error fetching profile: $e');
                // Fallback to basic user
                Provider.of<AccountState>(context, listen: false).setUserFromSupabase(session.user);
              }
              
            } else if (event == AuthChangeEvent.signedOut) {
              if (!mounted) return;
              print('AuthStateListener: User signed out');
              Provider.of<AccountState>(context, listen: false).clearUser();
              Navigator.of(context).pop();
            }
          }
          
        default:
          print('AuthStateListener: Unhandled auth event: $event');
      }
    },
    onError: (error) {
        print("AuthStateListener: error: $error");
      },
  );
  }

  Future<void> _initializeUser(User supabaseUser) async {
    try {
      final userData = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', supabaseUser.id)
          .single();
      
      final appUser = AppUser(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        fullName: userData['full_name'] ?? '',
        avatarUrl: userData['avatar_url'],
        darkMode: userData['dark_mode'],
      );
      
      if (!mounted) return;
      Provider.of<AccountState>(context, listen: false).setUser(appUser);
    } catch (e) {
      debugPrint('Error initializing user: $e');
      if (!mounted) return;
      // If offline, create basic user from cached data
      final basicUser = AppUser(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        fullName: '', // Or get from local storage
      );
      Provider.of<AccountState>(context, listen: false).setUser(basicUser);
    }
  }

  @override
  void dispose() {
    print("AuthStateListener: disposing");
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}