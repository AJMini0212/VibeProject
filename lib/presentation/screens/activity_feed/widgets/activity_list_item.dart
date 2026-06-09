import 'package:flutter/material.dart';
import '../../../domain/entities/activity.dart';
import '../../user_profile/user_profile_screen.dart';
import '../../../domain/repositories/user_repository.dart';
import 'package:get_it/get_it.dart';

class ActivityListItem extends StatelessWidget {
  final Activity activity;

  const ActivityListItem({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUserName(),
      builder: (context, snapshot) {
        final userName = snapshot.data ?? '사용자';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFEFEBE9),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF8D6E63),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6D4C41),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getActivityText(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF616161),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _formatTime(activity.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFC0C0C0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _getUserName() async {
    try {
      final userRepository = GetIt.instance<UserRepository>();
      final user = await userRepository.getUserById(activity.userId);
      return user?.displayName ?? '사용자';
    } catch (e) {
      return '사용자';
    }
  }

  String _getActivityText() {
    switch (activity.type) {
      case ActivityType.follow:
        return '새 사용자를 팔로우하기 시작했습니다';
      case ActivityType.reviewPosted:
        return '새로운 리뷰를 작성했습니다';
      case ActivityType.reviewLiked:
        return '리뷰에 좋아요를 눌렀습니다';
      case ActivityType.commentAdded:
        return '리뷰에 댓글을 작성했습니다';
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}
