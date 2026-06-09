import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/review.dart';
import '../../../providers/user_profile_provider.dart';

class UserReviewsList extends StatelessWidget {
  final String userId;

  const UserReviewsList({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.userReviews.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 64,
                    color: const Color(0xFFD7CCC8),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '작성한 리뷰가 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8D6E63),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.userReviews.length,
          itemBuilder: (context, index) {
            final review = provider.userReviews[index];
            return _ReviewCard(review: review);
          },
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카페명 (향후 추가)
            Text(
              '리뷰 #${review.id.substring(0, 8)}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8D6E63),
              ),
            ),
            const SizedBox(height: 8),

            // 별점
            Row(
              children: [
                ...List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating ? Icons.star : Icons.star_outline,
                    color: const Color(0xFFFFA726),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  review.rating.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6D4C41),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 리뷰 내용
            Text(
              review.text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF424242),
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // 상호작용 정보 (좋아요, 댓글 수)
            Row(
              children: [
                Icon(
                  Icons.favorite_outline,
                  size: 14,
                  color: const Color(0xFF8D6E63),
                ),
                const SizedBox(width: 4),
                Text(
                  review.likeCount.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8D6E63),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.comment_outlined,
                  size: 14,
                  color: const Color(0xFF8D6E63),
                ),
                const SizedBox(width: 4),
                Text(
                  review.commentCount.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8D6E63),
                  ),
                ),
              ],
            ),

            // 작성 시간
            const SizedBox(height: 8),
            Text(
              _formatDate(review.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFC0C0C0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

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
