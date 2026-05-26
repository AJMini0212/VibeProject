import 'package:flutter/material.dart';
import '../../../domain/entities/cafe.dart';
import 'widgets/cafe_detail_map.dart';
import 'widgets/cafe_action_buttons.dart';
import 'widgets/cafe_reviews_section.dart';

class CafeDetailScreen extends StatelessWidget {
  final Cafe cafe;

  const CafeDetailScreen({
    super.key,
    required this.cafe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cafe.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 주소 정보
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cafe.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D4C41),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF8D6E63),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cafe.address,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8D6E63),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 평점 및 리뷰 수
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFA726),
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cafe.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6D4C41),
                            ),
                          ),
                          const Text(
                            '평점',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8D6E63),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(
                            Icons.comment,
                            color: Color(0xFF6D4C41),
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cafe.reviewCount.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6D4C41),
                            ),
                          ),
                          const Text(
                            '리뷰',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8D6E63),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 미니맵
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 250,
                  child: CafeDetailMap(cafe: cafe),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 액션 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: CafeActionButtons(cafe: cafe),
            ),

            const Divider(),

            // 리뷰 섹션
            CafeReviewsSection(cafe: cafe),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
