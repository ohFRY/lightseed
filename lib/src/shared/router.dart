import 'package:flutter/material.dart';

class AppRoutes {
  static const home = '/';
  static const favorites = '/favorites';

  static final List<NavigationDestination> destinations = [

    NavigationDestination(
      icon: Icon(Icons.history),
      label: 'Past',
    ),
    NavigationDestination(
      icon: Icon(Icons.today),
      label: 'Today',
    ),
    NavigationDestination(
      icon: Icon(Icons.trending_up),
      label: 'Future',
    ),
  ];
}