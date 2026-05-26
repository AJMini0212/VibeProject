import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<HomeProvider>().searchCafes(
        latitude: 37.5665,
        longitude: 126.9780,
        query: '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CafeMatch - 카페 찾기'),
        centerTitle: true,
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
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
            return const Center(
              child: Text('카페를 찾을 수 없습니다'),
            );
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
