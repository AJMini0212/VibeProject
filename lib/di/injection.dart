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
import '../application/follow/follow_user_use_case.dart';
import '../application/follow/unfollow_user_use_case.dart';
import '../application/follow/get_followers_use_case.dart';
import '../application/follow/get_following_use_case.dart';
import '../application/activity/get_activity_feed_use_case.dart';
import '../application/comment/add_comment_use_case.dart';
import '../application/comment/get_comments_use_case.dart';
import '../application/comment/delete_comment_use_case.dart';
import '../core/services/firebase_service.dart';
import '../core/services/location_service.dart';
import '../data/datasources/cafe_local_datasource.dart';
import '../data/datasources/firebase_auth_datasource.dart';
import '../data/datasources/firebase_auth_datasource_impl.dart';
import '../data/datasources/firestore_review_datasource.dart';
import '../data/datasources/firestore_review_datasource_impl.dart';
import '../data/datasources/firestore_user_datasource.dart';
import '../data/datasources/firestore_user_datasource_impl.dart';
import '../data/datasources/firestore_follow_datasource.dart';
import '../data/datasources/firestore_follow_datasource_impl.dart';
import '../data/datasources/firestore_activity_datasource.dart';
import '../data/datasources/firestore_activity_datasource_impl.dart';
import '../data/datasources/firestore_comment_datasource.dart';
import '../data/datasources/firestore_comment_datasource_impl.dart';
import '../data/datasources/hive_cafe_local_datasource.dart';
import '../data/datasources/naver_api_client.dart';
import '../data/repositories/cafe_repository_impl.dart';
import '../data/repositories/review_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../data/repositories/follow_repository_impl.dart';
import '../data/repositories/activity_repository_impl.dart';
import '../data/repositories/comment_repository_impl.dart';
import '../domain/repositories/cafe_repository.dart';
import '../domain/repositories/review_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/repositories/follow_repository.dart';
import '../domain/repositories/activity_repository.dart';
import '../domain/repositories/comment_repository.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/providers/home_provider.dart';
import '../presentation/providers/review_provider.dart';
import '../presentation/providers/follow_provider.dart';
import '../presentation/providers/activity_feed_provider.dart';
import '../presentation/providers/comment_provider.dart';
import '../presentation/providers/user_profile_provider.dart';
import '../presentation/providers/search_provider.dart';

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

  // Data Layer - Firestore Follow Datasource
  getIt.registerSingleton<FirestoreFollowDatasource>(
    FirestoreFollowDatasourceImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Data Layer - Firestore Activity Datasource
  getIt.registerSingleton<FirestoreActivityDatasource>(
    FirestoreActivityDatasourceImpl(
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Data Layer - Firestore Comment Datasource
  getIt.registerSingleton<FirestoreCommentDatasource>(
    FirestoreCommentDatasourceImpl(
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

  getIt.registerSingleton<FollowRepository>(
    FollowRepositoryImpl(
      authDatasource: getIt<FirebaseAuthDatasource>(),
      followDatasource: getIt<FirestoreFollowDatasource>(),
    ),
  );

  getIt.registerSingleton<ActivityRepository>(
    ActivityRepositoryImpl(
      authDatasource: getIt<FirebaseAuthDatasource>(),
      activityDatasource: getIt<FirestoreActivityDatasource>(),
    ),
  );

  getIt.registerSingleton<CommentRepository>(
    CommentRepositoryImpl(
      authDatasource: getIt<FirebaseAuthDatasource>(),
      commentDatasource: getIt<FirestoreCommentDatasource>(),
      firestore: getIt<FirebaseFirestore>(),
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

  // Application Layer - Use Cases (Follow)
  getIt.registerSingleton<FollowUserUseCase>(
    FollowUserUseCase(followRepository: getIt<FollowRepository>()),
  );

  getIt.registerSingleton<UnfollowUserUseCase>(
    UnfollowUserUseCase(followRepository: getIt<FollowRepository>()),
  );

  getIt.registerSingleton<GetFollowersUseCase>(
    GetFollowersUseCase(followRepository: getIt<FollowRepository>()),
  );

  getIt.registerSingleton<GetFollowingUseCase>(
    GetFollowingUseCase(followRepository: getIt<FollowRepository>()),
  );

  // Application Layer - Use Cases (Activity)
  getIt.registerSingleton<GetActivityFeedUseCase>(
    GetActivityFeedUseCase(activityRepository: getIt<ActivityRepository>()),
  );

  // Application Layer - Use Cases (Comment)
  getIt.registerSingleton<AddCommentUseCase>(
    AddCommentUseCase(commentRepository: getIt<CommentRepository>()),
  );

  getIt.registerSingleton<GetCommentsUseCase>(
    GetCommentsUseCase(commentRepository: getIt<CommentRepository>()),
  );

  getIt.registerSingleton<DeleteCommentUseCase>(
    DeleteCommentUseCase(commentRepository: getIt<CommentRepository>()),
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

  getIt.registerSingleton<FollowProvider>(
    FollowProvider(
      followUserUseCase: getIt<FollowUserUseCase>(),
      unfollowUserUseCase: getIt<UnfollowUserUseCase>(),
      getFollowersUseCase: getIt<GetFollowersUseCase>(),
      getFollowingUseCase: getIt<GetFollowingUseCase>(),
    ),
  );

  getIt.registerSingleton<ActivityFeedProvider>(
    ActivityFeedProvider(
      getActivityFeedUseCase: getIt<GetActivityFeedUseCase>(),
    ),
  );

  getIt.registerSingleton<CommentProvider>(
    CommentProvider(
      addCommentUseCase: getIt<AddCommentUseCase>(),
      getCommentsUseCase: getIt<GetCommentsUseCase>(),
      deleteCommentUseCase: getIt<DeleteCommentUseCase>(),
    ),
  );

  getIt.registerSingleton<UserProfileProvider>(
    UserProfileProvider(
      userRepository: getIt<UserRepository>(),
      reviewRepository: getIt<ReviewRepository>(),
      getFollowersUseCase: getIt<GetFollowersUseCase>(),
      getFollowingUseCase: getIt<GetFollowingUseCase>(),
    ),
  );

  getIt.registerSingleton<SearchProvider>(
    SearchProvider(
      userRepository: getIt<UserRepository>(),
    ),
  );
}
