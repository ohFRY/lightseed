import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class AccountState with ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  void setUser(AppUser user) {
    _user = user;
    notifyListeners();
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

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}