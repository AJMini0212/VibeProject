# 🚀 개발 환경 설정 (Setup Guide)

**소요 시간:** 5분  
**난이도:** ⭐ (매우 쉬움)  
**목표:** 코드 한 줄 입력 후 `flutter run` 실행

---

## 📋 체크리스트

```
☐ 1. Flutter SDK 설치 (2분)
☐ 2. 프로젝트 클론 (1분)
☐ 3. 환경 변수 설정 (1분)
☐ 4. 의존성 설치 (1분)
☐ 5. 기기 연결 (0분)
→ 완료! flutter run 실행 가능
```

---

## 1️⃣ Flutter SDK 설치 (2분)

### **Windows**

```bash
# 1. Flutter 공식 사이트에서 다운로드
https://flutter.dev/docs/get-started/install/windows

# 2. 압축 해제
C:\flutter\

# 3. 환경 변수 설정
# 시스템 환경 변수 → Path에 추가:
C:\flutter\bin

# 4. 검증
flutter doctor

# 출력:
# ✓ Flutter (X.X.X)
# ✓ Android Studio
# ✓ VS Code
# (몇 개 안 되면 무시해도 됨)
```

### **Mac**

```bash
# 1. Homebrew로 설치 (가장 간단)
brew install flutter

# 2. 검증
flutter doctor

# 출력:
# ✓ Flutter (X.X.X)
# ✓ Xcode
# ✓ CocoaPods
```

### **Linux**

```bash
# 1. Flutter 다운로드
git clone https://github.com/flutter/flutter.git -b stable

# 2. PATH에 추가 (~/.bashrc 또는 ~/.zshrc)
export PATH="$HOME/flutter/bin:$PATH"

# 3. 적용
source ~/.bashrc

# 4. 검증
flutter doctor
```

---

## 2️⃣ 프로젝트 클론 (1분)

```bash
# GitHub에서 클론
git clone <프로젝트_URL>

# 프로젝트 폴더로 이동
cd CafeMatch

# 브랜치 확인 (main 또는 develop)
git branch -a
```

---

## 3️⃣ 환경 변수 설정 (1분)

### **Step 1: 환경 파일 생성**

프로젝트 루트에 `.env` 파일 생성:

```bash
# Windows (PowerShell)
New-Item -Path .env

# Mac/Linux
touch .env
```

### **Step 2: API 키 추가**

`.env` 파일에 작성:

```
GOOGLE_MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY
NAVER_CLIENT_ID=YOUR_NAVER_CLIENT_ID
NAVER_CLIENT_SECRET=YOUR_NAVER_CLIENT_SECRET
FIREBASE_PROJECT_ID=YOUR_FIREBASE_PROJECT_ID
```

### **Step 3: API 키 획득**

#### **Google Maps API 키:**
1. [Google Cloud Console](https://console.cloud.google.com) 방문
2. 새 프로젝트 생성
3. "Maps SDK for Android" 활성화
4. API 키 생성
5. `.env`에 붙여넣기

#### **Naver API 키:**
1. [Naver Developer](https://developers.naver.com) 가입
2. 애플리케이션 등록
3. Client ID, Secret 복사
4. `.env`에 붙여넣기

#### **Firebase 설정:**
1. [Firebase Console](https://console.firebase.google.com) 접속
2. 프로젝트 생성
3. Android/iOS 앱 추가
4. `google-services.json` (Android) 다운로드
   - `android/app/` 폴더에 저장
5. `GoogleService-Info.plist` (iOS) 다운로드
   - Xcode에서 `ios/Runner/Runner`에 추가

### **Step 4: 환경 파일 보호**

`.gitignore`에 추가 (이미 추가되어 있어야 함):

```
.env
.env.*
google-services.json
GoogleService-Info.plist
```

---

## 4️⃣ 의존성 설치 (1분)

### **Pub 패키지 설치**

```bash
flutter pub get
```

**출력:**
```
Running "flutter pub get" in cafematch...
✓ Resolving dependencies...
✓ Installing dependencies...
✓ Generated file android/local.properties
```

### **네이티브 의존성 설치 (Android)**

```bash
# Android 프로젝트 생성/업데이트
flutter pub upgrade
```

### **네이티브 의존성 설치 (iOS)**

```bash
# iOS Pod 설치 (자동으로 되지만 문제 생기면)
cd ios
pod install
cd ..
```

---

## 5️⃣ 기기 연결

### **Android 에뮬레이터**

```bash
# 에뮬레이터 목록 확인
flutter emulators

# 에뮬레이터 시작
flutter emulators --launch emulator_name

# 또는 Android Studio에서 "Run" 클릭
```

### **iOS 시뮬레이터**

```bash
# 시뮬레이터 시작
open -a Simulator

# 또는 Xcode에서 "Run" 클릭
```

### **실제 기기**

```bash
# 기기 연결 상태 확인
flutter devices

# 출력:
# XXXXXXX (mobile) • Android (Android 12)
# iPhone 12 Pro (mobile) • iOS 15.0
```

---

## ✅ 앱 실행

### **기본 실행**

```bash
flutter run

# 또는 특정 기기에 실행
flutter run -d emulator-5554
flutter run -d iPhone
```

**출력:**
```
Launching lib/main.dart on Android device...
✓ Built build/app/outputs/flutter-app-release.apk (10.2MB).
Installing and launching...
✓ App launched successfully.
```

### **앱이 시작됨!**

```
🎉 축하합니다!
앱이 기기에서 실행되고 있습니다.

다음을 볼 수 있어야 합니다:
✓ 지도 화면 (빈 지도 또는 기본 마커)
✓ 검색 바
✓ 메뉴

문제? 아래 문제 해결 참고
```

---

## 🐛 문제 해결

### **"Flutter command not found"**

```bash
# Windows
# 시스템을 재시작하거나:
$env:Path += ";C:\flutter\bin"

# Mac/Linux
# ~/.bashrc 또는 ~/.zshrc에 추가:
export PATH="$HOME/flutter/bin:$PATH"
source ~/.bashrc
```

### **"Android SDK not found"**

```bash
# Android Studio 설치 확인
flutter doctor

# 문제 있으면:
flutter config --android-sdk <SDK_PATH>
# 예: flutter config --android-sdk ~/Library/Android/sdk
```

### **"CocoaPods dependency error" (iOS)**

```bash
cd ios
rm Podfile.lock
pod repo update
pod install
cd ..
```

### **"API 키 오류"**

```bash
# 1. .env 파일이 프로젝트 루트에 있는지 확인
ls -la | grep .env

# 2. API 키가 올바른지 확인 (복사 실수)
# 3. Firebase 프로젝트 ID 확인
firebase projects list
```

### **"Permission denied" (Mac/Linux)**

```bash
# Flutter 실행 권한 부여
chmod +x ~/flutter/bin/flutter
```

---

## 📊 개발 환경 확인

```bash
flutter doctor -v

# 출력:
# [✓] Flutter (Channel stable, x.x.x)
# [✓] Android toolchain
# [✓] Xcode
# [✓] VS Code
# [✓] Android Studio
```

**모두 ✓ 이면 완벽!**

---

## 💾 매일 사용 명령

```bash
# 최신 코드 받기
git pull

# 의존성 업데이트 (가끔)
flutter pub upgrade

# 앱 실행
flutter run

# 핫 리로드 (앱 실행 중 코드 변경 후)
r          # 앱 새로고침
R          # 앱 재시작
q          # 앱 종료
```

---

## 📚 다음 단계

1. **첫 코드 실행:** `flutter run` 성공 ✅
2. **코드 이해:** `.planning/03-architecture.md` 읽기
3. **첫 기능:** `lib/main.dart` 수정해보기
4. **테스트:** `docs/testing.md` 참고
5. **배포:** `docs/deploy.md` 참고

---

## 💡 팁

**자동으로 감시하며 개발 (코드 변경 시 자동 새로고침)**
```bash
flutter run -d <device_id> --target lib/main.dart
```

**로그 보기**
```bash
flutter logs
```

**메모리 사용량 확인**
```bash
flutter run --profile
```

---

## 📞 문제 있으면

1. 위 문제 해결 섹션 확인
2. [Flutter 공식 문서](https://flutter.dev/docs)
3. [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

**5분 안에 준비 완료!** 🚀

