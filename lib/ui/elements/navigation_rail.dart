import 'package:flutter/material.dart';
import '../../router.dart';

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;

  const CustomNavigationRail({
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.extended = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NavigationRail(
        backgroundColor: Colors.white,
        extended: extended,
        destinations: AppRoutes.destinations.map((destination) {
          return NavigationRailDestination(
            icon: destination.icon,
            label: Text(destination.label),
          );
        }).toList(),
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}