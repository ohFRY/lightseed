import 'package:flutter/material.dart';
import 'package:lightseed/src/services/network/connectivity_service.dart';
import 'package:lightseed/src/services/network/supabase_service.dart';
import 'package:rxdart/rxdart.dart';

class NetworkStatus extends StatefulWidget {
  final Widget child;
  const NetworkStatus({super.key, required this.child}); // Use super parameters

  static NetworkStatusState? of(BuildContext context) {
    return context.findAncestorStateOfType<NetworkStatusState>();
  }

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
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _currentSnackBar;

  bool get isSnackBarVisible => _isSnackBarVisible;

  Stream<bool> get networkStatusStream => _networkStatusStream;

  @override
  void initState() {
    super.initState();
    
    // Debounce connectivity changes
    _connectivityStream = _connectivityService.connectivityStream
        .debounceTime(const Duration(milliseconds: 300))
        .distinct()
        .asBroadcastStream();

    // Debounce Supabase connection changes and add stability delay
    _supabaseStream = _supabaseService.supabaseStream
        .debounceTime(const Duration(seconds: 2))
        .distinct()
        .asBroadcastStream();

    _networkStatusStream = Rx.combineLatest2(
      _connectivityStream,
      _supabaseStream,
      (isConnected, isSupabaseConnected) {
        print('DEBUG: Combined network status: connected=$isConnected, supabase=$isSupabaseConnected');
        return isConnected && isSupabaseConnected;
      },
    )
    .distinct()
    .debounceTime(const Duration(milliseconds: 500))
    .asBroadcastStream();

    // Use async handler for better state management
    _networkStatusStream.listen(_handleNetworkStatusChange);
  }

  Future<void> _handleNetworkStatusChange(bool isOnline) async {
    if (!mounted) return;

    // Ensure we're on the right frame
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    
    try {
      if (!isOnline) {
        if (!_isSnackBarVisible) {
          print('DEBUG: Showing network status snackbar');
          // Clear any existing snackbar first
          messenger.clearSnackBars();
          await Future.delayed(const Duration(milliseconds: 300));
          
          if (!mounted) return;
          
          _currentSnackBar = messenger.showSnackBar(
            const SnackBar(
              content: Text('Cannot connect to server'),
              duration: Duration(days: 365),
              dismissDirection: DismissDirection.none,
            ),
          );
          _isSnackBarVisible = true;

          // Listen for snackbar closure
          _currentSnackBar?.closed.then((_) {
            if (mounted) {
              _isSnackBarVisible = false;
              _currentSnackBar = null;
            }
          });
        }
      } else if (_isSnackBarVisible) {
        print('DEBUG: Hiding network status snackbar');
        // Clear all snackbars to ensure proper cleanup
        messenger.clearSnackBars();
        _currentSnackBar = null;
        _isSnackBarVisible = false;
      }
    } catch (e) {
      print('DEBUG: Error handling network status change: $e');
      // Reset state on error
      _isSnackBarVisible = false;
      _currentSnackBar = null;
    }
  }

  @override
  void dispose() {
    // Remove ScaffoldMessenger access from dispose
    _connectivityService.dispose();
    _supabaseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}