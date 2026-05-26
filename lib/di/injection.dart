import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import '../application/auth/get_current_user_use_case.dart';
import '../application/auth/login_use_case.dart';
import '../application/auth/logout_use_case.dart';
import '../application/auth/register_use_case.dart';
import '../application/cafe/search_cafes_use_case.dart';
import '../application/review/create_review_use_case.dart';
import '../application/review/get_reviews_for_cafe_use_case.dart';
import '../application/review/delete_review_use_case.dart';
import '../core/services/firebase_service.dart';
import '../core/services/location_service.dart';
import '../data/datasources/cafe_local_datasource.dart';
import '../data/datasources/firebase_auth_datasource.dart';
import '../data/datasources/firebase_auth_datasource_impl.dart';
import '../data/datasources/firestore_review_datasource.dart';
import '../data/datasources/firestore_review_datasource_impl.dart';
import '../data/datasources/firestore_user_datasource.dart';
import '../data/datasources/firestore_user_datasource_impl.dart';
import '../data/datasources/hive_cafe_local_datasource.dart';
import '../data/datasources/naver_api_client.dart';
import '../data/repositories/cafe_repository_impl.dart';
import '../data/repositories/review_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/cafe_repository.dart';
import '../domain/repositories/review_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/home_provider.dart';
import '../presentation/providers/review_provider.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Load environment variables
  final clientId = dotenv.env['NAVER_CLIENT_ID'] ?? '';
  final clientSecret = dotenv.env['NAVER_CLIENT_SECRET'] ?? '';

  // Core Services
  getIt.registerSingleton<LocationService>(
    LocationService(),
  );

  getIt.registerSingleton<FirebaseService>(
    FirebaseService(),
  );

  // Firebase instances
  getIt.registerSingleton<FirebaseAuth>(
    FirebaseAuth.instance,
  );

  getIt.registerSingleton<FirebaseFirestore>(
    FirebaseFirestore.instance,
  );

  // Data Layer - HTTP Client (Cafe)
  getIt.registerSingleton<NaverApiClient>(
    NaverApiClient(clientId: clientId, clientSecret: clientSecret),
  );

  // Data Layer - Local Datasource (Cafe)
  getIt.registerSingleton<CafeLocalDatasource>(
    HiveCafeLocalDatasource(),
  );

  // Data Layer - Firebase Auth Datasource
  getIt.registerSingleton<FirebaseAuthDatasource>(
    FirebaseAuthDatasourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Data Layer - Firestore User Datasource
  getIt.registerSingleton<FirestoreUserDatasource>(
    FirestoreUserDatasourceImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Data Layer - Firestore Review Datasource
  getIt.registerSingleton<FirestoreReviewDatasource>(
    FirestoreReviewDatasourceImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Data Layer - Repositories (Cafe)
  getIt.registerSingleton<CafeRepository>(
    CafeRepositoryImpl(
      naverApiClient: getIt<NaverApiClient>(),
      localDatasource: getIt<CafeLocalDatasource>(),
    ),
  );

  // Data Layer - Repositories (Auth & Review)
  getIt.registerSingleton<UserRepository>(
    UserRepositoryImpl(
      authDatasource: getIt<FirebaseAuthDatasource>(),
      userDatasource: getIt<FirestoreUserDatasource>(),
    ),
  );

  getIt.registerSingleton<ReviewRepository>(
    ReviewRepositoryImpl(
      reviewDatasource: getIt<FirestoreReviewDatasource>(),
    ),
  );

  // Application Layer - Use Cases (Cafe)
  getIt.registerSingleton<SearchCafesUseCase>(
    SearchCafesUseCase(getIt<CafeRepository>()),
  );

  // Application Layer - Use Cases (Auth)
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(userRepository: getIt<UserRepository>()),
  );

  getIt.registerSingleton<RegisterUseCase>(
    RegisterUseCase(userRepository: getIt<UserRepository>()),
  );

  getIt.registerSingleton<LogoutUseCase>(
    LogoutUseCase(userRepository: getIt<UserRepository>()),
  );

  getIt.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(userRepository: getIt<UserRepository>()),
  );

  // Application Layer - Use Cases (Review)
  getIt.registerSingleton<CreateReviewUseCase>(
    CreateReviewUseCase(getIt<ReviewRepository>()),
  );

  getIt.registerSingleton<GetReviewsForCafeUseCase>(
    GetReviewsForCafeUseCase(getIt<ReviewRepository>()),
  );

  getIt.registerSingleton<DeleteReviewUseCase>(
    DeleteReviewUseCase(getIt<ReviewRepository>()),
  );

  // Presentation Layer - Providers
  getIt.registerSingleton<HomeProvider>(
    HomeProvider(
      getIt<SearchCafesUseCase>(),
      getIt<LocationService>(),
    ),
  );

  getIt.registerSingleton<AuthProvider>(
    AuthProvider(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      userRepository: getIt<UserRepository>(),
    ),
  );

  getIt.registerSingleton<ReviewProvider>(
    ReviewProvider(
      getIt<CreateReviewUseCase>(),
      getIt<GetReviewsForCafeUseCase>(),
      getIt<DeleteReviewUseCase>(),
    ),
  );
}
