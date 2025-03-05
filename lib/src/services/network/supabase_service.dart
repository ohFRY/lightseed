import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final _supabaseStreamController = StreamController<bool>.broadcast();
  RealtimeChannel? _statusChannel;
  bool _wasConnected = false;


  Stream<bool> get supabaseStream => _supabaseStreamController.stream;

  SupabaseService() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      debugPrint('🔌 Initializing Supabase service...');
      await _initializeWebSocket();
      await _checkInitialConnection();
      SystemChannels.lifecycle.setMessageHandler(_handleAppLifecycle);
    } catch (e) {
      debugPrint('❌ Error initializing Supabase service: $e');
      _handleConnectionChange(false);
    }
  }

Future<void> _initializeWebSocket() async {
  debugPrint('🔌 Initializing WebSocket...');
  try {
    _statusChannel = Supabase.instance.client.realtime
        .channel('status')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          callback: (payload) {
            debugPrint('🔌 Received Postgres change');
            _handleConnectionChange(true);
          },
        );

    if (_statusChannel != null) {
      _statusChannel!.subscribe();
      
      // Check actual connection status
      final isConnected = await _checkInitialConnection();
      debugPrint('🔌 Initial connection check: $isConnected');
      _handleConnectionChange(isConnected);
    }

  } catch (e) {
    debugPrint('❌ WebSocket initialization failed: $e');
    _handleConnectionChange(false);
  }
}

  Future<bool> _checkInitialConnection() async {
    debugPrint('🔍 Checking initial connection...');
    try {
      // Use a longer timeout to accommodate network latency
      await Supabase.instance.client
          .from('health_checks')
          .select()
          .limit(1)
          .maybeSingle()
          .timeout(const Duration(seconds: 8)); // Increased from 5 seconds
      
      debugPrint('✅ Connection check successful');
      return true;
    } catch (e) {
      // Only consider it a failure if it's a timeout or network error
      if (e is TimeoutException || 
          e.toString().contains('network') || 
          e.toString().contains('connection')) {
        debugPrint('❌ Connection check failed: $e');
        return false;
      }
      
      // For other errors (like authentication), we still reached the server
      debugPrint('⚠️ Connection check returned error but network is up: $e');
      return true;
    }
  }

  void _handleConnectionChange(bool isConnected) {
    debugPrint('🔌 Supabase handling connection change: $isConnected');
    if (isConnected != _wasConnected) {
      _wasConnected = isConnected;
      debugPrint('🔄 Supabase pushing connection status: $isConnected');
      _supabaseStreamController.add(isConnected);
    }
  }

  Future<String?> _handleAppLifecycle(String? state) async {
    if (state == AppLifecycleState.resumed.toString()) {
      await _initializeWebSocket();
    }
    return state;
  }

  void dispose() {
    _statusChannel?.unsubscribe();
    _supabaseStreamController.close();
  }
}