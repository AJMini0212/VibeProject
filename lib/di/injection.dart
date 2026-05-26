import 'package:get_it/get_it.dart';
import '../application/cafe/search_cafes_use_case.dart';
import '../data/repositories/cafe_repository_impl.dart';
import '../domain/repositories/cafe_repository.dart';
import '../presentation/providers/home_provider.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Data Layer
  getIt.registerSingleton<CafeRepository>(
    CafeRepositoryImpl(),
  );

  // Application Layer
  getIt.registerSingleton<SearchCafesUseCase>(
    SearchCafesUseCase(getIt<CafeRepository>()),
  );

  // Presentation Layer
  getIt.registerSingleton<HomeProvider>(
    HomeProvider(getIt<SearchCafesUseCase>()),
  );
}
