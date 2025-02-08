import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ConnectivityService {
  final _connectivity = Connectivity();
  final _connectivityStreamController = StreamController<bool>.broadcast();

  Stream<bool> get connectivityStream => _connectivityStreamController.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityStreamController.add(result != ConnectivityResult.none);
    });
    checkInitialConnectivity();
  }

  Future<void> checkInitialConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _connectivityStreamController.add(result != ConnectivityResult.none);
  }

  void dispose() {
    _connectivityStreamController.close();
  }
}