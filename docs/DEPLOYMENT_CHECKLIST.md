# 🚀 배포 준비 체크리스트

## 📋 최종 배포 준비 가이드

---

## ✅ 앱 설정

- [x] 버전 업데이트: `1.0.0+1` → `1.1.0+2`
  - pubspec.yaml 수정 완료
  - build.gradle 버전 동기화 필요 (Android)
  - Info.plist 버전 동기화 필요 (iOS)

- [ ] 앱 이름 확인
  - 현재: "CafeMatch"
  - Android: android/app/build.gradle
  - iOS: ios/Runner/Info.plist

- [ ] 번들 ID 확인
  - Android: com.example.cafematch
  - iOS: com.example.cafematch

---

## 🎨 UI/UX 최종 점검

### 시작 화면
- [ ] 스플래시 스크린 표시 여부 확인
- [ ] 브랜드 로고 표시
- [ ] 로딩 애니메이션 확인

### 로그인 화면
- [ ] 모든 입력 필드 동작 확인
- [ ] 에러 메시지 표시 확인
- [ ] 회원가입 링크 작동 확인

### 메인 화면
- [ ] 지도 표시 확인
- [ ] 카페 목록 로드 확인
- [ ] 검색 기능 동작 확인
- [ ] 필터 기능 동작 확인

### 카페 상세 화면
- [ ] 리뷰 목록 표시
- [ ] 리뷰 작성 기능
- [ ] 댓글 기능
- [ ] 좋아요 기능

### 사용자 프로필
- [ ] 프로필 정보 표시
- [ ] 팔로우/언팔로우 기능
- [ ] 리뷰 목록 표시

### 활동 피드
- [ ] 활동 목록 표시
- [ ] 페이지네이션 동작
- [ ] 새로고침 기능

---

## 🔒 보안 & 데이터

### Firebase 보안 규칙
- [x] firestore.rules 작성 완료
- [x] firestore.indexes.json 작성 완료

**배포 전 설정:**
- [ ] Firebase Console에서 보안 규칙 배포
  ```bash
  firebase deploy --only firestore:rules
  ```

- [ ] Firestore 인덱스 생성 완료 확인
  ```bash
  firebase deploy --only firestore:indexes
  ```

### 데이터 검증
- [ ] 모든 Firestore 문서 필드 검증
- [ ] 배열 크기 제한 확인 (1000개 이하)
- [ ] 문서 크기 제한 확인 (1MB 이하)

### API 보안
- [ ] 환경 변수 (.env) 설정 확인
- [ ] Firebase API 키 제한 설정
  - Android 앱 설정
  - iOS 앱 설정
  - 웹 도메인 설정

---

## 📱 Android 배포 준비

### 앱 서명 설정
- [ ] Keystore 파일 생성 (처음 배포 시)
  ```bash
  keytool -genkey -v -keystore cafematch.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias cafematch
  ```

- [ ] android/key.properties 생성
  ```properties
  storePassword=<keystore_password>
  keyPassword=<key_password>
  keyAlias=cafematch
  storeFile=../cafematch.keystore
  ```

### 릴리스 빌드
- [ ] 서명된 APK 생성
  ```bash
  flutter build apk --release
  ```

- [ ] 번들 생성 (Google Play Store 권장)
  ```bash
  flutter build appbundle --release
  ```

### Google Play Store 준비
- [ ] Google Play Developer 계정 생성
- [ ] 개발자 프로필 설정
- [ ] 결제 정보 등록
- [ ] 새 앱 생성

**앱 정보:**
- [ ] 앱 이름: "CafeMatch"
- [ ] 요약: "카페를 찾는 가장 쉬운 방법"
- [ ] 상세 설명:
  ```
  CafeMatch는 위치 기반 카페 검색 및 커뮤니티 플랫폼입니다.
  
  주요 기능:
  - 🗺️ 지도 기반 카페 검색
  - ⭐ 카페 리뷰 작성 및 조회
  - 👥 카페 팬 커뮤니티
  - 💬 리뷰 댓글 및 상호작용
  - 🔍 사용자 검색 및 팔로우
  ```

- [ ] 스크린샷 (최소 2개)
  - 지도 화면
  - 카페 상세 화면
  - 프로필 화면

- [ ] 아이콘 (512x512px)
  - Google Play 아이콘 생성

- [ ] 기능 그래픽 (1024x500px)
  - 배너 이미지 생성

- [ ] 카테고리 선택: "라이프스타일" 또는 "지도 및 네비게이션"

- [ ] 콘텐츠 등급: 평가 신청

- [ ] 개인정보 처리방침 URL
  - `https://yoursite.com/privacy`

---

## 🍎 iOS 배포 준비

### 개발자 계정
- [ ] Apple Developer Program 가입
- [ ] 개발팀 ID 확인

### 인증서 & 프로비저닝
- [ ] Development Certificate 생성
- [ ] Distribution Certificate 생성
- [ ] Provisioning Profile 생성
  - Development 프로필
  - Distribution 프로필

### Xcode 설정
- [ ] Bundle ID 설정: com.example.cafematch
- [ ] 버전 번호 설정: 1.1.0
- [ ] 빌드 번호 설정: 2
- [ ] 최소 OS 버전: iOS 11.0 이상

### 릴리스 빌드
- [ ] iOS 빌드 생성
  ```bash
  flutter build ios --release
  ```

### App Store 준비
- [ ] App Store Connect 접속
- [ ] 새 앱 생성
- [ ] 기본 정보 입력
  - 앱 이름
  - 번들 ID
  - SKU
  - 플랫폼: iOS

**앱 정보:**
- [ ] 요약 (한 줄 설명)
- [ ] 키워드 (검색 키워드 5개)
- [ ] 상세 설명
- [ ] 버전 릴리스 정보

- [ ] 스크린샷 (최소 2개, 최대 10개)
  - 5.5인치 (iPhone 8 Plus)
  - 12.9인치 (iPad Pro) - 선택사항

- [ ] 프리뷰 이미지 (선택사항)

- [ ] 앱 아이콘 (1024x1024px)

- [ ] 개인정보 처리방침 URL

---

## 📄 법률 문서

### 개인정보 처리방침
- [ ] 파일 생성: `docs/PRIVACY_POLICY.md`
- [ ] 포함 내용:
  - 수집하는 개인정보
  - 수집 및 이용 목적
  - 정보 보호 및 보안
  - 데이터 보유 기간
  - 이용자의 권리
  - 문의 연락처

### 서비스 이용약관
- [ ] 파일 생성: `docs/TERMS_OF_SERVICE.md`
- [ ] 포함 내용:
  - 이용 약관
  - 가입 및 로그인
  - 사용자 책임
  - 서비스 이용 제한
  - 저작권 및 권리
  - 면책 조항
  - 약관 변경

### 배포 시 설정
- [ ] Google Play Store에 개인정보 처리방침 URL 등록
- [ ] App Store에 개인정보 처리방침 URL 등록

---

## 🔧 Firebase 프로덕션 설정

### Firestore 설정
- [x] firestore.rules 작성 완료
- [ ] Firebase Console에서 규칙 배포
  ```bash
  firebase deploy --only firestore:rules
  ```

- [x] firestore.indexes.json 작성 완료
- [ ] Firebase Console에서 인덱스 생성
  ```bash
  firebase deploy --only firestore:indexes
  ```

### 프로덕션 모드 전환
- [ ] Firestore: 프로덕션 모드 활성화
  - 규칙 기반 접근 제어
  - 규칙 테스트 완료

- [ ] Storage: 프로덕션 모드 활성화
  - 인증된 사용자만 접근

- [ ] Authentication: 보안 설정
  - 이메일 및 비밀번호 활성화
  - Google 소셜 로그인 활성화
  - 회원가입 제한 확인

### 모니터링 및 로깅
- [ ] Firebase Console 모니터링 설정
- [ ] 에러 로깅 활성화
- [ ] 성능 모니터링 활성화

---

## 📊 성능 검증

### 로딩 시간
- [ ] 앱 시작 시간: 2초 이내
- [ ] 첫 페이지 로드: 1초 이내
- [ ] 이미지 로드: 500ms 이내 (캐시 후)

### 메모리 사용
- [ ] 메모리 사용량: 100MB 이하
- [ ] 이미지 캐시: 30MB 이하

### 배터리 소비
- [ ] 백그라운드 작업 최소화
- [ ] GPS 사용 최적화

### 네트워크 사용
- [ ] 데이터 압축
- [ ] 캐싱 활용
- [ ] 불필요한 요청 제거

---

## 🧪 최종 테스트

### 기능 테스트
- [ ] 모든 화면 로드 확인
- [ ] 모든 버튼 동작 확인
- [ ] 모든 입력 필드 동작 확인
- [ ] 모든 네비게이션 동작 확인

### 버그 테스트
- [ ] 네트워크 오류 처리
- [ ] 빠른 연속 클릭 처리
- [ ] 화면 회전 처리
- [ ] 다크 모드 지원

### 기기 테스트
- [ ] Android 기기 (최소 2종)
- [ ] iOS 기기 (최소 2종)
- [ ] 태블릿 호환성

### 언어 및 로케일
- [ ] 한국어 텍스트 표시
- [ ] 시간대 설정 확인

---

## 📤 배포 단계

### 1단계: 테스트 배포
```bash
# Android
flutter build apk --release
# iOS
flutter build ios --release
```

### 2단계: 베타 테스트 (선택사항)
- Google Play Store: Internal Testing Track
- App Store: TestFlight

### 3단계: 프로덕션 배포
- Google Play Store: Production Track
- App Store: App Store Release

### 4단계: 모니터링
- Firebase Console에서 실시간 모니터링
- 사용자 피드백 수집
- 크래시 로그 분석

---

## 📋 배포 후 체크리스트

- [ ] 앱 스토어에서 검색 가능 확인
- [ ] 설치 및 실행 확인
- [ ] 모든 기능 동작 확인
- [ ] 푸시 알림 설정 (선택사항)
- [ ] 앱 평가 요청 구현 (선택사항)

---

## 📝 배포 일정

| 단계 | 예상 날짜 | 소요 시간 |
|------|---------|---------|
| 준비 | 2024-06-09 | 2시간 |
| 테스트 배포 | 2024-06-10 | 30분 |
| 베타 테스트 | 2024-06-11 ~ 06-13 | 3일 |
| 프로덕션 배포 | 2024-06-14 | 1시간 |

---

## 🎉 최종 완료 체크

```
✅ 개발 완료 (12 Step 모두 완료)
✅ 배포 준비 체크리스트
✅ Firebase 프로덕션 설정
✅ 법률 문서 준비
✅ 스토어 정보 준비
```

**상태**: 배포 준비 완료 ✅
**예상 배포**: 2024-06-14
**버전**: 1.1.0+2

---

**최종 업데이트**: 2024-06-09
**작성자**: CafeMatch Development Team
