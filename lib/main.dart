import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'core/services/firebase_service.dart';
import 'data/datasources/cafe_local_datasource.dart';
import 'di/injection.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/home_provider.dart';
import 'presentation/providers/review_provider.dart';
import 'presentation/providers/comment_provider.dart';
import 'presentation/providers/search_provider.dart';
import 'presentation/providers/follow_provider.dart';
import 'presentation/providers/activity_feed_provider.dart';
import 'presentation/providers/user_profile_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Firebase (skip on web due to compatibility issues)
  if (!identical(0, 0.0)) { // This is true only on non-web platforms
    try {
      await getIt<FirebaseService>().initialize();
    } catch (e) {
      // Firebase initialization failed, continue without it
    }
  }

  // Initialize Hive
  await Hive.initFlutter();

  // Setup dependency injection
  setupDependencies();

  // Initialize local datasource
  await getIt<CafeLocalDatasource>().initializeHive();

  runApp(const CafeMatchApp());
}

class CafeMatchApp extends StatelessWidget {
  const CafeMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CafeMatch',
      theme: AppTheme.light,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => getIt<AuthProvider>()..checkAuthStatus(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<HomeProvider>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<ReviewProvider>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<CommentProvider>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<SearchProvider>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<FollowProvider>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<ActivityFeedProvider>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<UserProfileProvider>(),
          ),
        ],
        child: const _HomeRouterWidget(),
      ),
    );
  }
}

class _HomeRouterWidget extends StatelessWidget {
  const _HomeRouterWidget();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
