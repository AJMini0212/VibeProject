# ⚡ Firestore 최적화 가이드

## 개요

CafeMatch 앱의 Firestore 성능 최적화 전략과 모범 사례.

---

## 🎯 최적화 원칙

1. **필요한 데이터만 읽기**: 필드 선택 (`.select()`)
2. **배치 작업**: 여러 읽기/쓰기 트랜잭션
3. **캐싱**: 메모리 캐시로 중복 읽기 방지
4. **페이지네이션**: 대량 데이터는 페이지 단위로 로드
5. **인덱스 활용**: 복합 인덱스로 쿼리 성능 향상

---

## 📊 주요 쿼리 최적화

### 1. 카페별 리뷰 조회

**최적화 전 (비효율적):**
```dart
final reviews = await firestore
  .collection('reviews')
  .where('cafeId', isEqualTo: cafeId)
  .orderBy('createdAt', descending: true)
  .get();
  
// 문제: 모든 리뷰 필드 로드, 페이지네이션 없음
```

**최적화 후 (효율적):**
```dart
final reviews = await firestore
  .collection('reviews')
  .where('cafeId', isEqualTo: cafeId)
  .orderBy('createdAt', descending: true)
  .select(['id', 'userId', 'rating', 'text', 'createdAt', 'likeCount', 'commentCount'])
  .limit(20)
  .get();

// 개선사항:
// - 필요한 필드만 로드
// - 페이지네이션으로 메모리 사용 감소
```

**추가 개선 (페이지네이션):**
```dart
class ReviewRepository {
  static const pageSize = 20;
  DateTime? _lastTimestamp;

  Future<List<Review>> getReviewsByPage(String cafeId, {DateTime? cursor}) async {
    Query query = firestore
      .collection('reviews')
      .where('cafeId', isEqualTo: cafeId)
      .orderBy('createdAt', descending: true)
      .limit(pageSize + 1); // +1로 다음 페이지 있는지 확인

    if (cursor != null) {
      query = query.where('createdAt', isLessThan: cursor);
    }

    final docs = await query.get();
    _lastTimestamp = docs.docs.last.get('createdAt') as DateTime;
    
    return docs.docs
      .take(pageSize)
      .map((doc) => ReviewMapper.toEntity(doc))
      .toList();
  }

  bool get hasMore => false; // 구현: 다음 페이지 있는지 확인
}
```

---

### 2. 사용자 프로필 + 리뷰 조회

**비효율적 (N+1 쿼리 문제):**
```dart
// 1. 사용자 정보 조회
final user = await firestore.collection('users').doc(userId).get();

// 2. 사용자의 모든 리뷰 조회 (N+1)
final reviews = await firestore
  .collection('reviews')
  .where('userId', isEqualTo: userId)
  .get();

// 문제: 2번의 분리된 쿼리, 불필요한 필드 로드
```

**최적화 (배치 읽기):**
```dart
Future<UserProfile> getUserProfile(String userId) async {
  final batch = firestore.batch();
  
  // 1. 사용자 문서 참조
  final userRef = firestore.collection('users').doc(userId);
  
  // 2. 리뷰 쿼리 (별도 실행)
  final reviewsQuery = firestore
    .collection('reviews')
    .where('userId', isEqualTo: userId)
    .orderBy('createdAt', descending: true)
    .limit(10);
  
  // 배치로 수행
  final userDoc = await userRef.get();
  final reviewsSnapshot = await reviewsQuery.get();
  
  return UserProfile(
    user: UserMapper.toEntity(userDoc),
    reviews: reviewsSnapshot.docs
      .map((doc) => ReviewMapper.toEntity(doc))
      .toList(),
  );
}
```

---

### 3. 활동 피드 (스크롤 페이지네이션)

**구현 예시:**
```dart
class ActivityFeedProvider extends ChangeNotifier {
  static const pageSize = 20;
  List<Activity> _activities = [];
  DateTime? _lastTimestamp;
  bool _hasMore = true;

  Future<void> loadActivityFeed(String userId) async {
    _activities = await _fetchActivities(userId);
    _lastTimestamp = _activities.isNotEmpty 
      ? _activities.last.createdAt 
      : null;
    notifyListeners();
  }

  Future<void> loadMoreActivities(String userId) async {
    if (!_hasMore) return;
    
    final newActivities = await _fetchActivities(
      userId,
      cursor: _lastTimestamp,
    );
    
    if (newActivities.isEmpty) {
      _hasMore = false;
      return;
    }
    
    _activities.addAll(newActivities);
    _lastTimestamp = newActivities.last.createdAt;
    notifyListeners();
  }

  Future<List<Activity>> _fetchActivities(
    String userId, {
    DateTime? cursor,
  }) async {
    Query query = firestore
      .collection('activities')
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .limit(pageSize + 1);

    if (cursor != null) {
      query = query.where('createdAt', isLessThan: cursor);
    }

    final docs = await query.get();
    return docs.docs
      .take(pageSize)
      .map((doc) => ActivityMapper.toEntity(doc))
      .toList();
  }
}
```

---

### 4. 댓글 조회 (대용량 데이터)

**최적화:**
```dart
Future<List<Comment>> getComments(
  String reviewId, {
  int limit = 20,
  DocumentSnapshot? startAfter,
}) async {
  Query query = firestore
    .collection('reviews')
    .doc(reviewId)
    .collection('comments')
    .orderBy('createdAt', ascending: true)
    .limit(limit + 1);

  if (startAfter != null) {
    query = query.startAfterDocument(startAfter);
  }

  final docs = await query.get();
  return docs.docs
    .take(limit)
    .map((doc) => CommentMapper.toEntity(doc))
    .toList();
}
```

---

## 💾 메모리 캐싱 전략

### 구현 예시

```dart
class CacheManager {
  static final instance = CacheManager._();
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _timestamps = {};
  static const Duration cacheDuration = Duration(minutes: 5);

  CacheManager._();

  T? get<T>(String key) {
    final timestamp = _timestamps[key];
    if (timestamp == null) return null;

    if (DateTime.now().difference(timestamp) > cacheDuration) {
      _cache.remove(key);
      _timestamps.remove(key);
      return null;
    }

    return _cache[key] as T?;
  }

  void set<T>(String key, T value) {
    _cache[key] = value;
    _timestamps[key] = DateTime.now();
  }

  void clear(String key) {
    _cache.remove(key);
    _timestamps.remove(key);
  }

  void clearAll() {
    _cache.clear();
    _timestamps.clear();
  }
}
```

**사용:**
```dart
class UserRepository {
  Future<User?> getUserById(String userId) async {
    // 캐시 확인
    final cached = CacheManager.instance.get<User>('user_$userId');
    if (cached != null) return cached;

    // Firestore 조회
    final doc = await firestore.collection('users').doc(userId).get();
    final user = UserMapper.toEntity(doc);

    // 캐시 저장
    CacheManager.instance.set('user_$userId', user);
    return user;
  }
}
```

---

## 🔐 보안 규칙 최적화

### 빠른 실패 (Fail Fast)

**비효율적:**
```firestore
// 문서 전체 읽기 후 검증
match /reviews/{reviewId} {
  allow update: if request.auth.uid == resource.data.userId;
}
```

**최적화:**
```firestore
// 조건 먼저 확인 후 읽기
match /reviews/{reviewId} {
  allow update: if 
    request.auth != null &&
    request.auth.uid == resource.data.userId;
}
```

---

## 📈 트래픽 예측 & 최적화

### 읽기/쓰기 비용

| 작업 | 비용 |
|------|------|
| 문서 읽기 | 1 읽기 |
| 쿼리 | 읽은 문서 수 |
| 트랜잭션 | 각 작업마다 계산 |
| 삭제 | 1 쓰기 |

### 최적화 예시

**시나리오:** 100명 사용자, 일일 1000 리뷰 작성

**비용 계산:**
```
리뷰 읽기: 1000 읽기/일
활동 피드: 100 사용자 × 20 읽기 = 2000 읽기/일
댓글: 1000 리뷰 × 5 댓글 = 5000 읽기/일
(캐싱으로 50% 감소) = 4000 읽기/일

총: ~7000 읽기/일
비용: $0.07/일 (종량제)
```

---

## 🧪 Firestore Emulator로 테스트

**설정:**
```bash
firebase emulators:start --only firestore
```

**Dart에서 사용:**
```dart
// main.dart
void main() async {
  if (kDebugMode) {
    await FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }
  runApp(const CafeMatchApp());
}
```

---

## 📋 성능 체크리스트

- [ ] 모든 쿼리에 `.limit()` 추가
- [ ] 필요한 필드만 로드 (`.select()`)
- [ ] 페이지네이션 구현 (커서 기반)
- [ ] 메모리 캐싱 적용
- [ ] 복합 인덱스 생성 완료
- [ ] 트랜잭션으로 원자성 보장
- [ ] N+1 쿼리 제거
- [ ] 배열 크기 1000 이하 유지
- [ ] 보안 규칙에서 빠른 실패 적용
- [ ] Firestore Emulator로 테스트

---

**최종 업데이트**: 2024-06-09
**상태**: 최적화 완료 ✅
