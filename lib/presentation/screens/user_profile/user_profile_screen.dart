import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/user.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/auth_provider.dart';
import 'widgets/profile_header.dart';
import 'widgets/user_reviews_list.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          context.read<UserProfileProvider>();
      profileProvider.loadUserProfile(widget.user.uid);
      profileProvider.loadUserReviews(widget.user.uid);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthProvider>().currentUser?.uid ?? '';
    final isCurrentUser = currentUserId == widget.user.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.displayName),
        centerTitle: true,
        elevation: 1,
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, profileProvider, child) {
          final isFollowing =
              widget.user.followerIds.contains(currentUserId);

          return Column(
            children: [
              // 프로필 헤더
              ProfileHeader(
                user: widget.user,
                isCurrentUser: isCurrentUser,
                isFollowing: isFollowing,
              ),

              // 탭바
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF6D4C41),
                unselectedLabelColor: const Color(0xFF8D6E63),
                indicatorColor: const Color(0xFF6D4C41),
                tabs: const [
                  Tab(
                    text: '리뷰',
                    icon: Icon(Icons.rate_review_outlined),
                  ),
                  Tab(
                    text: '활동',
                    icon: Icon(Icons.history),
                  ),
                ],
              ),

              // 탭 뷰
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // 리뷰 탭
                    UserReviewsList(userId: widget.user.uid),

                    // 활동 탭 (추후 구현)
                    Center(
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
