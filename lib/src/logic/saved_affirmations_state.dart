import 'package:flutter/material.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:lightseed/src/services/saved_affirmations_service.dart';

class SavedAffirmationsState extends ChangeNotifier {
  
  //bool isNavigationRailVisible = true; //not sure why I have this here, commenting for now

  final SavedAffirmationsService _service = SavedAffirmationsService();
  List<Affirmation> _favorites = [];
  
  List<Affirmation> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = await _service.loadSavedAffirmations();
    notifyListeners();
  }
  
  Future<void> addFavorite(Affirmation affirmation) async {
    await _service.saveAffirmation(affirmation);
    await loadFavorites(); // Reload to get updated list with timestamps
  }
  
  // Remove the saved affirmation from the list
  Future<void> removeFavorite(Affirmation affirmation) async {
    _favorites.remove(affirmation);
    notifyListeners();
  }

}