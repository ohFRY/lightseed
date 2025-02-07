import 'package:flutter/material.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'package:lightseed/src/services/saved_affirmations_service.dart';

class SavedAffirmationsState extends ChangeNotifier {
  final SavedAffirmationsService _service = SavedAffirmationsService();
  List<Affirmation> _favorites = [];
  String? _error;
  
  List<Affirmation> get favorites => _favorites;
  String? get error => _error;

  Future<void> loadFavorites() async {
    try {
      _error = null;
      _favorites = await _service.loadSavedAffirmations();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load favorites: $e';
      notifyListeners();
    }
  }
  
  Future<void> addFavorite(Affirmation affirmation) async {
    try {
      _error = null;
      await _service.saveAffirmation(affirmation);
      await loadFavorites();
    } catch (e) {
      _error = 'Failed to save affirmation: $e';
      notifyListeners();
    }
  }
  
  Future<void> removeFavorite(Affirmation affirmation) async {
    try {
      _error = null;
      await _service.removeSavedAffirmation(affirmation.id);
      await loadFavorites();
    } catch (e) {
      _error = 'Failed to remove affirmation: $e';
      notifyListeners();
    }
  }
}