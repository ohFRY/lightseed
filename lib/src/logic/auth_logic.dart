import 'package:flutter/material.dart';
import 'package:lightseed/src/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides authentication functionality for the application.
/// 
/// This class encapsulates all authentication operations including:
/// - User registration (sign-up)
/// - Authentication (sign-in) with email/password and social providers
/// - User session management
/// - Profile data persistence
/// - Authentication state verification
/// 
/// All methods are static to allow easy access throughout the application
/// without requiring instance creation.
class AuthLogic {
  /// Registers a new user with email and password.
  /// 
  /// This method:
  /// 1. Sets a flag to track the sign-up flow state
  /// 2. Attempts to register the user with Supabase
  /// 3. Returns a status message indicating success or failure
  /// 
  /// Parameters:
  ///   [email] - The email address for the new account
  ///   [password] - The password for the new account
  /// 
  /// Returns a status message describing the result of the operation.
  /// Messages containing "successful" indicate the operation succeeded.
  static Future<String?> signUp(String email, String password) async {
    try {
      // Set a flag that we're starting a sign-up flow
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('in_signup_flow', true);
      
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null && response.session == null) {
        return 'Sign-up successful! Please confirm your email.';
      } else if (response.session != null) {
        return 'Sign-up successful and user is logged in!';
      } else {
        // Clear flag if sign-up fails
        await prefs.setBool('in_signup_flow', false);
        return 'Sign-up response: ${response.toString()}';
      }
    } catch (e) {
      // Clear flag if sign-up fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('in_signup_flow', false);
      return 'Error during sign-up: $e';
    }
  }
  
  /// Authenticates a user with email and password.
  /// 
  /// This method:
  /// 1. Checks if a user is already logged in
  /// 2. Attempts to authenticate the user with Supabase
  /// 3. Returns a status message indicating success or failure
  /// 
  /// Parameters:
  ///   [email] - The email address for authentication
  ///   [password] - The password for authentication
  /// 
  /// Returns a status message describing the result of the operation.
  /// Messages containing "successful" indicate the operation succeeded.
  static Future<String?> signIn(String email, String password) async {
    try {
      final currentSession = Supabase.instance.client.auth.currentSession;
      if (currentSession != null) {
        return 'User is already logged in!';
      }

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        return 'Sign-in with email and password successful!';
      } else {
        return 'Error during sign-in: ${response.toString()}';
      }
    } catch (e) {
      return 'Error during sign-in with email/password: $e';
    }
  }

  /// Initiates Google OAuth sign-in flow.
  /// 
  /// This method redirects the user to Google's authentication page
  /// and handles the OAuth flow. The redirect back to the app and
  /// session creation are handled by Supabase.
  /// 
  /// This is an asynchronous operation with no return value.
  /// Authentication state changes should be monitored through
  /// AuthStateListener or Supabase auth state events.
  static Future<void> signInWithGoogle() async {
    try {
      // Trigger OAuth Sign-In with Google
      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
    } catch (e) {
      print('Error during Google sign-in: $e');
    }
  }

  /// Saves user profile data to the database.
  /// 
  /// This method persists the user's profile information to Supabase,
  /// ensuring that profile details are available across sessions and devices.
  /// 
  /// Parameters:
  ///   [user] - The AppUser object containing profile data to save
  /// 
  /// This is an asynchronous operation with no return value.
  /// Success or failure is logged to the console.
  static Future<void> saveUserData(AppUser user) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles') // Your custom table to store user data
          .upsert({
        'id': user.id, // Matches the id from auth.users
        'full_name': user.fullName,
        ...user.toSupabaseMetadata(),
      });

      // The new client libraries may throw an exception on error, so you might not get a response.error.
      if (response.error != null) {
        print('Error saving user data: ${response.error!.message}');
      } else {
        print('User data saved successfully!');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  /// Signs out the current user.
  /// 
  /// This method:
  /// 1. Ends the user's session with Supabase
  /// 2. Clears the authentication state
  /// 
  /// The UI should respond to this state change through AuthStateListener
  /// or by checking authentication state before protected operations.
  /// 
  /// This is an asynchronous operation with no return value.
  /// Success or failure is logged to the console.
  static Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      print('User signed out successfully!');
    } catch (e) {
      print('Error during sign-out: $e');
    }
  }
  
  /// Checks if the user is authenticated and the server is reachable.
  /// 
  /// This method performs two checks:
  /// 1. Verifies that the user has a valid, non-expired session
  /// 2. Attempts to connect to the server to confirm online status
  /// 
  /// For authenticated users with server connectivity issues, this method
  /// allows the application to proceed in offline mode.
  /// 
  /// Returns true if the user is authenticated and the server is reachable,
  /// or if the user is authenticated but in offline mode.
  /// Returns false if the user is not authenticated.
  static Future<bool> checkAuthAndConnection() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        debugPrint('🔑 Auth check: No session found');
        return false;
      }
      if (session.isExpired) {
        debugPrint('🔑 Auth check: Session expired');
        return false;
      }

      try {
        final healthCheck = await Supabase.instance.client
            .from('health_checks')
            .select()
            .limit(1)
            .maybeSingle()
            .timeout(const Duration(seconds: 5));
        final serverOnline = (healthCheck != null);
        debugPrint('🔑 Server check: ${serverOnline ? 'online' : 'offline'}');

        // For authenticated users, return online status from server check.
        return serverOnline;
      } catch (e) {
        debugPrint('🔑 Server unreachable: $e');
        // When the server is unreachable—but the user is authenticated—proceed in offline mode.
        return true;
      }
    } catch (e) {
      debugPrint('🔑 Auth check error: $e');
      return false;
    }
  }

  /// Retrieves the current user ID if the session is valid.
  /// 
  /// This is a convenience method that checks if there's a valid
  /// non-expired session and returns the user ID from that session.
  /// 
  /// Returns the authenticated user's ID or null if:
  /// - There's no current session
  /// - The current session has expired
  static String? getValidUserId() {
    final session = Supabase.instance.client.auth.currentSession;
    if (session?.isExpired ?? true) {
      debugPrint('⚠️ Session expired or null');
      return null;
    }
    return Supabase.instance.client.auth.currentUser?.id;
  }
}