import 'package:flutter/material.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:provider/provider.dart';
import '../../logic/timeline_state.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isOnline = NetworkStatus.of(context)?.isOnline ?? false;

    return Scaffold(
      body: 
        Consumer<TimelineState>(
          builder: (context, timelineState, child) {
            return timelineState.items.isEmpty
              ? const Center(child: Text('Your timeline is empty.'))
              : ListView(
                  children: [
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
                );
          },
        ),
      );
  }
}