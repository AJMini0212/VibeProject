# 🧪 테스트 가이드

**소요 시간:** 5분 (이해) + 시간 (작성)  
**난이도:** ⭐⭐ (보통)  
**목표:** 버그 없는 안정적인 앱 만들기

---

## 🎯 테스트 체계

```
Unit Test (단위 테스트)
├─ 개별 함수/클래스 테스트
├─ 가장 빠름 (ms 단위)
└─ 예: 검색 함수가 올바른 결과를 반환하는가?

Widget Test (위젯 테스트)
├─ UI 컴포넌트 테스트
├─ 빠름 (1-5초)
└─ 예: 버튼을 누르면 화면이 바뀌는가?

Integration Test (통합 테스트)
├─ 전체 앱 흐름 테스트
├─ 느림 (1-10분)
└─ 예: 로그인 → 검색 → 리뷰 작성이 정상 작동하는가?
```

---

## 📁 테스트 파일 구조

```
project/
├── lib/
│   ├── domain/
│   ├── presentation/
│   └── data/
│
└── test/              ← 테스트 파일
    ├── unit/
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    │
    ├── widget/
    │   └── screens/
    │
    └── integration/
        └── app_test.dart
```

---

## 1️⃣ Unit Test (단위 테스트)

### **테스트 파일 만들기**

`test/unit/domain/usecases/search_cafes_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cafematch/domain/entities/cafe.dart';
import 'package:cafematch/domain/usecases/search_cafes_usecase.dart';
import 'package:mockito/mockito.dart';

// Mock 생성
class MockCafeRepository extends Mock implements CafeRepository {}

void main() {
  group('SearchCafesUseCase', () {
    late SearchCafesUseCase useCase;
    late MockCafeRepository mockRepository;

    setUp(() {
      mockRepository = MockCafeRepository();
      useCase = SearchCafesUseCase(mockRepository);
    });

    test('카페 검색이 결과를 반환한다', () async {
      // Arrange: 테스트 데이터 준비
      final mockCafes = [
        Cafe(
          id: '1',
          name: '스타벅스',
          address: '서울시 강남구',
          latitude: 37.4979,
          longitude: 127.0276,
          category: 'cafe',
        ),
      ];

      when(mockRepository.searchNearby(
        any,
        any,
        any,
      )).thenAnswer((_) async => mockCafes);

      // Act: 함수 실행
      final result = await useCase.execute(
        latitude: 37.4979,
        longitude: 127.0276,
        radiusKm: 5.0,
      );

      // Assert: 결과 확인
      expect(result, mockCafes);
      expect(result.first.name, '스타벅스');
    });

    test('API 오류 시 예외를 발생시킨다', () async {
      // 예외 발생 시뮬레이션
      when(mockRepository.searchNearby(
        any,
        any,
        any,
      )).thenThrow(Exception('API Error'));

      // 예외 발생 확인
      expect(
        () => useCase.execute(
          latitude: 37.4979,
          longitude: 127.0276,
          radiusKm: 5.0,
        ),
        throwsException,
      );
    });
  });
}
```

### **테스트 실행**

```bash
# 특정 테스트 파일 실행
flutter test test/unit/domain/usecases/search_cafes_test.dart

# 모든 Unit 테스트 실행
flutter test test/unit/

# 출력:
# ✓ SearchCafesUseCase
#   ✓ 카페 검색이 결과를 반환한다 (45ms)
#   ✓ API 오류 시 예외를 발생시킨다 (28ms)
#
# 2 tests, 0 failures
```

---

## 2️⃣ Widget Test (위젯 테스트)

### **화면 테스트**

`test/widget/screens/home_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cafematch/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('지도가 표시된다', (WidgetTester tester) async {
      // Arrange: 앱 구성
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => HomeProvider(),
              ),
            ],
            child: const HomeScreen(),
          ),
        ),
      );

      // Act: 화면 로드 대기
      await tester.pumpAndSettle();

      // Assert: 지도가 있는지 확인
      expect(find.byKey(const Key('map_widget')), findsOneWidget);
    });

    testWidgets('검색 버튼이 있다', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => HomeProvider(),
              ),
            ],
            child: const HomeScreen(),
          ),
        ),
      );

      // 검색 버튼 찾기
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('검색 버튼을 누르면 검색 화면이 열린다',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => HomeProvider(),
              ),
            ],
            child: const HomeScreen(),
          ),
        ),
      );

      // Act: 검색 버튼 탭
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Assert: 검색 화면 표시 확인
      expect(find.byType(SearchScreen), findsOneWidget);
    });
  });
}
```

### **테스트 실행**

```bash
# Widget 테스트 실행
flutter test test/widget/

# 출력:
# ✓ HomeScreen
#   ✓ 지도가 표시된다 (512ms)
#   ✓ 검색 버튼이 있다 (284ms)
#   ✓ 검색 버튼을 누르면 검색 화면이 열린다(645ms)
#
# 3 tests, 0 failures
```

---

## 3️⃣ Integration Test (통합 테스트)

### **전체 앱 흐름 테스트**

`integration_test/app_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cafematch/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('전체 앱 통합 테스트', () {
    testWidgets('앱 시작 → 검색 → 상세보기 → 리뷰 작성 흐름',
        (WidgetTester tester) async {
      // 앱 시작
      app.main();
      await tester.pumpAndSettle();

      // 1. 홈 화면이 표시되는가?
      expect(find.byType(MaterialApp), findsOneWidget);

      // 2. 검색 필드 입력
      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), '카페');
      await tester.pumpAndSettle();

      // 3. 검색 결과가 표시되는가?
      expect(find.byType(ListView), findsWidgets);

      // 4. 첫 번째 결과 탭
      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      // 5. 상세 화면이 표시되는가?
      expect(find.byType(DetailScreen), findsOneWidget);

      // 6. "리뷰 작성" 버튼 탭
      await tester.tap(find.byIcon(Icons.rate_review));
      await tester.pumpAndSettle();

      // 7. 리뷰 작성 화면이 표시되는가?
      expect(find.byType(ReviewForm), findsOneWidget);

      // 8. 리뷰 작성
      await tester.tap(find.byIcon(Icons.star)); // 별점 선택
      await tester.enterText(
        find.byType(TextField),
        '좋은 카페입니다',
      );

      // 9. 제출 버튼 탭
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 10. 완료 메시지가 표시되는가?
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
```

### **통합 테스트 실행**

```bash
# 실제 기기/에뮬레이터에서 실행
flutter test integration_test/app_test.dart

# 또는
flutter drive --target=integration_test/app_test.dart

# 출력:
# 앱이 실제로 실행되며 테스트 진행
# ✓ 전체 앱 통합 테스트
#   ✓ 앱 시작 → 검색 → 상세보기 → 리뷰 작성 흐름 (5.2s)
```

---

## 🏗️ 테스트 작성 규약

### **파일 이름**
```
snake_case + _test.dart

✓ search_cafes_test.dart
✓ home_screen_test.dart
✗ SearchCafesTest.dart
```

### **테스트 그룹화**
```dart
void main() {
  group('HomeProvider', () {
    group('searchCafes', () {
      test('결과를 반환한다', () { ... });
      test('오류를 처리한다', () { ... });
    });
  });
}
```

### **테스트 이름**
```dart
// ✓ 좋은 예: 명확하고 한글 가능
test('사용자가 팔로우하면 followerCount가 증가한다', () { ... });
test('API 오류 시 에러 메시지를 표시한다', () { ... });

// ✗ 나쁜 예: 모호함
test('works', () { ... });
test('test_follow', () { ... });
```

### **AAA 패턴 (Arrange-Act-Assert)**
```dart
test('example', () {
  // Arrange: 테스트 준비
  final data = prepareTestData();
  
  // Act: 실행
  final result = doSomething(data);
  
  // Assert: 검증
  expect(result, expectedValue);
});
```

---

## 🚀 테스트 자동화

### **모든 테스트 실행**

```bash
# 모든 테스트 (Unit + Widget)
flutter test

# 특정 패턴 테스트
flutter test --name "SearchCafes"

# 테스트 커버리지 생성
flutter test --coverage

# 출력:
# Coverage report: coverage/lcov.info
# Coverage percentage: 75%
```

### **CI/CD에서 자동 실행**

GitHub Actions 예시 (`.github/workflows/test.yml`):

```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        
      - name: Get dependencies
        run: flutter pub get
        
      - name: Run tests
        run: flutter test
        
      - name: Upload coverage
        uses: codecov/codecov-action@v1
```

---

## 📊 테스트 체크리스트

```
Unit Tests:
☐ 각 UseCase 테스트
☐ Repository 실패 경우 테스트
☐ 데이터 변환 테스트
☐ 오류 처리 테스트

Widget Tests:
☐ 각 화면 표시 확인
☐ 버튼 클릭 동작 테스트
☐ 입력 필드 입력 테스트
☐ 오류 메시지 표시 테스트

Integration Tests:
☐ 전체 사용자 흐름
☐ 로그인 → 사용 → 로그아웃
☐ 인터넷 끊김 시나리오

Coverage:
☐ 전체 커버리지 > 70%
☐ 핵심 비즈니스 로직 100%
```

---

## 🐛 Mock 및 Stub

### **Mock이란?**
```dart
// Mock: 동작을 기록하고 검증
class MockCafeRepository extends Mock implements CafeRepository {
  @override
  Future<List<Cafe>> searchNearby(double lat, double lng) async {
    return [Cafe(...), Cafe(...)];
  }
}

// 검증
verify(mockRepository.searchNearby(any, any)).called(1);
```

### **Stub이란?**
```dart
// Stub: 특정 값을 반환하도록 설정
when(mockRepository.searchNearby(any, any))
  .thenAnswer((_) async => [Cafe(...)]);

// 예외 발생
when(mockRepository.searchNearby(any, any))
  .thenThrow(Exception('Network error'));
```

---

## 📈 테스트 커버리지

```bash
# 커버리지 생성
flutter test --coverage

# 커버리지 확인
lcov --summary coverage/lcov.info

# HTML 리포트 생성 (Mac/Linux)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**목표:** 
- 전체: > 70%
- 비즈니스 로직: > 90%
- UI: > 50%

---

## 🔧 일반적인 테스트 패턴

### **Provider 테스트**
```dart
test('리뷰 추가 시 리스트가 업데이트된다', () {
  final provider = ReviewProvider(mockUseCase);
  
  provider.addReview(review);
  
  expect(provider.reviews.length, 1);
  expect(provider.reviews.first, review);
});
```

### **Firestore 데이터 테스트**
```dart
test('Firebase에서 리뷰를 가져온다', () async {
  final dataSource = FirebaseReviewDataSource();
  
  final reviews = await dataSource.getReviews('cafeId');
  
  expect(reviews, isNotEmpty);
  expect(reviews.first.cafeId, 'cafeId');
});
```

---

## 💡 테스트 팁

```
1. 작게 시작하기
   ✓ 한 가지 기능만 테스트
   
2. 독립적으로 만들기
   ✓ 다른 테스트와 무관하게
   
3. 빠르게 하기
   ✓ Mock 사용으로 외부 의존 제거
   
4. 명확하게 하기
   ✓ 한국어로 설명적인 이름
   
5. 자동화하기
   ✓ CI/CD에서 자동 실행
```

---

## 📞 문제 해결

### **"테스트가 타임아웃됨"**
```dart
// 테스트 타임아웃 증가
testWidgets('...',
  (WidgetTester tester) async {
    // ...
  },
  timeout: const Timeout(Duration(seconds: 10)),
);
```

### **"Mock이 작동하지 않음"**
```bash
# pubspec.yaml에 mockito 추가
dev_dependencies:
  mockito: ^5.0.0
  build_runner: ^2.0.0

# 코드 생성
flutter pub run build_runner build
```

### **"Firebase 테스트 실패"**
```dart
// Firebase Emulator 사용
setUp(() {
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
});
```

---

## ✅ 테스트 배포 조건

```
배포 전 필수:
☐ flutter test 모두 통과
☐ flutter analyze 오류 없음
☐ 커버리지 > 70%
☐ Integration test 통과

배포 후:
☐ Firebase Crashlytics 모니터링
☐ 사용자 피드백 수집
☐ 버그 리포트 확인
```

---

## 📚 더 알아보기

- [Flutter 테스팅 문서](https://flutter.dev/docs/testing)
- [Mockito 문서](https://pub.dev/packages/mockito)
- [Integration Testing](https://flutter.dev/docs/testing/integration-tests)

**테스트 코드 = 버그 없는 앱!** 🚀

