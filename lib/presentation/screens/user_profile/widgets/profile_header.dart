import 'package:flutter/material.dart';
import '../../../../domain/entities/user.dart';
import 'follow_button.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.isCurrentUser,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 프로필 이미지
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEFEBE9),
              border: Border.all(
                color: const Color(0xFFA1887F),
                width: 2,
              ),
            ),
            child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      user.photoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFF8D6E63),
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 60,
                    color: Color(0xFF8D6E63),
                  ),
          ),
          const SizedBox(height: 16),

          // 사용자명
          Text(
            user.displayName ?? '사용자',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D4C41),
            ),
          ),
          const SizedBox(height: 8),

          // 이메일
          Text(
            user.email,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF8D6E63),
            ),
          ),
          const SizedBox(height: 16),

          // 소개글
          if (user.bio != null && user.bio!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                user.bio!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF616161),
                  height: 1.5,
                ),
              ),
            ),
          if (user.bio != null && user.bio!.isNotEmpty)
            const SizedBox(height: 16),

          // 팔로워/팔로잉 통계
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  count: user.followerIds.length,
                  label: '팔로워',
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: const Color(0xFFD7CCC8),
                ),
                _StatItem(
                  count: user.followingIds.length,
                  label: '팔로잉',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 팔로우 버튼 (자신의 프로필이 아닐 때만)
          if (!isCurrentUser)
            FollowButton(
              userId: user.uid,
              isFollowing: isFollowing,
            ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int count;
  final String label;

  const _StatItem({
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6D4C41),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF8D6E63),
          ),
        ),
      ],
    );
  }
}
