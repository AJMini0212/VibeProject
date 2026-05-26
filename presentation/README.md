# CafeMatch 중간발표 자료

위치 기반 카페 추천 애플리케이션 - 4-Layer Clean Architecture 발표자료

## 📂 파일 구조

```
presentation/
├── index.html          # 발표자료 (PPT 스타일)
└── README.md           # 이 파일
```

## 🚀 사용 방법

### 1. 브라우저에서 열기
```bash
# 프로젝트 루트에서
open presentation/index.html

# 또는 웹 서버에서
python -m http.server 8000
# http://localhost:8000/presentation/index.html
```

### 2. 슬라이드 네비게이션

| 조작 | 설명 |
|------|------|
| **← 이전 버튼** | 이전 슬라이드로 이동 |
| **다음 → 버튼** | 다음 슬라이드로 이동 |
| **← 키** | 이전 슬라이드 (키보드) |
| **→ 키** | 다음 슬라이드 (키보드) |

## 📋 슬라이드 구성

| # | 제목 | 내용 |
|----|------|------|
| 1 | 타이틀 | CafeMatch 프로젝트 소개 |
| 2 | 비전 & 미션 | 프로젝트의 목표와 미션 |
| 3 | 현재 문제점 | 정보 분산, 낮은 접근성, 신뢰성 부족 |
| 4 | 우리의 해결 방안 | 위치 기반 검색, API 통합, 캐싱, 리뷰 |
| 5 | 4-Layer 아키텍처 | Presentation → Application → Domain → Data |
| 6 | 기술 스택 | Flutter, Google Maps, Naver API, Hive 등 |
| 7 | 현재 진행 상황 | Phase 1 (완료), Phase 2 (진행중), Phase 3 (계획) |
| 8 | 성과 & 임팩트 | 구현된 기능, 개발 우수성 |
| 9 | 다음 단계 | Phase 1.4, 1.5 계획 |
| 10 | 결론 | 감사 및 프로젝트 요약 |

## 🎨 디자인 특징

### 색상 팔레트
- **주색상**: #6D4C41 (갈색) - CafeMatch 테마
- **보조색**: #8D6E63, #A1887F, #BCAAA4
- **강조색**: #D32F2F (빨강)
- **배경**: #EFEBE9, #F5F5F5 (밝은 갈색 톤)

### 스타일 요소
- ✨ Material Design 3 준수
- 📊 4-Layer 아키텍처 메머드 다이어그램
- 📈 진행 상황 시각화
- 🎯 임팩트있는 타이포그래피
- 🎨 일관된 배색과 레이아웃

## 📱 반응형 디자인

- 데스크톱 (1200px 기준)
- 부드러운 애니메이션
- 호버 효과
- 그림자 및 깊이 표현

## 🔧 기술 스택

| 기술 | 사용 |
|------|------|
| HTML5 | 시맨틱 구조 |
| CSS3 | 그리드, 플렉스박스, 그라데이션 |
| Vanilla JS | 슬라이드 네비게이션 |

## 💡 주요 콘텐츠

### 비전 및 문제 정의
- 🎯 **비전**: 사용자가 현재 위치에서 최적의 카페를 즉시 찾을 수 있는 생태계
- 💡 **미션**: 위치 기반 추천 + 실시간 정보 + 커뮤니티 리뷰

### 아키텍처 - 4-Layer Clean Architecture
```
┌─────────────────────────────────┐
│ Presentation Layer              │  HomeScreen, MapWidget, Provider
├─────────────────────────────────┤
│ Application Layer               │  SearchCafesUseCase
├─────────────────────────────────┤
│ Domain Layer                    │  Cafe Entity, Repository (Abstract)
├─────────────────────────────────┤
│ Data Layer                      │  Models, APIs, Cache
└─────────────────────────────────┘
```

### 현재 구현 상태
- ✅ **Phase 1**: 기본 기능 완료
  - 4-Layer 아키텍처
  - Google Maps 통합
  - Naver API 통합
  - 오프라인 캐싱

- 🚀 **Phase 2**: 사용자 기능 진행중
  - Firebase 인증
  - 리뷰 & 평가
  - 사용자 프로필
  - 북마크 기능

- 📋 **Phase 3**: 소셜 기능 계획중
  - 카페 공유
  - 친구 추천
  - 소셜 피드
  - 앱 배포

## 📊 성과 지표

- **새로운 Dart 파일**: 8개
- **외부 API 통합**: 3개 (Naver, Google Maps, GPS)
- **Clean Architecture 준수**: 100%
- **분석 오류**: 0개 (flutter analyze)

## 🎯 발표 팁

1. **전체 흐름**: 타이틀 → 비전 → 문제 → 해결책 → 기술 → 진행상황 → 결론
2. **강조점**: 각 문제카드와 해결책에서 강조하기
3. **시각화**: 아키텍처 메머드 다이어그램 설명
4. **통계**: 성과 & 임팩트 슬라이드의 숫자 강조
5. **미래**: 다음 단계 슬라이드로 비전 확대

## 📝 수정/확장 방법

### 슬라이드 추가
1. `index.html`에서 새로운 `<div class="slide">` 추가
2. `totalSlides` 자동 계산됨

### 색상 변경
```css
/* 6D4C41을 원하는 색상으로 변경 */
color: #6D4C41; → color: #your-color;
```

### 콘텐츠 수정
- HTML에서 텍스트 직접 편집
- CSS에서 스타일 조정

## 🎬 발표 방법

### 온라인 발표
1. `index.html`을 웹 서버에 배포
2. 공유 링크 제공
3. 화면 공유로 발표

### 오프라인 발표
1. 노트북에서 브라우저 전체 화면 모드 (F11)
2. 프로젝터 연결
3. 키보드 화살표로 네비게이션

## 📞 추가 정보

- **프로젝트 리포지토리**: GitHub
- **API 문서**: Naver Developers, Google Cloud Console
- **Flutter 버전**: 3.11.3

---

**Last Updated**: 2026-05-26
**Presentation Format**: HTML/CSS (PPT 스타일)
**Status**: 발표 준비 완료 ✅
