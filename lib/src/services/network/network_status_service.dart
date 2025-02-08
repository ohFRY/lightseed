import 'package:flutter/material.dart';
import 'package:lightseed/src/services/network/connectivity_service.dart';
import 'package:lightseed/src/services/network/supabase_service.dart';
import 'package:lightseed/src/ui/elements/snackbar.dart';
import 'package:rxdart/rxdart.dart';

class NetworkStatus extends StatefulWidget {
  final Widget child;
  const NetworkStatus({super.key, required this.child}); // Use super parameters

  @override
  NetworkStatusState createState() => NetworkStatusState();
}

class NetworkStatusState extends State<NetworkStatus> {
  final _connectivityService = ConnectivityService();
  final _supabaseService = SupabaseService();
  late Stream<bool> _connectivityStream;
  late Stream<bool> _supabaseStream;
  late Stream<bool> _networkStatusStream;
  bool _isSnackBarVisible = false;

  bool get isSnackBarVisible => _isSnackBarVisible;

  @override
  void initState() {
    super.initState();
    _connectivityStream = _connectivityService.connectivityStream.asBroadcastStream();
    _supabaseStream = _supabaseService.supabaseStream.asBroadcastStream();
    _networkStatusStream = Rx.combineLatest2(
      _connectivityStream,
      _supabaseStream,
      (a, b) => a && b,
    ).asBroadcastStream();
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    _supabaseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _networkStatusStream,
      builder: (context, isOnlineSnapshot) {
        final isOnline = isOnlineSnapshot.data ?? true;
        if (isOnline) {
          // Hide the SnackBar when online using a post-frame callback
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            _isSnackBarVisible = false;
          });
          return widget.child;
        }

        return StreamBuilder<bool>(
          stream: _connectivityStream,
          builder: (context, connectivitySnapshot) {
            final isConnected = connectivitySnapshot.data ?? true;
            String message;
            if (!isConnected) {
              message = 'No internet connection';
            } else {
              message = 'Cannot connect to server';
            }

            // Use a post-frame callback to show the SnackBar
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.showSnackBar(
                message,
                isError: true,
                persistent: true,
              );
              _isSnackBarVisible = true;
            });
            return widget.child;
          },
        );
      },
    );
  }
}