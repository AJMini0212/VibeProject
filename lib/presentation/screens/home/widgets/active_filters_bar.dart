import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../providers/home_provider.dart';

class ActiveFiltersBar extends StatelessWidget {
  const ActiveFiltersBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        final filters = <Widget>[];

        // 검색어 필터
        if (provider.searchQuery.isNotEmpty) {
          filters.add(
            _FilterChip(
              label: '검색: ${provider.searchQuery}',
              onRemove: () => provider.updateSearchQuery(''),
            ),
          );
        }

        // 평점 필터
        if (provider.minRating > 0.0) {
          filters.add(
            _FilterChip(
              label: '평점: ${provider.minRating.toStringAsFixed(1)}점 이상',
              onRemove: () => provider.setMinRating(0.0),
            ),
          );
        }

        // 거리 필터
        if (provider.maxDistance < 100.0) {
          filters.add(
            _FilterChip(
              label: '거리: ${DistanceCalculator.formatDistance(provider.maxDistance)} 이내',
              onRemove: () => provider.setMaxDistance(100.0),
            ),
          );
        }

        // 리뷰 수 필터
        if (provider.minReviewCount > 0) {
          filters.add(
            _FilterChip(
              label: '리뷰: ${provider.minReviewCount}개 이상',
              onRemove: () => provider.setMinReviewCount(0),
            ),
          );
        }

        // 활성 필터가 없으면 표시하지 않음
        if (filters.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '활성 필터 (${filters.length})',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8D6E63),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: filters,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onRemove,
      backgroundColor: const Color(0xFFEFEBE9),
      labelStyle: const TextStyle(
        color: Color(0xFF6D4C41),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      deleteIconColor: const Color(0xFF8D6E63),
    );
  }
}
