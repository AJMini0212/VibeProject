# CafeMatch

위치 기반 카페 추천 애플리케이션 (4-layer Clean Architecture)

## 🚀 시작하기

### 필수 사항
- Flutter SDK 3.11.3+
- Dart 3.11.3+
- Chrome (웹 개발용)

### 환경 설정

#### 1. 환경변수 설정 (.env 파일)

프로젝트 루트에 `.env` 파일을 생성하세요:

```bash
cp .env.example .env
```

그리고 다음 API 키를 입력하세요:

```env
# Naver Place API (검색/위치 정보)
NAVER_CLIENT_ID=your_naver_client_id
NAVER_CLIENT_SECRET=your_naver_client_secret

# Google Maps API (지도 표시)
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

#### 2. API 키 발급

**Naver API 설정:**
1. [Naver Developers](https://developers.naver.com)에서 애플리케이션 등록
2. "검색" 서비스 추가
3. Client ID / Secret 복사

**Google Maps API 설정:**
1. [Google Cloud Console](https://console.cloud.google.com)에서 프로젝트 생성
2. Maps JavaScript API 활성화
3. API 키 생성

#### 3. Web 환경 설정

API 키가 변경되었으면 `web/index.html`을 재생성하세요:

**PowerShell (Windows):**
```powershell
.\scripts\build-web-index.ps1
```

**Bash (macOS/Linux):**
```bash
node scripts/build-web-index.js
```

### 앱 실행

```bash
# 의존성 설치
flutter pub get

# Chrome에서 실행
flutter run -d chrome

# 또는 웹 서버에서 실행
flutter run -d web-server
```

## 📁 프로젝트 구조

```
lib/
├── main.dart                           # 앱 시작점
├── config/                             # 설정
│   └── app_theme.dart                 # Material 3 테마
├── core/                               # 핵심 기능
│   └── services/
│       └── location_service.dart       # GPS 위치 서비스
├── data/                               # 데이터 계층
│   ├── datasources/
│   │   ├── naver_api_client.dart      # Naver API HTTP 클라이언트
│   │   ├── naver_place_converter.dart # API 응답 변환
│   │   ├── cafe_local_datasource.dart # 로컬 캐시 인터페이스
│   │   └── hive_cafe_local_datasource.dart  # Hive 캐시 구현
│   ├── models/
│   │   └── cafe_model.dart            # CafeModel
│   ├── mappers/
│   │   └── cafe_mapper.dart           # Model → Entity 변환
│   └── repositories/
│       └── cafe_repository_impl.dart   # CafeRepository 구현
├── domain/                             # 도메인 계층
│   ├── entities/
│   │   └── cafe.dart                  # Cafe 엔티티
│   └── repositories/
│       └── cafe_repository.dart       # CafeRepository 추상
├── application/                        # 애플리케이션 계층
│   └── cafe/
│       └── search_cafes_use_case.dart # 카페 검색 UseCase
├── presentation/                       # 프레젠테이션 계층
│   ├── providers/
│   │   └── home_provider.dart         # 상태 관리 (Provider)
│   └── screens/
│       └── home/
│           ├── home_screen.dart       # 홈 화면
│           └── widgets/
│               └── map_widget.dart    # Google Maps 위젯
└── di/
    └── injection.dart                 # 의존성 주입 설정
```

## 🏗️ 아키텍처

### 4-Layer Clean Architecture

```
┌─────────────────────────────────┐
│   Presentation (UI/Providers)   │  - Flutter Widgets
│   - HomeScreen, MapWidget        │  - Provider State Management
├─────────────────────────────────┤
│   Application (UseCases)         │  - Business Logic Coordination
│   - SearchCafesUseCase           │  - Domain 계층과 Data 계층 연결
├─────────────────────────────────┤
│   Domain (Entities/Repositories) │  - Business Rules
│   - Cafe Entity                  │  - Abstract Repository Interfaces
│   - CafeRepository Interface     │  - Independent of Frameworks
├─────────────────────────────────┤
│   Data (Models/Mappers)          │  - External APIs, Databases
│   - CafeModel, NaverApiClient    │  - Repository Implementations
│   - LocalDatasource (Hive)       │  - Data Transformations
└─────────────────────────────────┘
```

## 🔄 데이터 흐름

```
사용자
  ↓
HomeScreen (UI)
  ↓
HomeProvider (상태 관리)
  ↓
SearchCafesUseCase (비즈니스 로직)
  ↓
CafeRepositoryImpl (데이터 조회)
  ├→ HiveCafeLocalDatasource (캐시 확인)
  └→ NaverApiClient (API 호출)
  ↓
Naver Place API / Local Cache (Hive)
```

## 📋 현재 구현 상태

### Phase 1: 기본 기능 (진행 중)

- ✅ **Phase 1.1**: 4-layer 아키텍처 + HomeScreen (mock 데이터)
- ✅ **Phase 1.2**: Google Maps 통합 + TabBar 인터페이스
- ✅ **Phase 1.3**: Naver Place API 통합 + 오프라인 캐싱
- ⏳ **Phase 1.4**: 검색 & 필터링 UI
- ⏳ **Phase 1.5**: 카페 상세 페이지

### Phase 2: 사용자 기능
- Firebase 인증
- 리뷰 & 평가 기능
- 사용자 프로필

### Phase 3: 소셜 기능
- 카페 공유
- 친구 추천
- 앱 배포

## 🛠️ 주요 의존성

| 패키지 | 버전 | 용도 |
|--------|------|------|
| flutter | SDK | Flutter 프레임워크 |
| provider | ^6.0.0 | 상태 관리 |
| get_it | ^7.6.0 | 의존성 주입 |
| google_maps_flutter | ^2.5.0 | 구글 맵 표시 |
| location | ^5.0.0 | GPS 위치 서비스 |
| hive | ^2.2.3 | 로컬 데이터 캐싱 |
| http | ^1.1.0 | HTTP 요청 |
| flutter_dotenv | ^5.1.0 | 환경변수 관리 |
| crypto | ^3.0.0 | 해시 함수 |

## 📝 커밋 컨벤션

```
feat: 새로운 기능
fix: 버그 수정
refactor: 코드 리팩토링
docs: 문서 수정
style: 코드 스타일 변경
```

## 🐛 트러블슈팅

### "Cannot read properties of undefined (reading 'maps')"
→ `web/index.html`에서 Google Maps API가 로드되었는지 확인하세요.

### ".env 파일을 찾을 수 없음"
→ 프로젝트 루트에 `.env` 파일이 있는지 확인하세요.

### "API 키 오류 - Naver API 설정을 확인하세요"
→ `.env` 파일의 NAVER_CLIENT_ID/SECRET이 정확한지 확인하세요.

## 📞 문의

프로젝트 관련 문의는 이슈를 등록해주세요.

---

**Last Updated**: 2026-05-26
**Flutter Version**: ^3.11.3
**Status**: Phase 1.3 진행 중 ✅
