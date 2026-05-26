# CafeMatch 프로젝트 대시보드

카페/식당 추천 앱 **CafeMatch** 프로젝트의 진행상황을 한눈에 확인할 수 있는 GitHub Pages 대시보드입니다.

## 🌐 접속 방법

이 페이지는 GitHub Pages를 통해 호스팅됩니다.

**GitHub Pages URL**: [https://AJMini0212.github.io/VibeProject](https://AJMini0212.github.io/VibeProject)

또는 아래의 로컬 파일로 접속할 수 있습니다:

```bash
# 프로젝트 루트에서
open docs/index.html
```

## 📄 페이지 구성

- **📊 [개요](index.html)** - 프로젝트 전체 개요 및 비전
- **📋 [WBS](wbs.html)** - Work Breakdown Structure (상세 작업 분류)
- **📅 [일정](schedule.html)** - 6주 프로젝트 일정 및 위험 관리
- **📈 [진행현황](progress.html)** - 실시간 진행도 추적 대시보드

## 🎯 프로젝트 개요

| 항목 | 내용 |
|------|------|
| **프로젝트명** | CafeMatch |
| **플랫폼** | Flutter (iOS/Android/Web) |
| **개발 기간** | 6주 (10-15주차) |
| **총 시간** | 60-70시간 |
| **Phase** | 3단계 (지도/검색 → 리뷰/인증 → 소셜/배포) |

## 📊 Phase 분류

### Phase 1: 지도 & 검색 (MVP) - 14시간
- **기간**: 10-11주차
- **목표**: 기본 검색과 브라우징 기능 완성
- **주요 기능**: Google Maps, Naver API, 검색/필터링

### Phase 2: 리뷰 & 인증 - 18시간
- **기간**: 12-13주차
- **목표**: 사용자 시스템과 리뷰 커뮤니티 구현
- **주요 기능**: Firebase 인증, 리뷰 시스템, 이미지 처리

### Phase 3: 소셜 & 배포 - 20시간+
- **기간**: 14-15주차
- **목표**: 커뮤니티 기능 완성 및 배포
- **주요 기능**: 팔로우, 피드, 배포 및 모니터링

## 📈 현재 진행 상태

- **현재 주차**: 10주차
- **전체 완료도**: 15%
- **완료한 Task**: 10 / 52

## 🔗 관련 링크

- **GitHub Repository**: [https://github.com/AJMini0212/VibeProject](https://github.com/AJMini0212/VibeProject)
- **프로젝트 계획 (.planning/)**: 프로젝트 루트의 `.planning/` 폴더 참고
- **아키텍처 문서**: `.planning/03-architecture.md`

## 🛠️ 기술 스택

### Frontend
- Flutter (다중 플랫폼)
- Provider (상태 관리)
- Google Maps Flutter

### Backend
- Firebase Authentication
- Cloud Firestore
- Firebase Storage

### External APIs
- Naver Place API
- Google Maps API

### Local Storage
- Hive (캐싱)
- GetIt (의존성 주입)
- SharedPreferences

## 📝 개발 환경

```bash
# 프로젝트 실행
flutter run -d chrome

# 빌드
flutter build web

# 테스트
flutter test
```

## 📞 문의사항

프로젝트에 대한 질문이나 피드백은 GitHub Issues를 통해 주시기 바랍니다.

---

마지막 업데이트: 2026-05-26
