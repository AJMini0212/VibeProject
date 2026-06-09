import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/review.dart';
import '../../../providers/auth_provider.dart';

class ReviewInteractions extends StatefulWidget {
  final Review review;
  final VoidCallback onCommentPressed;
  final VoidCallback onDeletePressed;

  const ReviewInteractions({
    super.key,
    required this.review,
    required this.onCommentPressed,
    required this.onDeletePressed,
  });

  @override
  State<ReviewInteractions> createState() => _ReviewInteractionsState();
}

class _ReviewInteractionsState extends State<ReviewInteractions> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    final currentUserId = context.read<AuthProvider>().currentUser?.uid ?? '';
    _isLiked = widget.review.likedByUserIds.contains(currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthProvider>().currentUser?.uid ?? '';
    final isOwnReview = widget.review.userId == currentUserId;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          // 상호작용 버튼 바
          Row(
            children: [
              // 좋아요 버튼
              Expanded(
                child: _buildInteractionButton(
                  icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                  label: '좋아요',
                  count: widget.review.likeCount,
                  color: _isLiked ? Colors.red : const Color(0xFF8D6E63),
                  onPressed: () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              // 댓글 버튼
              Expanded(
                child: _buildInteractionButton(
                  icon: Icons.comment_outlined,
                  label: '댓글',
                  count: widget.review.commentCount,
                  color: const Color(0xFF8D6E63),
                  onPressed: widget.onCommentPressed,
                ),
              ),
              const SizedBox(width: 16),
              // 더보기 메뉴
              if (isOwnReview)
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('삭제'),
                        ],
                      ),
                      onTap: widget.onDeletePressed,
                    ),
                  ],
                  child: const Icon(
                    Icons.more_vert,
                    color: Color(0xFF8D6E63),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
