import 'package:flutter/material.dart';
import 'my_app_state.dart';

class MyFavouritesPageState extends ChangeNotifier {
  final MyAppState appState;
  bool isNavigationRailVisible = true;

  MyFavouritesPageState(this.appState);

  List<String> get favorites => appState.favorites;

  void removeFavorite(String fav) {
    appState.removeFavorite(fav);
    notifyListeners();
  }

  void clearFavorites() {
    appState.favorites.clear();
    notifyListeners();
  }

}