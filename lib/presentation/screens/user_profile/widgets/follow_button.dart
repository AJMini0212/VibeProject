import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/follow_provider.dart';

class FollowButton extends StatefulWidget {
  final String userId;
  final bool isFollowing;

  const FollowButton({
    super.key,
    required this.userId,
    required this.isFollowing,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFollowing
              ? const Color(0xFFF5F5F5)
              : const Color(0xFF6D4C41),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: _isFollowing
                  ? const Color(0xFFC0C0C0)
                  : const Color(0xFF6D4C41),
              width: 1,
            ),
          ),
        ),
        onPressed: () async {
          final followProvider =
              context.read<FollowProvider>();
          try {
            if (_isFollowing) {
              await followProvider.unfollowUser(widget.userId);
            } else {
              await followProvider.followUser(widget.userId);
            }
            setState(() {
              _isFollowing = !_isFollowing;
            });
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFollowing ? '팔로우했습니다' : '팔로우 취소했습니다',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('오류가 발생했습니다: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: Text(
          _isFollowing ? '팔로잉' : '팔로우',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _isFollowing
                ? const Color(0xFF424242)
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
