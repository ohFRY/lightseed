import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class AccountState extends ChangeNotifier {
  AppUser? _user;
  bool _isInitialized = false;
  static const String _userNameKey = 'user_name';
  static const String _userIdKey = 'user_id';

  AppUser? get user => _user;

  void setUser(AppUser user) {
    _user = user;
    notifyListeners();
  }

  void updateUserName(String name, {TextEditingController? controller}) {
    if (user != null) {
      // Store the current cursor position
      final selection = controller?.selection;
      
      _user = user!.copyWith(fullName: name);
      
      // Restore the cursor position after the update
      if (controller != null) {
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: selection?.baseOffset ?? name.length),
        );
      }
      
      notifyListeners();
    }
  }

  // Add methods for cache management
  Future<void> _cacheUserData(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, user.fullName ?? '');
    await prefs.setString(_userIdKey, user.id);
  }

  Future<AppUser?> _loadCachedUser(String expectedUserId) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedId = prefs.getString(_userIdKey);
    
    // Only return cached data if it matches current user
    if (cachedId == expectedUserId) {
      final cachedName = prefs.getString(_userNameKey) ?? ''; // Provide default empty string
      return AppUser(
        id: cachedId!,  // We know it's not null because of the if check
        email: '',      // Required field, use empty string as default
        fullName: cachedName,
      );
    }
    return null;
  }

  // Update existing methods to use cache
  void setUserFromSupabase(User user) {
    _user = AppUser.fromSupabaseUser(user);
    _cacheUserData(_user!); // Cache when setting new user
    notifyListeners();
  }

  Future<void> saveUserData() async {
    if (_user != null) {
      await AuthLogic.saveUserData(_user!);
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _clearCache();  // Clear cache before signing out
    await AuthLogic.signOut();
  }

  Future<void> fetchUser() async {
    if (!_isInitialized) {
      try {
        final supabase = Supabase.instance.client;
        final user = supabase.auth.currentUser;
        if (user != null) {
          setUserFromSupabase(user);
        }
      } catch (e) {
        debugPrint('🔄 AccountState: Fetch failed - trying cached data');
        final currentUser = Supabase.instance.client.auth.currentUser;
        if (currentUser != null) {
          _user = await _loadCachedUser(currentUser.id);
          if (_user != null) {
            notifyListeners();
          }
        }
      }
      _isInitialized = true;
    }
  }

  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
    await prefs.remove(_userIdKey);
  }

  // Update clear method to also clear cache
  Future<void> clearUser() async {
    await _clearCache();
    _user = null;
    notifyListeners();
  }
}