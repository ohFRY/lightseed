import 'package:supabase_flutter/supabase_flutter.dart';

/// Represents a user in the application.
///
/// This class provides a domain-specific user model that maps between
/// the application's user concept and Supabase authentication.
///
/// It includes:
/// - Core user identity fields (id, email)
/// - Profile information (fullName, avatarUrl)
/// - Application preferences (darkMode)
/// - Methods to convert between Supabase and app-specific formats
class AppUser {
  /// Unique identifier for the user, corresponds to Supabase auth ID.
  final String id;
  
  /// User's email address.
  String? email;
  
  /// User's full name or display name.
  String? fullName;
  
  /// URL to the user's avatar or profile image.
  String? avatarUrl;
  
  /// Whether the user prefers dark mode in the app UI.
  bool? darkMode;

  /// Creates an instance of AppUser with the required fields.
  ///
  /// Parameters:
  ///   [id] - Required user identifier
  ///   [email] - Required email address
  ///   [fullName] - Optional user's full name
  ///   [avatarUrl] - Optional URL to user's avatar
  ///   [darkMode] - Optional dark mode preference
  AppUser({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.darkMode,
  });

  /// Creates an AppUser from a map of data.
  ///
  /// Typically used when loading user data from the database.
  ///
  /// Parameters:
  ///   [map] - Map containing user data fields
  ///
  /// Returns a new AppUser instance populated with the map data.
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      email: map['email'],
      fullName: map['full_name'] ?? '',
      avatarUrl: map['avatar_url'],
    );
  }

  /// Converts the user to a map representation.
  ///
  /// This is typically used when saving user data to the database.
  ///
  /// Returns a map containing the user's data.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
    };
  }
  
  /// Converts the user to a profile data map for storage.
  ///
  /// This focuses on profile-specific fields rather than core identity.
  ///
  /// Returns a map containing the user's profile data.
  Map<String, dynamic> toProfileData() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'dark_mode': darkMode,
    };
  }

  /// Creates a copy of this AppUser with optional field updates.
  ///
  /// Parameters:
  ///   [id] - Optional new ID
  ///   [email] - Optional new email
  ///   [fullName] - Optional new full name
  ///
  /// Returns a new AppUser with updated fields.
  AppUser copyWith({
    String? id,
    String? email,
    String? fullName,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
    );
  }

  /// Creates an AppUser from a Supabase User object.
  ///
  /// This factory method bridges between Supabase authentication
  /// and the application's user model.
  ///
  /// Parameters:
  ///   [user] - Supabase User instance from authentication
  ///
  /// Returns a new AppUser populated with data from the Supabase User.
  factory AppUser.fromSupabaseUser(User user) {
    return AppUser(
      id: user.id,
      email: user.email,
      fullName: user.userMetadata?['full_name'],
      avatarUrl: user.userMetadata?['avatar_url'],
    );
  }

  /// Converts AppUser to Supabase user metadata format.
  ///
  /// This is used when updating user metadata in Supabase.
  ///
  /// Returns a map containing user metadata in Supabase format.
  Map<String, dynamic> toSupabaseMetadata() {
    return {
      'full_name': fullName,
      'avatar_url': avatarUrl,
    };
  }
}