import 'package:flutter/material.dart';
import 'package:lightseed/src/services/network/connectivity_service.dart';
import 'package:lightseed/src/services/network/supabase_service.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

class NetworkStatus extends StatefulWidget {
  final Widget child;
  const NetworkStatus({super.key, required this.child}); // Use super parameters

  static NetworkStatusState? of(BuildContext context) {
    return context.findAncestorStateOfType<NetworkStatusState>();
  }

  @override
  NetworkStatusState createState() => NetworkStatusState();
}

class NetworkStatusState extends State<NetworkStatus> with WidgetsBindingObserver {
  final _connectivityService = ConnectivityService();
  final _supabaseService = SupabaseService();
  late Stream<bool> _networkStatusStream;
  bool _isOnline = true;
  bool get isOnline => _isOnline;
  Stream<bool> get networkStatusStream => _networkStatusStream;

  @override
  void initState() {
    debugPrint('🔄 NetworkStatus: initState called');
    super.initState();
    _setupStreams();
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
            debugPrint('🔄 NetworkStatus state updated to: $_isOnline');
          });
        }
        return status;
      },
    ).asBroadcastStream();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivityService.dispose();
    _supabaseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 NetworkStatus: build called, isOnline: $_isOnline');
    return widget.child;
  }
}