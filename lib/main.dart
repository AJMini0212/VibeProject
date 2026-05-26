import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'data/datasources/cafe_local_datasource.dart';
import 'di/injection.dart';
import 'presentation/providers/home_provider.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

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
      home: ChangeNotifierProvider(
        create: (_) => getIt<HomeProvider>(),
        child: const HomeScreen(),
      ),
    );
  }
}
