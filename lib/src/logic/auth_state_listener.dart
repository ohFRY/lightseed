import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/account_state_screen.dart';
import 'package:lightseed/src/models/user.dart';
import 'package:lightseed/src/shared/router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A widget that listens to authentication state changes and responds accordingly.
///
/// This widget wraps its [child] and provides authentication state management by:
/// 1. Listening to Supabase authentication events (sign-in, sign-out)
/// 2. Updating the application's user state via [AccountState]
/// 3. Handling navigation based on auth state changes
/// 4. Fetching and initializing user profile data
///
/// Place this widget high in the widget tree to ensure authentication
/// state is properly managed throughout the application.
///
/// Example:
/// ```dart
/// MaterialApp(
///   home: AuthStateListener(
///     child: MyApp(),
///   ),
/// )
/// ```
class AuthStateListener extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// Creates an authentication state listener.
  ///
  /// The [child] parameter must not be null.
  const AuthStateListener({required this.child, super.key});

  @override
  AuthStateListenerState createState() => AuthStateListenerState();
}

/// The state for the [AuthStateListener] widget.
///
/// This class handles the actual authentication state management logic,
/// including subscribing to auth state changes, managing user data,
/// and performing navigation actions.
class AuthStateListenerState extends State<AuthStateListener> {
  /// Subscription to Supabase authentication state changes.
  late StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    super.initState();

    // Initialize user if there's an existing session
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      _initializeUser(session.user);
    }

    // Listen for authentication state changes
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) async {
        debugPrint("AuthStateListener: received auth state change: ${data.event}");
        final AuthChangeEvent event = data.event;
        final Session? session = data.session;

        // Handle core navigation and state changes
        _handleAuthStateChange(event, session);

        // Process specific auth events
        switch (event) {
          case AuthChangeEvent.signedIn:
            if (session != null) {
              _handleSignIn(session);
            }
          case AuthChangeEvent.signedOut:
            _handleSignOut();
          default:
            debugPrint('AuthStateListener: Unhandled auth event: $event');
        }
      },
      onError: (error) {
        debugPrint("AuthStateListener: error: $error");
      },
    );
  }

  /// Initializes user data from Supabase session.
  ///
  /// This method:
  /// 1. Fetches the user's profile data from the 'profiles' table
  /// 2. Creates an [AppUser] instance with the fetched data
  /// 3. Updates the [AccountState] provider with the user data
  /// 4. Falls back to basic user data if profile fetch fails
  ///
  /// Parameters:
  ///   [supabaseUser] - The Supabase User instance from the current session
  Future<void> _initializeUser(User supabaseUser) async {
    try {
      // Fetch detailed user profile from database
      final userData = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', supabaseUser.id)
          .single();
      
      // Create application user with full profile data
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
      
      // Fallback to basic user with minimal data
      final basicUser = AppUser(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        fullName: '', // Could be populated from local storage
      );
      Provider.of<AccountState>(context, listen: false).setUser(basicUser);
    }
  }

  /// Handles sign-in events and user data initialization.
  ///
  /// Parameters:
  ///   [session] - The current Supabase session
  Future<void> _handleSignIn(Session session) async {
    if (!mounted) return;
    debugPrint('AuthStateListener: User signed in with ID: ${session.user.id}');
    
    try {
      // Fetch profile data
      final userData = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', session.user.id)
          .single();
      debugPrint('Profile data fetched: $userData');
      
      // Create and set app user
      final appUser = AppUser(
        id: session.user.id,
        email: session.user.email ?? '',
        fullName: userData['full_name'] ?? '',
      );
      
      if (!mounted) return;
      Provider.of<AccountState>(context, listen: false).setUser(appUser);
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      // Fallback to basic user
      if (!mounted) return;
      Provider.of<AccountState>(context, listen: false).setUserFromSupabase(session.user);
    }
  }

  /// Handles sign-out events and user state clearing.
  void _handleSignOut() {
    if (!mounted) return;
    debugPrint('AuthStateListener: User signed out');
    Provider.of<AccountState>(context, listen: false).clearUser();
  }

  /// Core handler for authentication state changes.
  ///
  /// This method manages navigation and critical state changes that
  /// should happen for each auth event type. It uses [Future.microtask]
  /// to safely perform navigation after the current build phase completes.
  ///
  /// Parameters:
  ///   [event] - The authentication change event type
  ///   [session] - The current session (may be null for sign-out events)
  void _handleAuthStateChange(AuthChangeEvent event, Session? session) {
    debugPrint('AuthStateListener: received auth state change: $event');
    
    if (event == AuthChangeEvent.signedOut) {
      debugPrint('AuthStateListener: User signed out');
      
      // Use microtask to navigate after current build phase
      if (mounted) {
        Future.microtask(() {
          try {
            if (mounted && context.mounted && Navigator.canPop(context)) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.signin,
                (route) => false,
              );
            }
          } catch (e) {
            debugPrint('Navigation error: $e');
            // Error means the context likely doesn't have a navigator
            // This is ok - the splash screen logic will handle redirection
          }
        });
      }
    } else if (event == AuthChangeEvent.signedIn) {
      final user = session?.user;
      if (user != null) {
        debugPrint('AuthStateListener: User signed in with ID: ${user.id}');
        
        // For sign-in events, DON'T navigate automatically
        // Let the individual screens (SignScreen, etc.) handle their own navigation
        // This prevents conflicts between manual navigation and auth listener navigation
        return;
      }
    }
  }

  @override
  void dispose() {
    debugPrint("AuthStateListener: disposing");
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}