import 'package:lightseed/src/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLogic {
  static Future<String?> signUp(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null && response.session == null) {
        return 'Sign-up successful! Please confirm your email.';
      } else if (response.session != null) {
        return 'Sign-up successful and user is logged in!';
      } else {
        return 'Sign-up response: ${response.toString()}';
      }
    } catch (e) {
      return 'Error during sign-up: $e';
    }
  }
  
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

  static Future<void> signInWithGoogle() async {
    try {
      // Trigger OAuth Sign-In with Google
      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
    } catch (e) {
      print('Error during Google sign-in: $e');
    }
  }

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

  static Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      print('User signed out successfully!');
    } catch (e) {
      print('Error during sign-out: $e');
    }
  }
  
}