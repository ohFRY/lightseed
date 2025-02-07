import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/timeline_state.dart';  // Will create this next

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var timelineState = context.watch<TimelineState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
      ),
      body: Center(
        child: timelineState.items.isEmpty
            ? Text('Your timeline is empty.')
            : ListView(
                children: [
                  ListTile(
                    title: Text('Your Timeline', 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  for (var item in timelineState.items)
                    ListTile(
                      title: Text(item.content),
                      titleTextStyle: Theme.of(context).textTheme.headlineMedium,
                      trailing: IconButton(
                        icon: Icon(Icons.bookmark),
                        onPressed: () {
                          timelineState.removeFromTimeline(item);
                        },
                      ),
                      subtitle: Text(item.type.toString()), // Will show item type
                    ),
                ],
              ),
      ),
    );
  }
}