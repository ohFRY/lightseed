import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class SupabaseService {
  final _supabaseStreamController = StreamController<bool>.broadcast();
  Stream<bool> get supabaseStream => _supabaseStreamController.stream;

  SupabaseService() {
    checkSupabaseConnection();
    startSupabaseCheckTimer();
  }

  Timer? _supabaseCheckTimer;

  Future<void> checkSupabaseConnection() async {
    try {
      // Attempt a simple Supabase operation
      await Supabase.instance.client.from('profiles').select().limit(1).select();
      _supabaseStreamController.add(true); // Supabase is available
      print("DEBUG: Supabase is available${DateTime.now()}");
    } catch (e) {
      print("Supabase connection error: $e");
      _supabaseStreamController.add(false); // Supabase is unavailable
    }
  }

  void startSupabaseCheckTimer() {
    _supabaseCheckTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkSupabaseConnection(); // Check Supabase connection periodically
    });
  }

  void dispose() {
    _supabaseCheckTimer?.cancel();
    _supabaseStreamController.close();
  }
}