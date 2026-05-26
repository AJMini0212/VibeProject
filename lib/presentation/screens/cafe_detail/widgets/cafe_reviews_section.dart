import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/entities/cafe.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/review_provider.dart';
import 'review_card.dart';
import 'write_review_dialog.dart';

class CafeReviewsSection extends StatefulWidget {
  final Cafe cafe;

  const CafeReviewsSection({
    super.key,
    required this.cafe,
  });

  @override
  State<CafeReviewsSection> createState() => _CafeReviewsSectionState();
}

class _CafeReviewsSectionState extends State<CafeReviewsSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ReviewProvider>().loadReviewsForCafe(widget.cafe.id);
    });
  }

  void _showWriteReviewDialog() {
    final reviewProvider = context.read<ReviewProvider>();
    final currentUser = context.read<AuthProvider>().currentUser;

    showDialog(
      context: context,
      builder: (dialogContext) => const WriteReviewDialog(),
    ).then((result) async {
      if (result != null && mounted && currentUser != null) {
        await reviewProvider.createReview(
          widget.cafe.id,
          result['rating'] as int,
          result['text'] as String,
        );

        if (!mounted) return;
        if (reviewProvider.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(reviewProvider.error!),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('리뷰가 작성되었습니다'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ReviewProvider, AuthProvider>(
      builder: (context, reviewProvider, authProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '리뷰 (${reviewProvider.reviews.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D4C41),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D4C41),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onPressed: authProvider.isAuthenticated
                        ? _showWriteReviewDialog
                        : null,
                    icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                    label: const Text(
                      '작성',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            if (reviewProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (reviewProvider.reviews.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    '아직 리뷰가 없습니다',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviewProvider.reviews.length,
                itemBuilder: (context, index) {
                  final review = reviewProvider.reviews[index];
                  final isOwner = review.userId == authProvider.currentUser?.uid;

                  return ReviewCard(
                    review: review,
                    isOwner: isOwner,
                    onDelete: isOwner
                        ? () {
                            reviewProvider.deleteReview(review.id).then((_) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('리뷰가 삭제되었습니다'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            });
                          }
                        : null,
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
