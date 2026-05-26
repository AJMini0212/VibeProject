import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'di/injection.dart';
import 'presentation/providers/home_provider.dart';
import 'presentation/screens/home/home_screen.dart';

void main() {
  setupDependencies();
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
