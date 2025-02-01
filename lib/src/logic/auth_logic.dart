import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLogic {
  static Future<void> signUp(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      if (response.session != null) {
        print('Error during sign-up: ${response.session.toString()}');
      } else {
        print('Sign-up successful!');
      }
    } catch (e) {
      print('Error during sign-up: $e');
    }
  }

  static Future<void> signIn(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        print('Error during sign-up: ${response.session.toString()}');
      } else {
        print('Sign-in with email and password successful!');
      }
    } catch (e) {
      print('Error during sign-in with email/password: $e');
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

  static Future<void> saveUserData(User user) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles') // Your custom table to store user data
          .upsert({
        'id': user.id, // Matches the id from auth.users
        'email': user.email,
        'full_name': user.userMetadata?['full_name'],
        'avatar_url': user.userMetadata?['avatar_url'],
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
}
