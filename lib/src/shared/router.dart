import 'package:flutter/material.dart';

class AppRoutes {
  static const home = '/';
  static const favorites = '/favorites';

  static final List<NavigationDestination> destinations = [
    NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
  ];
}