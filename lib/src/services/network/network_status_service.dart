import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/services/network/connectivity_service.dart';
import 'package:lightseed/src/services/network/supabase_service.dart';
import 'package:lightseed/src/services/timeline_sync_service.dart';
import 'package:lightseed/src/shared/extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

/// A widget that monitors and provides network connectivity status throughout the app.
/// 
/// This stateful widget wraps child widgets and provides them with information about
/// the current network connectivity status. It combines device connectivity status
/// (from ConnectivityService) and server availability (from SupabaseService) to
/// determine if the app is truly online.
/// 
/// When network connectivity is restored, it automatically triggers data synchronization.
/// 
/// Usage:
/// ```dart
/// NetworkStatus(
///   child: MyApp(),
/// )
/// ```
class NetworkStatus extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;
  
  /// Creates a NetworkStatus widget.
  const NetworkStatus({super.key, required this.child});

  /// Finds and returns the NetworkStatusState from the closest NetworkStatus instance
  /// that encloses the given context.
  /// 
  /// Returns null if no NetworkStatus ancestor exists.
  static NetworkStatusState? of(BuildContext context) {
    return context.findAncestorStateOfType<NetworkStatusState>();
  }

  /// Forces an immediate check of the network status.
  /// 
  /// Useful when the user wants to access features that require connectivity.
  /// 
  /// @param context The BuildContext used to find the NetworkStatus instance.
  static Future<void> checkStatus(BuildContext context) async {
    final state = NetworkStatus.of(context);
    if (state != null) {
      await state.checkStatus();
    }
  }

  @override
  NetworkStatusState createState() => NetworkStatusState();
}

/// The state for the NetworkStatus widget.
/// 
/// This class manages the network status monitoring, combining device connectivity
/// and server availability into a unified network status. It also handles
/// triggering synchronization when the network is restored.
class NetworkStatusState extends State<NetworkStatus> with WidgetsBindingObserver {
  /// Service for synchronizing timeline data when connectivity is restored.
  final _timelineSyncService = TimelineSyncService();
  
  /// Service for monitoring device connectivity (WiFi/cellular).
  final _connectivityService = ConnectivityService();
  
  /// Service for checking Supabase server availability.
  final _supabaseService = SupabaseService();
  
  /// Flag to track if the connection was previously offline.
  /// Used to determine when to trigger sync actions.
  bool _wasOffline = true;
  
  /// Current online status - true if both device and server are reachable.
  bool _isOnline = false;
  
  /// Stream that emits network status updates.
  late Stream<bool> _networkStatusStream;
  
  /// Current online status.
  bool get isOnline => _isOnline;
  
  /// Stream of network status updates.
  Stream<bool> get networkStatusStream => _networkStatusStream;
  
  /// Controller for manual network status checks.
  final StreamController<bool> _manualUpdateController = StreamController<bool>.broadcast();

  @override
  void initState() {
    debugPrint('🔄 NetworkStatus: initState called');
    super.initState();
    _setupStreams();
    _performInitialCheck();
  }

  /// Performs an initial check of server health without blocking the UI.
  /// 
  /// This provides an early indication of connectivity before the streams
  /// are fully established.
  Future<void> _performInitialCheck() async {
    // Don't block the UI
    unawaited(Future(() async {
      if (!mounted) return;
      final serverHealth = await context.checkServerHealth();
      debugPrint('🔄 Initial server health check: $serverHealth');
      if (mounted) {
        setState(() {
          // Only update if we're actually offline
          _isOnline = _isOnline || serverHealth;
        });
      }
    }));
  }

  /// Sets up the reactive streams that monitor network connectivity.
  /// 
  /// Combines device connectivity status and server availability into a single
  /// network status stream. Also updates the NetworkStatusProvider singleton
  /// and triggers sync when connectivity is restored.
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
        
        // Update the provider for non-widget access
        NetworkStatusProvider.instance.updateStatus(status);
        
        // Only trigger sync if we're truly coming back online from being offline
        if (status && _wasOffline) {
          // Use a small delay to avoid race conditions with app initialization
          Future.delayed(Duration(milliseconds: 500), () {
            _triggerSync();
          });
        }
        
        _wasOffline = !status;
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

  /// Triggers data synchronization when network connectivity is restored.
  /// 
  /// This ensures that any offline changes are synchronized with the server
  /// as soon as connectivity becomes available.
  Future<void> _triggerSync() async {
    final userId = AuthLogic.getValidUserId();
    if (userId != null) {
      debugPrint('🔄 Network restored - starting sync');
      await _timelineSyncService.syncItems(userId);
    }
  }

  /// Performs a manual check of server health.
  /// 
  /// This can be called by other parts of the app to force a connectivity check.
  /// Results are emitted through the _manualUpdateController stream.
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

/// A singleton provider for accessing network status outside of the widget tree.
/// 
/// This class provides a way for services and other non-UI components to
/// check if the app currently has network connectivity, without needing a BuildContext.
/// It also implements proper stream management to handle lifecycle events such as
/// sign-out and sign-in cycles.
/// 
/// The class features automatic stream recreation when needed, proper disposal
/// handling, and error protection to prevent common stream-related crashes.
/// 
/// Usage example:
/// ```dart
/// if (NetworkStatusProvider.instance.isOnline) {
///   // Perform network operation
/// }
/// 
/// // Or listen for changes:
/// NetworkStatusProvider.instance.networkStatusStream.listen((isOnline) {
///   if (isOnline) {
///     // Network restored, update UI or start sync
///   } else {
///     // Network lost, show offline indicator
///   }
/// });
/// ```
class NetworkStatusProvider {
  /// Singleton instance
  static final NetworkStatusProvider _instance = NetworkStatusProvider._internal();
  
  /// Access to the singleton instance
  static NetworkStatusProvider get instance => _instance;
  
  /// Private constructor
  NetworkStatusProvider._internal();
  
  /// Current online status
  bool _isOnline = false;
  
  /// Tracks if this provider has been disposed
  /// Used to prevent operations on a disposed instance
  bool _isDisposed = false;
  
  /// Stream controller for network status updates
  /// Can be recreated if closed (e.g., after sign-out)
  StreamController<bool>? _networkStatusController = StreamController<bool>.broadcast();
  
  /// Whether the app currently has network connectivity
  bool get isOnline => _isOnline;
  
  /// Stream of network status updates
  /// 
  /// This stream automatically recreates itself if it was previously closed,
  /// making it resilient against sign-out/sign-in cycles and other lifecycle events.
  /// Listeners can safely subscribe to this stream at any point in the app lifecycle.
  Stream<bool> get networkStatusStream {
    // Recreate controller if needed
    if (_networkStatusController == null || _networkStatusController!.isClosed) {
      _networkStatusController = StreamController<bool>.broadcast();
    }
    return _networkStatusController!.stream;
  }
  
  /// Updates the current network status
  /// 
  /// This method is called by NetworkStatusState when the combined device and
  /// server connectivity status changes. It updates the internal status and
  /// safely emits the new status through the stream if possible.
  /// 
  /// @param status The new network connectivity status
  void updateStatus(bool status) {
    _isOnline = status;
    
    // Only push to stream if not disposed and not closed
    if (!_isDisposed && _networkStatusController != null && !_networkStatusController!.isClosed) {
      try {
        _networkStatusController!.add(status);
      } catch (e) {
        debugPrint('Error updating network status: $e');
      }
    }
  }
  
  /// Resets the stream controller after sign-out
  /// 
  /// This method ensures that stream resources are properly managed during
  /// authentication state changes. It should be called as part of the sign-out
  /// process to prevent stream closure errors when the user signs back in.
  /// 
  /// It closes any existing controller and creates a fresh one, effectively
  /// clearing any previous subscriptions and preventing "stream closed" errors.
  void resetAfterSignOut() {
    // Close existing controller if open
    if (_networkStatusController != null && !_networkStatusController!.isClosed) {
      _networkStatusController!.close();
    }
    
    // Create a fresh controller
    _networkStatusController = StreamController<bool>.broadcast();
    _isDisposed = false;
  }
  
  /// Releases resources used by this provider
  /// 
  /// This method should be called when the application is terminating or when
  /// this provider is no longer needed. It prevents memory leaks by marking
  /// the instance as disposed and closing the stream controller.
  void dispose() {
    _isDisposed = true;
    if (_networkStatusController != null && !_networkStatusController!.isClosed) {
      _networkStatusController!.close();
    }
  }
}