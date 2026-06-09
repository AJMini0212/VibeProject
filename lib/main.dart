import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
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
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Firebase
  try {
    if (identical(0, 0.0)) {
      // Web platform: Firebase initialized via HTML script + Dart
      // Wait a moment for HTML script to initialize Firebase
      await Future.delayed(const Duration(milliseconds: 500));

      if (firebase_core.Firebase.apps.isEmpty) {
        try {
          await firebase_core.Firebase.initializeApp(
            options: const firebase_core.FirebaseOptions(
              apiKey: "AIzaSyBJ0cW2IMGssiWBSOuEZuYpkSB-66PdRQo",
              authDomain: "cafematch-9e3b8.firebaseapp.com",
              projectId: "cafematch-9e3b8",
              storageBucket: "cafematch-9e3b8.appspot.com",
              messagingSenderId: "519189156049",
              appId: "1:519189156049:web:30b01e07d0b4c4c2e8cfb9",
            ),
          );
        } catch (e) {
          // Firebase might already be initialized by HTML script
          // This is expected on web platform
        }
      }
    } else {
      // Non-web platform: initialize Firebase via service
      await getIt<FirebaseService>().initialize();
    }
  } catch (e) {
    // Firebase initialization failed, continue with limited functionality
  }

  // Initialize Hive (skip on web)
  if (!identical(0, 0.0)) {
    await Hive.initFlutter();
  }

  // Setup dependency injection
  setupDependencies();

  // Initialize local datasource (skip on web)
  if (!identical(0, 0.0)) {
    await getIt<CafeLocalDatasource>().initializeHive();
  }

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

class _HomeRouterWidget extends StatefulWidget {
  const _HomeRouterWidget();

  @override
  State<_HomeRouterWidget> createState() => _HomeRouterWidgetState();
}

class _HomeRouterWidgetState extends State<_HomeRouterWidget> {
  bool _showRegister = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        } else if (_showRegister) {
          return Scaffold(
            body: RegisterScreen(
              onBackToLogin: () {
                setState(() {
                  _showRegister = false;
                });
              },
            ),
          );
        } else {
          return LoginScreen(
            onRegisterTapped: () {
              setState(() {
                _showRegister = true;
              });
            },
          );
        }
      },
    );
  }
}
