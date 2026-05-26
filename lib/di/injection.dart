import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import '../application/cafe/search_cafes_use_case.dart';
import '../core/services/location_service.dart';
import '../data/datasources/cafe_local_datasource.dart';
import '../data/datasources/hive_cafe_local_datasource.dart';
import '../data/datasources/naver_api_client.dart';
import '../data/repositories/cafe_repository_impl.dart';
import '../domain/repositories/cafe_repository.dart';
import '../presentation/providers/home_provider.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Load environment variables
  final clientId = dotenv.env['NAVER_CLIENT_ID'] ?? '';
  final clientSecret = dotenv.env['NAVER_CLIENT_SECRET'] ?? '';

  // Core Services
  getIt.registerSingleton<LocationService>(
    LocationService(),
  );

  // Data Layer - HTTP Client
  getIt.registerSingleton<NaverApiClient>(
    NaverApiClient(clientId: clientId, clientSecret: clientSecret),
  );

  // Data Layer - Local Datasource
  getIt.registerSingleton<CafeLocalDatasource>(
    HiveCafeLocalDatasource(),
  );

  // Data Layer - Repository
  getIt.registerSingleton<CafeRepository>(
    CafeRepositoryImpl(
      naverApiClient: getIt<NaverApiClient>(),
      localDatasource: getIt<CafeLocalDatasource>(),
    ),
  );

  // Application Layer
  getIt.registerSingleton<SearchCafesUseCase>(
    SearchCafesUseCase(getIt<CafeRepository>()),
  );

  // Presentation Layer
  getIt.registerSingleton<HomeProvider>(
    HomeProvider(
      getIt<SearchCafesUseCase>(),
      getIt<LocationService>(),
    ),
  );
}
