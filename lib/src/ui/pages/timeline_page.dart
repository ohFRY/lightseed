import 'package:flutter/material.dart';
import 'package:lightseed/src/logic/auth_logic.dart';
import 'package:lightseed/src/services/network/network_status_service.dart';
import 'package:provider/provider.dart';
import '../../logic/timeline_state.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isOnline = NetworkStatus.of(context)?.isOnline ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
        toolbarHeight: 100,
        centerTitle: true,
        actions: [
          StreamBuilder<bool>(
            stream: NetworkStatus.of(context)?.networkStatusStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final userId = AuthLogic.getValidUserId();
          if (userId != null) {
            final timelineState = Provider.of<TimelineState>(context, listen: false);
            await timelineState.refreshTimeline();
          }
        },
        child: Consumer<TimelineState>(
          builder: (context, timelineState, child) {
            return timelineState.items.isEmpty
              ? const Center(child: Text('Your timeline is empty.'))
              : ListView(
                  children: [
                    const ListTile(
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
                );
          },
        ),
      ),
    );
  }
}