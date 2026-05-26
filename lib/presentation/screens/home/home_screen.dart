import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafematch/domain/entities/cafe.dart';
import '../../providers/home_provider.dart';
import 'widgets/map_widget.dart';

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

    return ListView.builder(
      itemCount: provider.cafes.length,
      itemBuilder: (context, index) {
        final cafe = provider.cafes[index];
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
    );
  }

  void _showCafeDetail(Cafe cafe) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${cafe.name} 선택됨')),
    );
  }
}
