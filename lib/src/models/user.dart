import 'package:supabase_flutter/supabase_flutter.dart';

class AppUser {
  final String id;
  String? email;
  String? fullName;
  String? avatarUrl;
  bool? darkMode; // Custom field

  AppUser({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.darkMode,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      email: map['email'],
      fullName: map['full_name'] ?? '',
      avatarUrl: map['avatar_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
    };
  }
  
  Map<String, dynamic> toProfileData() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'dark_mode': darkMode,
    };
  }

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

  // Convert Supabase User to AppUser
  factory AppUser.fromSupabaseUser(User user) {
    return AppUser(
      id: user.id,
      email: user.email,
      fullName: user.userMetadata?['full_name'],
      avatarUrl: user.userMetadata?['avatar_url'],
    );
  }

  // Convert AppUser to Supabase User metadata
  Map<String, dynamic> toSupabaseMetadata() {
    return {
      'full_name': fullName,
      'avatar_url': avatarUrl,
    };
  }
}