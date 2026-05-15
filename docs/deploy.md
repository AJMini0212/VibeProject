# 📦 빌드 & 배포 가이드

**소요 시간:** 5분 (이해) + 30분 (빌드)  
**난이도:** ⭐⭐ (보통)  
**목표:** 앱을 Google Play와 App Store에 배포

---

## 🎯 배포 체크리스트

```
Development 단계:
☐ 코드 완성 및 테스트
☐ 버전 업데이트 (pubspec.yaml)
☐ 동작 확인 (flutter run)

Build 단계:
☐ Release 빌드 생성
☐ 서명 설정
☐ 빌드 성공 확인

Deploy 단계:
☐ Google Play에 업로드
☐ App Store에 업로드
☐ 배포 승인 대기

Post-Deploy 단계:
☐ 모니터링
☐ 사용자 피드백 수집
```

---

## 📱 배포 아키텍처

```
Local (개발자)
  ├─ Debug APK/IPA (에뮬레이터 테스트)
  ├─ Release APK/IPA (실제 기기 테스트)
  └─ Signed APK/IPA (스토어 제출)
        ↓
Google Play Console (Android)
  └─ 앱 업로드 → 검수 → 배포
        ↓
Apple App Store (iOS)
  └─ TestFlight → 검수 → 배포
```

---

## 🔐 Step 0: 서명 설정 (한 번만)

### **Android 서명 키 생성**

```bash
# 키 생성
keytool -genkey -v -keystore ~/key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias cafematch

# Windows (PowerShell):
keytool -genkey -v -keystore $env:USERPROFILE\key.jks `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias cafematch

# 비밀번호 입력 (예: CafeMatch123!)
```

### **Android 서명 구성**

`android/key.properties` 생성:

```properties
storePassword=<비밀번호>
keyPassword=<비밀번호>
keyAlias=cafematch
storeFile=<key.jks 경로>
```

**예:**
```properties
storePassword=CafeMatch123!
keyPassword=CafeMatch123!
keyAlias=cafematch
storeFile=/Users/username/key.jks
```

### **iOS 서명 인증서 (Mac에서만)**

```bash
# Xcode에서 자동 관리 (권장)
# Xcode → Preferences → Accounts
# Apple ID 추가 → 팀 선택
# 완료!
```

---

## 📦 Step 1: Release 빌드 생성

### **Android APK 생성**

```bash
# 전체 APK 빌드 (arm64, armeabi-v7a, x86_64)
flutter build apk --release

# 또는 특정 아키텍처만
flutter build apk --release --target-platform android-arm64

# 출력:
# ✓ Built build/app/outputs/flutter-app-release.apk
# APK 크기: ~50-100MB
```

### **Android App Bundle 생성 (권장)**

Google Play에 제출할 때 이것을 사용:

```bash
flutter build appbundle --release

# 출력:
# ✓ Built build/app/outputs/app-release.aab
# AAB 크기: ~30-50MB (더 작음)
```

### **iOS IPA 생성**

```bash
# iOS 빌드
flutter build ios --release

# Xcode에서 final IPA 생성
# 또는 CLI로:
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build \
  -archivePath build/Runner.xcarchive \
  archive

xcodebuild -exportArchive \
  -archivePath build/Runner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath build/ios/ipa
cd ..

# 출력:
# ✓ IPA 생성됨: build/ios/ipa/Runner.ipa
```

---

## 🚀 Step 2: Google Play에 배포 (Android)

### **2-1. Google Play Console 설정**

```
1. Google Play Console 접속
   https://play.google.com/console

2. 새 앱 만들기
   - 앱 이름: "CafeMatch"
   - 기본 카테고리: "라이프스타일"

3. 앱 서명 설정
   - "Google Play 앱 서명 사용" 선택
   - 업로드 키 등록 (앞서 생성한 key.jks)
```

### **2-2. 앱 정보 입력**

```
필수 입력사항:
☐ 앱 이름: "CafeMatch"
☐ 짧은 설명: "나의 취향에 맞는 카페와 식당을 발견하세요"
☐ 설명: "신뢰할 수 있는 리뷰 커뮤니티..."
☐ 스크린샷: 5개 최소 (1080x1920)
☐ 아이콘: 512x512px
☐ 애플리케이션 유형: "무료"
☐ 콘텐츠 등급: "모든 연령"
☐ 개인정보 보호정책 URL
```

### **2-3. AAB 파일 업로드**

```
1. Play Console → 내 앱 → 출시 관리 → 프로덕션

2. "새 출시 만들기" 클릭

3. AAB 파일 업로드
   build/app/outputs/bundle/release/app-release.aab

4. 출시 정보 입력
   - 버전: 1.0.0 (pubspec.yaml과 동일)
   - 출시 노트: "초기 버전"

5. "검수를 위해 제출" 클릭

출시 기간: 2-4시간
```

### **2-4. 프로덕션 배포**

```
검수 완료 후:
1. Play Console에서 "배포" 클릭
2. "프로덕션 출시" 선택
3. 배포 일정 선택 (즉시 또는 예약)
4. "출시" 클릭

사용자 다운로드 가능!
```

---

## 🍎 Step 3: App Store에 배포 (iOS)

### **3-1. Apple Developer 설정**

```
1. Apple Developer 계정 가입
   https://developer.apple.com

2. 개발 인증서 생성 (Xcode 자동 관리 권장)

3. Bundle ID 설정
   - 고유한 ID 필요 (예: com.jingmin.cafematch)
```

### **3-2. App Store Connect 설정**

```
1. App Store Connect 접속
   https://appstoreconnect.apple.com

2. 새 앱 만들기
   - 앱 이름: "CafeMatch"
   - 번들 ID: "com.jingmin.cafematch"
   - SKU: "cafematch.001" (자동 생성)

3. 앱 정보 입력 (Android와 동일)
```

### **3-3. TestFlight로 베타 테스트 (선택)**

```bash
# 1. Archive 생성
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build \
  archive

# 2. Transporter로 업로드
# App Store Connect → "빌드 추가"로 IPA 업로드

# 3. TestFlight에서 내부 테스트
# 앱 검수 1시간 소요
# 내부 팀이 테스트 가능
```

### **3-4. App Store에 정식 제출**

```
1. App Store Connect → 앱 정보
   ☐ 스크린샷 5개 (최소)
   ☐ 미리보기 영상 (선택사항)
   ☐ 개인정보 보호정책
   ☐ 지원 URL
   ☐ 라이선스

2. 앱 검수 제출
   App Store Connect → 버전 → "검수를 위해 제출"

3. 검수 기간: 1-2일
   (거절 시 피드백 받고 수정)

4. 승인 후 배포
   App Store Connect → "배포 대상 선택"
   → "자동 릴리스" 또는 "수동 릴리스"
```

---

## 📊 버전 관리

### **pubspec.yaml에서 버전 업데이트**

```yaml
# pubspec.yaml

version: 1.0.0+1
#        ↑ ↑
#        │ └─ 빌드 번호 (증분)
#        └── 공개 버전 번호

# 각 배포 시 업데이트
1.0.0+1  (초기)
1.0.1+2  (버그 수정)
1.1.0+3  (새 기능)
2.0.0+4  (메이저 업데이트)
```

### **배포 전 버전 확인**

```bash
# 앱이 사용 중인 버전 확인
grep "version:" pubspec.yaml

# 출력:
# version: 1.0.0+1
```

---

## 🔍 배포 후 모니터링

### **Firebase Console에서 모니터링**

```bash
# Crash 모니터링 (자동)
Firebase Console → Crashlytics
→ 크래시 리포트 확인

# 성능 모니터링
Firebase Console → Performance
→ 로딩 시간, FPS 등 확인

# 분석
Firebase Console → Analytics
→ 사용자 행동 분석
```

### **Play Console / App Store Connect 모니터링**

```
1. 다운로드 수 확인
2. 별점 & 리뷰 확인
3. 충돌 보고서 확인
4. 기기별 성능 확인
```

---

## 🐛 배포 전 체크리스트

```
코드 품질:
☐ 모든 테스트 통과 (flutter test)
☐ 린터 오류 없음 (flutter analyze)
☐ 핫 리로드 작동 확인

기능 테스트:
☐ 지도 표시 ✓
☐ 검색 기능 ✓
☐ 로그인/회원가입 ✓
☐ 리뷰 작성 ✓
☐ 팔로우 기능 ✓

성능 테스트:
☐ 로딩 시간 < 2초
☐ 스크롤 FPS > 50
☐ 메모리 사용 < 200MB
☐ 크래시 0

보안:
☐ API 키 .env 파일에 보관
☐ 민감 정보 로그 안 함
☐ HTTPS만 사용
☐ 권한 요청 명확함
```

---

## 📋 배포 타이밍

```
Week 1-2: 개발 + 로컬 테스트
    ↓
Week 3: Android TestFlight (Google Play 내부 테스트)
    ↓
Week 4: iOS TestFlight (1시간 검수)
    ↓
Week 5: App Store Connect 제출 (1-2일 검수)
    ↓
Week 6: 배포! 🎉
```

---

## 🆘 배포 문제 해결

### **"Gradle 빌드 실패"**

```bash
# Gradle 캐시 초기화
flutter clean
flutter pub get
flutter build apk --release
```

### **"App Store 거절됨"**

거절 이유 확인 → 수정 → 재제출

**일반적인 이유:**
- 앱이 실행되지 않음 → 테스트하고 수정
- API 미사용 → 사용 중임을 설명
- 개인정보 보호정책 누락 → 정책 추가
- 크래시 → Firebase Crashlytics에서 수정

### **"권한 오류"**

```bash
# iOS에서 권한 오류
# Info.plist 확인:
open ios/Runner/Info.plist

# 필수 권한:
NSLocationWhenInUseUsageDescription
NSCameraUsageDescription
NSPhotoLibraryUsageDescription
```

---

## 📞 도움이 필요할 때

```
Google Play:
https://support.google.com/googleplay/

Apple App Store:
https://help.apple.com/app-store-connect/

Flutter 배포 가이드:
https://flutter.dev/docs/deployment/
```

---

## ✅ 첫 배포 체크리스트

```
☐ Google Play Console 계정 생성
☐ Apple Developer 계정 생성
☐ Android 서명 키 생성
☐ iOS 인증서 설정
☐ pubspec.yaml 버전 업데이트
☐ 로컬 테스트 완료 (flutter test)
☐ Release 빌드 생성
☐ AAB/IPA 파일 생성
☐ Google Play에 업로드
☐ App Store Connect에 업로드
☐ 검수 기다리기
☐ 배포!

완료하면 사용자가 앱 다운로드 가능! 🚀
```

