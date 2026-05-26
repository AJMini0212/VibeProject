import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafematch/domain/entities/cafe.dart';
import '../../providers/auth_provider.dart';
import '../../providers/home_provider.dart';
import 'widgets/map_widget.dart';
import 'widgets/filter_panel.dart';
import 'widgets/active_filters_bar.dart';
import '../cafe_detail/cafe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<HomeProvider>().getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CafeMatch'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.map), text: '지도'),
            Tab(icon: Icon(Icons.list), text: '목록'),
          ],
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingLocation) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.locationError != null) {
            return _buildLocationErrorUI(context, provider);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              MapWidget(
                currentLocation: provider.currentLocation,
                cafes: provider.cafes,
                onCafeTapped: (cafe) => _showCafeDetail(cafe),
              ),
              _buildListTab(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLocationErrorUI(BuildContext context, HomeProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            provider.locationError ?? '위치 정보를 가져올 수 없습니다',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => provider.getCurrentLocation(),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildListTab(HomeProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('오류: ${provider.error}'),
          ],
        ),
      );
    }

    if (provider.cafes.isEmpty) {
      return const Center(child: Text('카페를 찾을 수 없습니다'));
    }

    final filteredCafes = provider.filteredCafes;

    return Column(
      children: [
        // 필터 패널
        SingleChildScrollView(
          child: Column(
            children: [
              FilterPanel(
                onClearFilters: () {},
              ),
              const ActiveFiltersBar(),
            ],
          ),
        ),

        // 결과 개수 표시
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '총 ${provider.cafes.length}개 중 ${filteredCafes.length}개 카페 찾음',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // 카페 리스트
        Expanded(
          child: filteredCafes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '검색 결과가 없습니다',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: filteredCafes.length,
                  itemBuilder: (context, index) {
                    final cafe = filteredCafes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(cafe.name),
                        subtitle: Text(cafe.address),
                        trailing: Chip(
                          label: Text('⭐ ${cafe.rating}'),
                          backgroundColor: Colors.brown[100],
                        ),
                        onTap: () => _showCafeDetail(cafe),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showCafeDetail(Cafe cafe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CafeDetailScreen(cafe: cafe),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말로 로그아웃하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthProvider>().logout();
                Navigator.pop(context);
              },
              child: const Text(
                '로그아웃',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
