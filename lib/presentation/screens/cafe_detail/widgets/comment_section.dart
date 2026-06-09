import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/comment_provider.dart';
import '../../../providers/auth_provider.dart';

class CommentSection extends StatefulWidget {
  final String reviewId;

  const CommentSection({
    super.key,
    required this.reviewId,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommentProvider>().loadComments(widget.reviewId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (context, commentProvider, child) {
        final comments = commentProvider.getCommentsForReview(widget.reviewId);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 1),
            const SizedBox(height: 16),

            // 댓글 입력 필드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCommentInput(context, commentProvider),
            ),

            const SizedBox(height: 16),

            // 댓글 목록
            if (comments.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    '아직 댓글이 없습니다',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF8D6E63),
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return _buildCommentItem(context, commentProvider, comment);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildCommentInput(
    BuildContext context,
    CommentProvider commentProvider,
  ) {
    final currentUser = context.read<AuthProvider>().currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '댓글 작성',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6D4C41),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: '댓글을 작성하세요...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFC0C0C0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFD7CCC8),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFD7CCC8),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF6D4C41),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D4C41),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: _commentController.text.isEmpty
                    ? null
                    : () async {
                        if (currentUser != null) {
                          await commentProvider.addComment(
                            widget.reviewId,
                            _commentController.text,
                          );
                          _commentController.clear();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('댓글이 작성되었습니다'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        }
                      },
                child: const Text(
                  '작성',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentItem(
    BuildContext context,
    CommentProvider commentProvider,
    dynamic comment,
  ) {
    final currentUserId = context.read<AuthProvider>().currentUser?.uid ?? '';
    final isOwnComment = comment.userId == currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 사용자 아바타
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEFEBE9),
                ),
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: Color(0xFF8D6E63),
                ),
              ),
              const SizedBox(width: 12),
              // 댓글 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '사용자',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6D4C41),
                          ),
                        ),
                        Text(
                          _formatTime(comment.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFC0C0C0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF424242),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              // 삭제 버튼 (본인 댓글만)
              if (isOwnComment)
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                    color: Color(0xFFC0C0C0),
                  ),
                  onPressed: () async {
                    await commentProvider.deleteComment(
                      widget.reviewId,
                      comment.id,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('댓글이 삭제되었습니다'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
            ],
          ),
          const Divider(height: 12, color: Color(0xFFF5F5F5)),
        ],
      ),
    );
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
