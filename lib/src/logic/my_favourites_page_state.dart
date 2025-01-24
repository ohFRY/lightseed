import 'package:flutter/material.dart';
import 'package:lightseed/src/models/affirmation.dart';
import 'my_app_state.dart';

class MyFavouritesPageState extends ChangeNotifier {
  final MyAppState appState;
  bool isNavigationRailVisible = true;

  MyFavouritesPageState(this.appState);

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