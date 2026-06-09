import 'package:flutter/material.dart';
import '../../../../domain/entities/user.dart';
import '../../user_profile/user_profile_screen.dart';
import '../../user_profile/widgets/follow_button.dart';

class UserSearchResult extends StatelessWidget {
  final User user;
  final bool isCurrentUser;

  const UserSearchResult({
    super.key,
    required this.user,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEFEBE9),
          backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
              ? NetworkImage(user.photoUrl!)
              : null,
          child: user.photoUrl == null || user.photoUrl!.isEmpty
              ? const Icon(
                  Icons.person,
                  color: Color(0xFF8D6E63),
                )
              : null,
        ),
        title: Text(
          user.displayName ?? '사용자',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6D4C41),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8D6E63),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '팔로워 ${user.followerIds.length}명',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFA1887F),
              ),
            ),
          ],
        ),
        trailing: isCurrentUser
            ? null
            : SizedBox(
                width: 90,
                height: 36,
                child: FollowButton(
                  userId: user.uid,
                  isFollowing: user.followerIds.isEmpty,
                ),
              ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(user: user),
            ),
          );
        },
      ),
    );
  }
}
