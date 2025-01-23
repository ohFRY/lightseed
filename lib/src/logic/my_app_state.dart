import 'package:flutter/material.dart';
import '../services/affirmations_service.dart';

class MyAppState extends ChangeNotifier {
  final AffirmationsService serviceAffirmations = AffirmationsService();
  List<String> affirmations = [];
  int currentIndex = 0;
  String currentAffirmation = "";

  MyAppState() {
    fetchAllAffirmations();
  }

  Future<void> fetchAllAffirmations() async {
    try {
      final data = await serviceAffirmations.fetchAllAffirmations();
      affirmations = data.map((item) => item['content'] as String).toList();
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

  var favorites = <String>[];

  Future<void> toggleFavorite() async {
    if (favorites.contains(currentAffirmation)) {
      favorites.remove(currentAffirmation);
    } else {
      favorites.add(currentAffirmation);
    }
    notifyListeners();
  }

  void removeFavorite(String text) {
    favorites.remove(text);
    notifyListeners();
  }

  String getCurrentAffirmation() {
    return currentAffirmation;
  }
}