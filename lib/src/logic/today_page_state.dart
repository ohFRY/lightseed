import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:lightseed/src/services/affirmations_service.dart';
import 'package:lightseed/src/services/network/connectivity_service.dart';

class TodayPageState extends ChangeNotifier {
  final AffirmationsService _affirmationsService = AffirmationsService();
  final ConnectivityService _connectivityService = ConnectivityService();
  List<Affirmation> affirmations = [];
  Affirmation currentAffirmation = Affirmation(content: '', id: 0);
  Timer? _timer;
  bool _hasError = false;

  bool get hasError => _hasError;

  TodayPageState() {
    _initializeAffirmations();
    _startPeriodicUpdate();
    _listenForConnectivityChanges();
  }

  Future<void> _initializeAffirmations() async {
    try {
      affirmations = await _affirmationsService.loadAffirmationsFromCache();
      if (affirmations.isEmpty) {
        await fetchAllAffirmations();
      } else {
        currentAffirmation = getRandomDailyAffirmation();
        notifyListeners();
      }
      _hasError = false;
    } catch (e) {
      print('Error initializing affirmations: $e');
      _hasError = true;
      notifyListeners();
    }
  }

  void _startPeriodicUpdate() {
    _timer = Timer.periodic(Duration(days: 1), (timer) async {
      await fetchAllAffirmations();
    });
  }

  void _listenForConnectivityChanges() {
    _connectivityService.connectivityStream.listen((isConnected) {
      if (isConnected) {
        _initializeAffirmations();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchAllAffirmations() async {
    try {
      final data = await _affirmationsService.fetchAllAffirmationsFromDB();
      affirmations = data;
      if (affirmations.isNotEmpty) {
        currentAffirmation = getRandomDailyAffirmation();
      }
      _hasError = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching affirmations: $e');
      _hasError = true;
      notifyListeners();
    }
  }

  Affirmation getRandomDailyAffirmation() {
    final int dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
    final int index = dayOfYear % affirmations.length;
    return affirmations[index];
  }
}