import 'package:flutter/material.dart';
import 'package:lightseed/src/services/network/connectivity_service.dart';
import 'package:lightseed/src/services/network/supabase_service.dart';
import 'package:lightseed/src/shared/extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class NetworkStatus extends StatefulWidget {
  final Widget child;
  const NetworkStatus({super.key, required this.child}); // Use super parameters

  static NetworkStatusState? of(BuildContext context) {
    return context.findAncestorStateOfType<NetworkStatusState>();
  }

  // to use when we want to force the network status check
  // e.g. when the user wants to access to a screen that requires a connection with the server
  static Future<void> checkStatus(BuildContext context) async {
    final state = NetworkStatus.of(context);
    if (state != null) {
      await state.checkStatus();
    }
  }

  @override
  NetworkStatusState createState() => NetworkStatusState();
}

class NetworkStatusState extends State<NetworkStatus> with WidgetsBindingObserver {
  final _connectivityService = ConnectivityService();
  final _supabaseService = SupabaseService();
  late Stream<bool> _networkStatusStream;
  bool _isOnline = false;  // Start pessimistically
  bool get isOnline => _isOnline;
  Stream<bool> get networkStatusStream => _networkStatusStream;  // Add this getter
  final StreamController<bool> _manualUpdateController = StreamController<bool>.broadcast();

  @override
  void initState() {
    debugPrint('🔄 NetworkStatus: initState called');
    super.initState();
    _setupStreams();
    _performInitialCheck();
  }

  Future<void> _performInitialCheck() async {
    // Don't block the UI
    unawaited(Future(() async {
      if (!mounted) return;
      final serverHealth = await context.checkServerHealth();
      debugPrint('🔄 Initial server health check: $serverHealth');
        setState(() {
          _isOnline = serverHealth;
        });
    }));
  }

  void _setupStreams() {
    debugPrint('🔄 NetworkStatus: setting up streams');
    
    final connectivityStream = _connectivityService.connectivityStream
        .distinct()
        .asBroadcastStream();
    
    final supabaseStream = _supabaseService.supabaseStream
        .distinct()
        .asBroadcastStream();

    _networkStatusStream = Rx.combineLatest2(
      connectivityStream,
      supabaseStream,
      (bool deviceOnline, bool serverOnline) {
        final status = deviceOnline && serverOnline;
        debugPrint('🔄 Network status update - Device: $deviceOnline, Server: $serverOnline, Combined: $status');
        if (mounted) {
          setState(() {
            _isOnline = status;
          });
        }
        return status;
      },
    ).asBroadcastStream();

    // Listen to the stream to ensure it's active
    _networkStatusStream.listen((status) {
      debugPrint('🔄 Network status stream event: $status');
    });
  }

  Future<void> checkStatus() async {
    // Don't block navigation
    unawaited(Future(() async {
      if (!mounted) return;
      final status = await context.checkServerHealth();
      _manualUpdateController.add(status);
    }));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivityService.dispose();
    _supabaseService.dispose();
    _manualUpdateController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 NetworkStatus: build called, isOnline: $_isOnline');
    return widget.child;
  }
}