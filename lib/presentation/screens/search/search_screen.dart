import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/auth_provider.dart';
import 'widgets/user_search_result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthProvider>().currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('사용자 검색'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          // 검색 입력 필드
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '사용자명 또는 이메일로 검색',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8D6E63)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF8D6E63)),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SearchProvider>().clearSearch();
                        },
                      )
                    : null,
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
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (query) {
                context.read<SearchProvider>().searchUsers(query);
                setState(() {});
              },
            ),
          ),

          // 검색 결과
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                if (!searchProvider.hasSearched) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: const Color(0xFFD7CCC8),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '사용자를 검색해보세요',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8D6E63),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (searchProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (searchProvider.error != null) {
                  return Center(
                    child: Text(
                      searchProvider.error ?? '오류가 발생했습니다',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                if (searchProvider.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          size: 64,
                          color: const Color(0xFFD7CCC8),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '검색 결과가 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8D6E63),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: searchProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final user = searchProvider.searchResults[index];
                    final isCurrentUser = user.uid == currentUserId;

                    return UserSearchResult(
                      user: user,
                      isCurrentUser: isCurrentUser,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
