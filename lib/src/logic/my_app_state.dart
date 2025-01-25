import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lightseed/src/models/affirmation.dart';
import '../services/affirmations_service.dart';

class MyAppState extends ChangeNotifier {
  final AffirmationsService serviceAffirmations = AffirmationsService();
  List<Affirmation> affirmations = [];
  int currentIndex = 0;
  Affirmation currentAffirmation = Affirmation(content: '', id: 0);
  Timer? _timer;

  MyAppState() {
    _initializeAffirmations();
    _startPeriodicUpdate();
  }

  Future<void> _initializeAffirmations() async {
    affirmations = await serviceAffirmations.loadAffirmationsFromCache();
    if (affirmations.isEmpty) {
      await fetchAllAffirmations();
    } else {
      currentAffirmation = affirmations[currentIndex];
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
        currentAffirmation = affirmations[currentIndex];
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching affirmations: $e');
    }
  }

  void getNext() {
    if (affirmations.isNotEmpty) {
      currentIndex = (currentIndex + 1) % affirmations.length;
      currentAffirmation = affirmations[currentIndex];
      notifyListeners();
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
}