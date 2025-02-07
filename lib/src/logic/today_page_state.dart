import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:lightseed/src/services/affirmations_service.dart';  // Changed import

class TodayPageState extends ChangeNotifier {
  final AffirmationsService _affirmationsService = AffirmationsService();  // Changed service
  List<Affirmation> affirmations = [];
  Affirmation currentAffirmation = Affirmation(content: '', id: 0);
  Timer? _timer;

  TodayPageState() {
    _initializeAffirmations();
    _startPeriodicUpdate();
  }

  Future<void> _initializeAffirmations() async {
    affirmations = await _affirmationsService.loadAffirmationsFromCache();  // Changed service reference
    if (affirmations.isEmpty) {
      await fetchAllAffirmations();
    } else {
      currentAffirmation = getRandomDailyAffirmation();
      notifyListeners();
    }
  }

  void _startPeriodicUpdate() {
    _timer = Timer.periodic(Duration(days: 1), (timer) async {
      await fetchAllAffirmations();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchAllAffirmations() async {
    try {
      final data = await _affirmationsService.fetchAllAffirmations();  // Changed service reference
      affirmations = data;
      if (affirmations.isNotEmpty) {
        currentAffirmation = getRandomDailyAffirmation();
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching affirmations: $e');
    }
  }

  Affirmation getRandomDailyAffirmation() { 
    final int dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
    final int index = dayOfYear % affirmations.length;
    return affirmations[index];
  }
}