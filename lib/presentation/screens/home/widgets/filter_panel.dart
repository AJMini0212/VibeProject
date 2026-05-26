import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../providers/home_provider.dart';

class FilterPanel extends StatefulWidget {
  final VoidCallback onClearFilters;

  const FilterPanel({
    super.key,
    required this.onClearFilters,
  });

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<HomeProvider>().searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return Card(
          margin: const EdgeInsets.all(12),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 검색 입력창
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '카페명 또는 주소로 검색...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF6D4C41)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              provider.updateSearchQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFD7CCC8)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onChanged: (value) {
                    provider.updateSearchQuery(value);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // 평점 필터
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFA726), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      '평점',
                      style: TextStyle(
                        color: Color(0xFF6D4C41),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      provider.minRating == 0.0
                          ? '전체'
                          : '${provider.minRating.toStringAsFixed(1)}점 이상',
                      style: const TextStyle(
                        color: Color(0xFF8D6E63),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: provider.minRating,
                  min: 0.0,
                  max: 5.0,
                  divisions: 10,
                  label: provider.minRating.toStringAsFixed(1),
                  activeColor: const Color(0xFF8D6E63),
                  inactiveColor: const Color(0xFFD7CCC8),
                  onChanged: (value) {
                    provider.setMinRating(value);
                  },
                ),
                const SizedBox(height: 12),

                // 거리 필터
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF6D4C41), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      '거리',
                      style: TextStyle(
                        color: Color(0xFF6D4C41),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DistanceCalculator.formatDistance(provider.maxDistance),
                      style: const TextStyle(
                        color: Color(0xFF8D6E63),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: provider.maxDistance,
                  min: 0.0,
                  max: 100.0,
                  divisions: 20,
                  label: DistanceCalculator.formatDistance(provider.maxDistance),
                  activeColor: const Color(0xFF8D6E63),
                  inactiveColor: const Color(0xFFD7CCC8),
                  onChanged: (value) {
                    provider.setMaxDistance(value);
                  },
                ),
                const SizedBox(height: 12),

                // 정렬 옵션
                Row(
                  children: [
                    const Icon(Icons.sort, color: Color(0xFF6D4C41), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      '정렬',
                      style: TextStyle(
                        color: Color(0xFF6D4C41),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    DropdownButton<SortType>(
                      value: provider.sortType,
                      underline: Container(),
                      items: const [
                        DropdownMenuItem(
                          value: SortType.distance,
                          child: Text('거리순'),
                        ),
                        DropdownMenuItem(
                          value: SortType.rating,
                          child: Text('평점순'),
                        ),
                        DropdownMenuItem(
                          value: SortType.reviewCount,
                          child: Text('리뷰순'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          provider.setSortType(value);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 초기화 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('필터 초기화'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD7CCC8),
                      foregroundColor: const Color(0xFF6D4C41),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      provider.resetFilters();
                      widget.onClearFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
