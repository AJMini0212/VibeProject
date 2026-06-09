# 📱 CafeMatch 배포 가이드

**최종 버전**: 1.1.0+2  
**배포 날짜**: 2024-06-14  
**작성일**: 2024-06-09

---

## 🎯 배포 개요

CafeMatch 앱을 Google Play Store와 Apple App Store에 배포하기 위한 완전한 가이드입니다.

### 배포 일정

| 단계 | 예상 날짜 | 소요 시간 |
|------|---------|---------|
| 최종 준비 | 2024-06-09 | 2시간 |
| 테스트 배포 | 2024-06-10 | 30분 |
| 베타 테스트 | 2024-06-11~13 | 3일 |
| 프로덕션 배포 | 2024-06-14 | 1시간 |

---

## 📋 배포 전 최종 확인사항

### 코드 검증
```bash
# Flutter 정적 분석
flutter analyze

# 테스트 실행
flutter test

# 빌드 검증
flutter build apk --release
flutter build ios --release
```

### 버전 확인
```yaml
# pubspec.yaml
version: 1.1.0+2

# android/app/build.gradle
versionCode 2
versionName "1.1.0"

# ios/Runner/Info.plist
CFBundleShortVersionString: 1.1.0
CFBundleVersion: 2
```

### 환경 설정
```bash
# .env 파일 확인
cat .env

# Firebase 프로덕션 설정 확인
firebase apps:list
```

---

## 🚀 Android 배포 프로세스

### 1단계: Google Play Developer 계정 설정

**계정 생성:**
1. [Google Play Developer Console](https://play.google.com/console) 접속
2. "앱 만들기" 클릭
3. 기본 정보 입력
   - 앱 이름: "CafeMatch"
   - 기본 언어: 한국어

**개발자 프로필:**
- 개발자 이름: CafeMatch Development
- 이메일: developer@cafematch.example.com
- 주소: 한국

**결제:**
- 등록 수수료: $25 (일회)
- 결제 정보 입력

### 2단계: 앱 서명 설정

**Keystore 생성:**
```bash
# 키스토어 생성 (처음 배포 시)
keytool -genkey -v -keystore cafematch.keystore \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias cafematch

# 입력할 정보:
# - Password: [강력한 비밀번호]
# - CN (이름): CafeMatch
# - OU (부서): Development
# - O (조직): CafeMatch
# - L (도시): Seoul
# - ST (주): Seoul
# - C (국가): KR
```

**Gradle 설정:**
```gradle
// android/app/build.gradle
signingConfigs {
  release {
    keyAlias 'cafematch'
    keyPassword '[keystore_password]'
    storeFile file('../cafematch.keystore')
    storePassword '[keystore_password]'
  }
}

buildTypes {
  release {
    signingConfig signingConfigs.release
  }
}
```

### 3단계: 릴리스 빌드 생성

**APK 생성:**
```bash
flutter build apk --release
# 생성 위치: build/app/outputs/flutter-apk/app-release.apk
```

**App Bundle 생성 (권장):**
```bash
flutter build appbundle --release
# 생성 위치: build/app/outputs/bundle/release/app-release.aab
```

### 4단계: Google Play Store 정보 입력

**앱 정보:**
- 앱 이름: CafeMatch
- 요약: 카페를 찾는 가장 쉬운 방법
- 상세 설명:
  ```
  CafeMatch는 위치 기반 카페 검색 및 커뮤니티 플랫폼입니다.
  
  🗺️ 주요 기능:
  - 지도 기반 카페 검색
  - 카페 리뷰 작성 및 공유
  - 카페 팬 커뮤니티 활동
  - 사용자 팔로우 및 활동 피드
  - 리뷰 댓글 및 상호작용
  
  ⭐ CafeMatch와 함께 완벽한 카페를 찾으세요!
  ```

**스크린샷 (최소 2개):**
1. 지도 화면 (1080×1920px)
2. 카페 상세 화면 (1080×1920px)
3. 프로필 화면 (1080×1920px) - 선택

**아이콘:**
- 512×512px PNG 파일
- 배경 투명도 가능
- 회귀 각도 없음

**기능 그래픽 (필수):**
- 1024×500px PNG 파일
- 앱의 주요 기능을 한눈에 보여주는 이미지

**카테고리:** 라이프스타일 또는 지도 및 네비게이션

**콘텐츠 등급:** 평가 신청

**개인정보 처리방침:** https://yoursite.com/privacy

### 5단계: 번들 업로드

**내부 테스트 트랙:**
1. "테스트 트랙" → "내부 테스트" 선택
2. App Bundle 업로드
3. 릴리스 이름: "1.1.0 (Build 2) - Internal Test"
4. 테스트 계정 추가 (이메일)
5. "저장 및 검토" 클릭

**베타 테스트 (선택사항):**
1. "테스트 트랙" → "베타" 선택
2. 동일하게 업로드
3. 테스터 초대 링크 생성
4. 피드백 수집 (최소 3일)

**프로덕션:**
1. "프로덕션" 트랙 선택
2. App Bundle 업로드
3. 릴리스 정보: "v1.1.0 - 소셜 기능 추가"
4. "검토를 위해 제출" 클릭

### 6단계: 심사 및 배포

**Google Play 검사:**
- 소요 시간: 보통 3-5시간 (최대 24시간)
- 검사 항목:
  - 보안 규칙 확인
  - 개인정보 처리방침 확인
  - 콘텐츠 등급 확인
  - 정책 위반 확인

**배포 단계:**
1. 검사 통과 → "승인됨" 상태
2. "모든 기기에 출시" 클릭
3. 2-3시간 내 모든 기기에 배포 완료

---

## 🍎 iOS 배포 프로세스

### 1단계: Apple Developer 계정 설정

**계정 생성:**
1. [Apple Developer Program](https://developer.apple.com) 가입
2. 연간 등록료: $99
3. 개발팀 ID 확인

**기본 정보:**
- 팀 이름: CafeMatch Development
- 팀 ID: [발급받은 ID]

### 2단계: 인증서 & 프로비저닝 프로필 생성

**Development 인증서:**
1. Apple Developer → Certificates, IDs & Profiles
2. "Certificates" → "+" 클릭
3. "iOS App Development" 선택
4. CSR 파일 업로드
5. 인증서 다운로드 및 설치

**Distribution 인증서:**
1. 동일하게 진행
2. "App Store and Ad Hoc" 선택
3. 인증서 다운로드

**App ID 생성:**
1. "Identifiers" → "+" 클릭
2. "App IDs" 선택
3. Bundle ID: `com.example.cafematch`
4. 기능 선택:
   - Push Notifications
   - HealthKit
   - HomeKit
   - 등등

**Provisioning Profile 생성:**
1. "Profiles" → "+" 클릭
2. Distribution 선택 → App Store
3. 인증서 및 App ID 선택
4. Profile 다운로드

### 3단계: Xcode 설정

**프로젝트 설정:**
```
Xcode → ios/Runner.xcworkspace 열기

General 탭:
- Bundle Identifier: com.example.cafematch
- Version: 1.1.0
- Build: 2
- Team: [개발팀 선택]

Signing & Capabilities:
- Team: [개발팀]
- Provisioning Profile: [선택]
```

### 4단계: 릴리스 빌드 생성

```bash
# iOS 빌드
flutter build ios --release

# Xcode에서 최종 빌드
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build \
  -arch arm64
```

### 5단계: App Store Connect 설정

**앱 정보:**
1. [App Store Connect](https://appstoreconnect.apple.com) 로그인
2. "My Apps" → "+" → "New App"
3. 기본 정보 입력
   - 앱 이름: CafeMatch
   - 번들 ID: com.example.cafematch
   - SKU: cafematch-1.1.0

**앱 정보 상세:**
- 요약: 카페를 찾는 가장 쉬운 방법
- 키워드: 카페, 리뷰, 지도, 검색, 커뮤니티
- 설명: Android와 동일
- 스크린샷: 최소 2개 (5.5" 화면 기준)
- 미리보기: 선택사항
- 프로모션 텍스트: v1.1.0 신기능 소개

**앱 아이콘:**
- 1024×1024px PNG
- JPG 불가

**개인정보 처리방침:**
- URL: https://yoursite.com/privacy

### 6단계: 앱 제출

**버전 정보:**
1. "버전 1.1.0" 선택
2. 빌드 선택: 생성한 빌드 선택
3. 콘텐츠 등급: 평가 답변
4. 내용 경고: 필요시 선택

**제출:**
1. "검토를 위해 제출" 클릭
2. 내보내기 규정 확인
3. 광고 ID 확인
4. 최종 제출

**심사:**
- 소요 시간: 보통 1-2일
- 상태 확인: App Store Connect의 "활동" 탭

---

## 🛠️ 배포 후 확인사항

### 배포 완료 후

- [ ] 스토어에서 앱 검색 가능 확인
- [ ] 앱 설치 및 실행 확인
- [ ] 모든 기능 정상 동작 확인
- [ ] 버전 정보 확인 (1.1.0+2)
- [ ] Firebase 연결 확인
- [ ] Firestore 데이터 접근 확인

### 모니터링

```bash
# Firebase Console 모니터링
https://console.firebase.google.com

# 확인 항목:
- Performance Monitoring
- Crashlytics (충돌 리포트)
- Authentication (로그인 통계)
- Firestore (데이터베이스 통계)
- Analytics (사용자 분석)
```

### 피드백 수집

- [ ] Google Play/App Store 리뷰 확인
- [ ] 앱 내 고객 지원 문의 모니터링
- [ ] 사용자 피드백 기반 버그 수정

---

## 📊 배포 성공 지표

| 지표 | 목표 | 현재 |
|------|------|------|
| 앱 설치 | 100+ | - |
| 일일 활성 사용자 | 10+ | - |
| 평균 평점 | 4.0+ | - |
| 크래시율 | 0.1% 이하 | - |

---

## 🆘 문제 해결

### 배포 거부 시

**일반적인 거부 사유:**
1. 개인정보 처리방침 미등재
   - 해결: 정책 URL 추가

2. 보안 규칙 미설정
   - 해결: firestore.rules 배포

3. 부적절한 콘텐츠
   - 해결: 콘텐츠 검증 및 수정

4. API 키 노출
   - 해결: 환경 변수 설정 확인

### 배포 후 문제

**앱 충돌:**
1. Firebase Crashlytics 확인
2. 로그 분석
3. 긴급 패치 배포

**성능 저하:**
1. Firebase Performance Monitoring 확인
2. 병목 지점 식별
3. 최적화 및 업데이트

---

## 📞 지원 연락처

| 항목 | 연락처 |
|------|--------|
| 일반 문의 | support@cafematch.example.com |
| 기술 지원 | tech@cafematch.example.com |
| 개인정보 | privacy@cafematch.example.com |
| 전화 | 02-000-0000 |

---

**배포 준비 완료!** 🎉

다음 명령어로 최종 확인하세요:

```bash
flutter clean
flutter pub get
flutter analyze
flutter build apk --release
flutter build ios --release
```

행운을 빕니다! 🚀
