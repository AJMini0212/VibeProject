import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activity_feed_provider.dart';
import 'widgets/activity_list_item.dart';

class ActivityFeedScreen extends StatefulWidget {
  const ActivityFeedScreen({super.key});

  @override
  State<ActivityFeedScreen> createState() => _ActivityFeedScreenState();
}

class _ActivityFeedScreenState extends State<ActivityFeedScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityFeedProvider>().loadActivityFeed();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      context.read<ActivityFeedProvider>().loadMoreActivities();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('활동 피드'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Consumer<ActivityFeedProvider>(
        builder: (context, feedProvider, child) {
          if (feedProvider.isLoading && feedProvider.activities.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (feedProvider.error != null && feedProvider.activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: const Color(0xFFD7CCC8),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    feedProvider.error ?? '오류가 발생했습니다',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8D6E63),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      feedProvider.refreshFeed();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          if (feedProvider.activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.explore_outlined,
                    size: 64,
                    color: const Color(0xFFD7CCC8),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '활동이 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8D6E63),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '팔로우한 사용자들의 활동이 표시됩니다',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFA1887F),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => feedProvider.refreshFeed(),
            color: const Color(0xFF6D4C41),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: feedProvider.activities.length +
                  (feedProvider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == feedProvider.activities.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }

                final activity = feedProvider.activities[index];
                return ActivityListItem(activity: activity);
              },
            ),
          );
        },
      ),
    );
  }
}
