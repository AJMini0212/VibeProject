import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const LoadingSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    BorderRadius? borderRadius,
  }) : borderRadius = borderRadius ?? const BorderRadius.all(Radius.circular(4));

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEBE9),
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class ReviewCardSkeleton extends StatelessWidget {
  const ReviewCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 별점 스켈레톤
            Row(
              children: [
                LoadingSkeleton(width: 80, height: 16),
                const SizedBox(width: 8),
                LoadingSkeleton(width: 40, height: 16),
              ],
            ),
            const SizedBox(height: 12),
            // 리뷰 텍스트
            LoadingSkeleton(width: double.infinity, height: 16),
            const SizedBox(height: 8),
            LoadingSkeleton(width: 200, height: 14),
            const SizedBox(height: 12),
            // 타임스탐프
            LoadingSkeleton(width: 100, height: 12),
          ],
        ),
      ),
    );
  }
}

class UserCardSkeleton extends StatelessWidget {
  const UserCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 아바타
            LoadingSkeleton(
              width: 48,
              height: 48,
              borderRadius: const BorderRadius.all(Radius.circular(24)),
            ),
            const SizedBox(width: 12),
            // 사용자 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingSkeleton(width: 120, height: 16),
                  const SizedBox(height: 8),
                  LoadingSkeleton(width: 150, height: 14),
                ],
              ),
            ),
            // 팔로우 버튼
            LoadingSkeleton(width: 70, height: 32),
          ],
        ),
      ),
    );
  }
}

class ProfileHeaderSkeleton extends StatelessWidget {
  const ProfileHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 프로필 이미지
          LoadingSkeleton(
            width: 100,
            height: 100,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          const SizedBox(height: 16),
          // 사용자명
          LoadingSkeleton(width: 150, height: 24),
          const SizedBox(height: 8),
          // 이메일
          LoadingSkeleton(width: 200, height: 14),
          const SizedBox(height: 16),
          // 팔로워/팔로잉
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  LoadingSkeleton(width: 40, height: 18),
                  const SizedBox(height: 4),
                  LoadingSkeleton(width: 50, height: 12),
                ],
              ),
              Column(
                children: [
                  LoadingSkeleton(width: 40, height: 18),
                  const SizedBox(height: 4),
                  LoadingSkeleton(width: 50, height: 12),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 팔로우 버튼
          LoadingSkeleton(width: double.infinity, height: 40),
        ],
      ),
    );
  }
}

class ActivityListSkeleton extends StatelessWidget {
  const ActivityListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 아바타
            LoadingSkeleton(
              width: 48,
              height: 48,
              borderRadius: const BorderRadius.all(Radius.circular(24)),
            ),
            const SizedBox(width: 12),
            // 활동 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingSkeleton(width: 100, height: 14),
                  const SizedBox(height: 8),
                  LoadingSkeleton(width: double.infinity, height: 16),
                  const SizedBox(height: 4),
                  LoadingSkeleton(width: 200, height: 14),
                ],
              ),
            ),
            // 타임스탐프
            LoadingSkeleton(width: 50, height: 12),
          ],
        ),
      ),
    );
  }
}
