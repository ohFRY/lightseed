import 'package:flutter/material.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'today_page_state.dart';

class SavedAffirmationsState extends ChangeNotifier {
  final TodayPageState appState;
  bool isNavigationRailVisible = true;

  SavedAffirmationsState(this.appState);

  List<Affirmation> get favorites => appState.favorites;

  void removeFavorite(Affirmation fav) {
    appState.removeFavorite(fav);
    notifyListeners();
  }

  void clearFavorites() {
    appState.favorites.clear();
    notifyListeners();
  }

}