import 'package:flutter/material.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:provider/provider.dart';
import '../../logic/timeline_state.dart';  // Will create this next

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var timelineState = context.watch<TimelineState>();
    var isOnline = NetworkStatus.of(context)?.isOnline ?? true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
      ),
      body: timelineState.items.isEmpty
        ? const Center(child: Text('Your timeline is empty.'))
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
                    icon: const Icon(Icons.bookmark),
                    onPressed: !isOnline ? null : () {
                      timelineState.removeFromTimeline(item);
                    },
                  ),
                  subtitle: Text(item.type.toString()),
                ),
            ],
          ),
    );
  }
}