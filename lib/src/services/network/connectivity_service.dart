import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

/// A service that monitors device network connectivity status.
///
/// This class provides a stream of boolean values representing the device's
/// connectivity state (online or offline). It uses the connectivity_plus package
/// to detect network state changes and broadcasts these updates to listeners.
///
/// The service handles its own lifecycle with proper resource management
/// to prevent memory leaks and stream-related errors.
class ConnectivityService {
  /// The underlying connectivity plugin instance
  final _connectivity = Connectivity();
  
  /// Stream controller that broadcasts connectivity status (true = online, false = offline)
  final _connectivityStreamController = StreamController<bool>.broadcast();
  
  /// Subscription to the connectivity plugin's change events
  StreamSubscription? _connectivitySubscription;
  
  /// Flag to track if this service has been disposed
  bool _isDisposed = false;

  /// Stream of connectivity status updates.
  ///
  /// This stream emits boolean values:
  /// - `true` when the device has any form of network connectivity
  /// - `false` when the device has no network connectivity
  ///
  /// Example:
  /// ```dart
  /// connectivityService.connectivityStream.listen((isOnline) {
  ///   if (isOnline) {
  ///     print('Device is online');
  ///   } else {
  ///     print('Device is offline');
  ///   }
  /// });
  /// ```
  Stream<bool> get connectivityStream => _connectivityStreamController.stream;

  /// Creates a new ConnectivityService and begins monitoring network status.
  ///
  /// Upon creation, the service immediately:
  /// 1. Sets up a listener for connectivity change events
  /// 2. Performs an initial connectivity check
  ///
  /// The initial connectivity status will be emitted through the [connectivityStream].
  ConnectivityService() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (!_isDisposed) {
        _connectivityStreamController.add(result != ConnectivityResult.none);
      }
    });
    checkInitialConnectivity();
  }

  /// Performs an initial check of the device's connectivity status.
  ///
  /// This method determines the current connectivity state and emits
  /// it through the [connectivityStream]. It's called automatically by
  /// the constructor to provide an immediate connectivity status.
  ///
  /// If an error occurs during the check, it will be caught and logged,
  /// preventing app crashes when connectivity services are unavailable.
  Future<void> checkInitialConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (!_isDisposed) {
        _connectivityStreamController.add(result != ConnectivityResult.none);
      }
    } catch (e) {
      print('Error checking initial connectivity: $e');
    }
  }

  /// Releases resources used by this service.
  ///
  /// This method:
  /// 1. Cancels the connectivity change subscription
  /// 2. Closes the connectivity stream controller
  /// 3. Marks the service as disposed
  ///
  /// Always call this method when the service is no longer needed
  /// to prevent memory leaks and stream-related errors.
  void dispose() {
    _isDisposed = true;
    _connectivitySubscription?.cancel();
    if (!_connectivityStreamController.isClosed) {
      _connectivityStreamController.close();
    }
  }
}