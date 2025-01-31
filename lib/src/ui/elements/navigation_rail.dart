import 'package:flutter/material.dart';
import '../../shared/router.dart';

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
        extended: extended,
        groupAlignment: 0.0,
        // Display labels under icons on tablets, hide on desktop (otherwise exception is raised)
        labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all, 
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