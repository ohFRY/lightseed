import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:provider/provider.dart';
import '../../logic/timeline_state.dart';
import '../../models/timeline_item.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final isOnline = NetworkStatus.of(context)?.isOnline ?? false;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
      ),
      body: Consumer<TimelineState>(
        builder: (context, timelineState, child) {
          if (timelineState.items.isEmpty) {
            return const Center(child: Text('Your timeline is empty.'));
          }

          // Sort items by date (newest first)
          final sortedItems = List<TimelineItem>.from(timelineState.items)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          // Group items by date
          final Map<String, List<TimelineItem>> groupedItems = {};
          
          for (var item in sortedItems) {
              final localDate = item.createdAt.toLocal();
              final dateString = DateFormat('yyyy-MM-dd').format(localDate);
            
            if (!groupedItems.containsKey(dateString)) {
              groupedItems[dateString] = [];
            }
            groupedItems[dateString]!.add(item);
          }

          // Create a list of widgets for each date group
          final List<Widget> groupWidgets = [];
          
          groupedItems.forEach((date, items) {
            // Parse the date string back to DateTime for formatting
            final dateTime = DateFormat('yyyy-MM-dd').parse(date);
            
            // Add the date header with formatted date
            groupWidgets.add(
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      alignment: Alignment.center,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _formatDateForGrouping(dateTime), // Use the helper method
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            
            // Add all items for this date
            for (var item in items) {
              final itemColor = _getColorForItemType(context, item.type);
              
              groupWidgets.add(
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline line and dot
                    SizedBox(
                      width: 60,
                      child: Column(
                        children: [
                          Container(
                            width: 2,
                            height: 30,
                            color: colorScheme.outlineVariant,
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: itemColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.surface,
                                width: 2,
                              ),
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 40,
                            color: colorScheme.outlineVariant,
                          ),
                        ],
                      ),
                    ),
                    // Content
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                        elevation: 0, 
                        color: colorScheme.surfaceContainerLow,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.content,
                                style: item.type == TimelineItemType.affirmation
                                    ? Theme.of(context).textTheme.titleMedium
                                    : Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatItemType(item.type),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: itemColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('h:mm a').format(item.createdAt.toLocal()),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          });

          return ListView(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            children: groupWidgets
          );
        },
      ),
    );
  }
  
  // Helper method to get color based on item type
  Color _getColorForItemType(BuildContext context, TimelineItemType type) {
    final colorScheme = Theme.of(context).colorScheme;
    
    switch (type) {
      case TimelineItemType.emotion_log:
        return colorScheme.primary;
      case TimelineItemType.journal_entry:
        return colorScheme.secondary;
      //case TimelineItemType.gratitude_entry:
      //  return colorScheme.tertiary;
      default:
        return colorScheme.outline;
    }
  }

  String _formatDateForGrouping(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly.year == today.year && dateOnly.month == today.month && dateOnly.day == today.day) {
      return 'Today';
    } else if (dateOnly.year == yesterday.year && dateOnly.month == yesterday.month && dateOnly.day == yesterday.day) {
      return 'Yesterday';  
    } else {
      return DateFormat('MMMM d, y').format(date);
    }
  }
  
  String _formatItemType(TimelineItemType type) {
    final typeStr = type.toString().split('.').last;
    final words = typeStr.split('_');
    return words.map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}