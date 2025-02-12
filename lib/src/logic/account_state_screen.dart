import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class AccountState extends ChangeNotifier {
  AppUser? _user;
  bool _isInitialized = false;

  AppUser? get user => _user;

  void setUser(AppUser user) {
    _user = user;
    notifyListeners();
  }

  void updateUserName(String name) {
    if (user != null) {
      _user = user!.copyWith(fullName: name);
      notifyListeners();
    }
  }

  void setUserFromSupabase(User user) {
    _user = AppUser.fromSupabaseUser(user);
    notifyListeners();
  }

  Future<void> saveUserData() async {
    if (_user != null) {
      await AuthLogic.saveUserData(_user!);
    }
  }

  Future<void> signOut(BuildContext context) async {
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
        debugPrint('🔄 AccountState: Fetch failed - keeping existing user data');
        // Don't update user if fetch fails - keep existing data
      }
      _isInitialized = true;
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}