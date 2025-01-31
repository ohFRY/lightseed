import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lightseed/src/models/affirmation.dart';
import '../services/affirmations_service.dart';

class TodayPageState extends ChangeNotifier {
  final AffirmationsService serviceAffirmations = AffirmationsService();
  List<Affirmation> affirmations = [];
  int currentIndex = 0;
  Affirmation currentAffirmation = Affirmation(content: '', id: 0);
  Timer? _timer;

  TodayPageState() {
    _initializeAffirmations();
    _startPeriodicUpdate();
  }

  Future<void> _initializeAffirmations() async {
    affirmations = await serviceAffirmations.loadAffirmationsFromCache();
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
      final data = await serviceAffirmations.fetchAllAffirmations();
      affirmations = data;
      if (affirmations.isNotEmpty) {
        currentAffirmation = getRandomDailyAffirmation();
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching affirmations: $e');
    }
  }

  var favorites = <Affirmation>[];

  Future<void> toggleFavorite() async {
    if (favorites.contains(currentAffirmation)) {
      favorites.remove(currentAffirmation);
    } else {
      favorites.add(currentAffirmation);
    }
    notifyListeners();
  }

  void removeFavorite(Affirmation text) {
    favorites.remove(text);
    notifyListeners();
  }

  Affirmation getCurrentAffirmation() {
    return currentAffirmation;
  }

  // Get a random affirmation based on the current day
  Affirmation getRandomDailyAffirmation() { 
  final int dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
  final int index = dayOfYear % affirmations.length;

  return affirmations[index];
}

}