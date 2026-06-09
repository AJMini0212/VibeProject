# 🗄️ Firestore 데이터베이스 스키마

## 개요

CafeMatch 앱의 Firestore 데이터베이스 구조. 사용자, 리뷰, 댓글, 활동 데이터를 관리합니다.

---

## 📊 컬렉션 구조

### 1. `users/{uid}` - 사용자 프로필

**문서 필드:**

| 필드 | 타입 | 설명 | 필수 |
|------|------|------|------|
| `uid` | string | 사용자 ID (Firebase Auth) | ✅ |
| `email` | string | 이메일 주소 | ✅ |
| `displayName` | string | 표시 이름 | ✅ |
| `photoUrl` | string | 프로필 사진 URL | ❌ |
| `bio` | string | 프로필 소개글 (최대 200자) | ❌ |
| `createdAt` | timestamp | 계정 생성 일시 | ✅ |
| `updatedAt` | timestamp | 마지막 수정 일시 | ❌ |
| `favoriteIds` | array<string> | 즐겨찾기한 카페 ID 배열 | ✅ |
| `followerIds` | array<string> | 팔로워 사용자 ID 배열 | ✅ |
| `followingIds` | array<string> | 팔로잉 사용자 ID 배열 | ✅ |

**예시:**
```json
{
  "uid": "user123",
  "email": "user@example.com",
  "displayName": "John Doe",
  "photoUrl": "https://example.com/photo.jpg",
  "bio": "커피 애호가입니다 ☕",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-06-09T14:20:00Z",
  "favoriteIds": ["cafe1", "cafe2"],
  "followerIds": ["user2", "user3"],
  "followingIds": ["user4", "user5"]
}
```

**보안:** 자신의 프로필만 수정 가능

---

### 2. `reviews/{reviewId}` - 리뷰

**문서 필드:**

| 필드 | 타입 | 설명 | 필수 |
|------|------|------|------|
| `id` | string | 리뷰 ID (문서 ID와 동일) | ✅ |
| `cafeId` | string | 카페 ID | ✅ |
| `userId` | string | 작성자 사용자 ID | ✅ |
| `rating` | integer | 별점 (1-5) | ✅ |
| `text` | string | 리뷰 내용 (최대 500자) | ✅ |
| `createdAt` | timestamp | 작성 일시 | ✅ |
| `updatedAt` | timestamp | 마지막 수정 일시 | ❌ |
| `likedByUserIds` | array<string> | 좋아요한 사용자 ID 배열 | ✅ |
| `likeCount` | integer | 좋아요 수 (캐시) | ✅ |
| `commentCount` | integer | 댓글 수 (캐시) | ✅ |

**예시:**
```json
{
  "id": "review123",
  "cafeId": "cafe456",
  "userId": "user123",
  "rating": 4,
  "text": "분위기 좋고 커피도 맛있어요!",
  "createdAt": "2024-06-09T10:00:00Z",
  "updatedAt": "2024-06-09T10:00:00Z",
  "likedByUserIds": ["user2", "user3"],
  "likeCount": 2,
  "commentCount": 3
}
```

**서브컬렉션:** `comments/{commentId}`

**보안:** 작성자만 수정/삭제 가능

**인덱스:**
- `cafeId ASC, createdAt DESC` - 카페별 리뷰 조회
- `userId ASC, createdAt DESC` - 사용자별 리뷰 조회

---

### 3. `reviews/{reviewId}/comments/{commentId}` - 댓글

**문서 필드:**

| 필드 | 타입 | 설명 | 필수 |
|------|------|------|------|
| `id` | string | 댓글 ID (문서 ID와 동일) | ✅ |
| `reviewId` | string | 상위 리뷰 ID | ✅ |
| `userId` | string | 작성자 사용자 ID | ✅ |
| `text` | string | 댓글 내용 (최대 200자) | ✅ |
| `createdAt` | timestamp | 작성 일시 | ✅ |
| `updatedAt` | timestamp | 마지막 수정 일시 | ❌ |

**예시:**
```json
{
  "id": "comment789",
  "reviewId": "review123",
  "userId": "user2",
  "text": "정말 좋은 리뷰네요!",
  "createdAt": "2024-06-09T11:30:00Z",
  "updatedAt": "2024-06-09T11:30:00Z"
}
```

**보안:** 작성자만 수정/삭제 가능

**인덱스:**
- `reviewId ASC, createdAt ASC` - 리뷰별 댓글 조회

---

### 4. `activities/{activityId}` - 활동 기록

**문서 필드:**

| 필드 | 타입 | 설명 | 필수 |
|------|------|------|------|
| `id` | string | 활동 ID | ✅ |
| `userId` | string | 활동을 수행한 사용자 ID | ✅ |
| `type` | string | 활동 타입 (`follow`, `review_posted`, `review_liked`, `comment_added`) | ✅ |
| `targetId` | string | 대상 ID (userId 또는 reviewId) | ✅ |
| `createdAt` | timestamp | 활동 일시 | ✅ |

**활동 타입별 targetId:**
- `follow`: 팔로우한 사용자 ID
- `review_posted`: 작성한 리뷰 ID
- `review_liked`: 좋아요한 리뷰 ID
- `comment_added`: 작성한 댓글이 속한 리뷰 ID

**예시:**
```json
{
  "id": "activity001",
  "userId": "user123",
  "type": "review_posted",
  "targetId": "review456",
  "createdAt": "2024-06-09T14:00:00Z"
}
```

**보안:** 인증된 사용자만 생성 가능, 소유자만 삭제 가능

**인덱스:**
- `userId ASC, createdAt DESC` - 사용자별 활동 피드 조회

---

## 🔒 보안 규칙 (Security Rules)

**파일:** `firestore.rules`

### 주요 규칙

1. **인증 확인**: 모든 읽기/쓰기는 인증된 사용자만 가능
2. **소유권 검증**: 사용자 프로필, 리뷰, 댓글은 소유자만 수정/삭제 가능
3. **데이터 검증**: 생성 시 필수 필드 및 데이터 타입 검증
4. **길이 제한**: 텍스트 필드는 최대 길이 제한
   - 리뷰: 최대 500자
   - 댓글: 최대 200자
   - 소개글: 최대 200자

---

## 📈 복합 인덱스 (Composite Indexes)

**파일:** `firestore.indexes.json`

| 컬렉션 | 필드 1 | 필드 2 | 용도 |
|--------|--------|--------|------|
| `reviews` | `cafeId` ↑ | `createdAt` ↓ | 카페별 리뷰 조회 (최신순) |
| `reviews` | `userId` ↑ | `createdAt` ↓ | 사용자별 리뷰 조회 (최신순) |
| `comments` | `reviewId` ↑ | `createdAt` ↑ | 리뷰별 댓글 조회 (오래된순) |
| `activities` | `userId` ↑ | `createdAt` ↓ | 사용자 활동 피드 (최신순) |

### 인덱스 생성 방법

**Firebase Console:**
1. Firestore 데이터베이스 → 인덱스 탭
2. 복합 인덱스 생성 → 필드 추가
3. 각 필드의 정렬 순서 지정 (오름차순 ↑ / 내림차순 ↓)

**CLI (선택사항):**
```bash
firebase firestore:indexes
```

---

## 🔄 트랜잭션 (Transactions)

### 팔로우 작업 (원자성 보장)

**팔로우 (followUser):**
```
Transaction 시작
  1. users/{currentUserId}: followingIds에 targetUserId 추가
  2. users/{targetUserId}: followerIds에 currentUserId 추가
  3. activities: 새 활동 기록 생성 (type: follow)
Transaction 커밋
```

**언팔로우 (unfollowUser):**
```
Transaction 시작
  1. users/{currentUserId}: followingIds에서 targetUserId 제거
  2. users/{targetUserId}: followerIds에서 currentUserId 제거
Transaction 커밋
```

### 좋아요 작업 (원자성 보장)

**좋아요 추가:**
```
Transaction 시작
  1. reviews/{reviewId}: likedByUserIds에 userId 추가, likeCount 증가
  2. activities: 새 활동 기록 생성 (type: review_liked)
Transaction 커밋
```

**좋아요 제거:**
```
Transaction 시작
  1. reviews/{reviewId}: likedByUserIds에서 userId 제거, likeCount 감소
Transaction 커밋
```

---

## 📋 배열 필드 관리

### 배열 크기 제한

**제약:**
- Firestore 문서 최대 크기: 1MB
- `likedByUserIds` 배열이 1000개 초과 시 별도 컬렉션으로 이관 필요

**현재 구조에서 안전한 범위:**
- `followerIds`: 최대 10,000개 (약 100KB)
- `followingIds`: 최대 10,000개 (약 100KB)
- `likedByUserIds`: 최대 1,000개 (약 10KB)
- `favoriteIds`: 최대 10,000개 (약 100KB)

### 배열 필드 업데이트

**Dart에서의 배열 업데이트:**
```dart
// 배열에 요소 추가
await firestore.collection('users').doc(uid).update({
  'followingIds': FieldValue.arrayUnion([targetUserId])
});

// 배열에서 요소 제거
await firestore.collection('users').doc(uid).update({
  'followingIds': FieldValue.arrayRemove([targetUserId])
});
```

---

## 🚀 쿼리 최적화

### 자주 사용되는 쿼리

```dart
// 카페별 리뷰 조회 (최신순, 페이지네이션)
firestore
  .collection('reviews')
  .where('cafeId', isEqualTo: cafeId)
  .orderBy('createdAt', descending: true)
  .limit(20)

// 사용자 프로필 리뷰 조회
firestore
  .collection('reviews')
  .where('userId', isEqualTo: userId)
  .orderBy('createdAt', descending: true)
  .limit(10)

// 리뷰의 댓글 조회
firestore
  .collection('reviews')
  .doc(reviewId)
  .collection('comments')
  .orderBy('createdAt', ascending: true)
  .limit(20)

// 사용자 활동 피드
firestore
  .collection('activities')
  .where('userId', isEqualTo: userId)
  .orderBy('createdAt', descending: true)
  .limit(20)
```

### 성능 팁

1. **선택적 로딩**: 필요한 필드만 로드 (`.select()` 사용)
2. **배치 읽기**: 여러 문서를 한 번에 읽기 (트랜잭션)
3. **캐싱**: 앱 메모리에 자주 사용되는 데이터 캐싱
4. **페이지네이션**: Timestamp 기반 커서 사용

---

## 📝 배포 체크리스트

- [ ] Firestore 데이터베이스 생성 (프로덕션 모드)
- [ ] `firestore.rules` 배포
- [ ] `firestore.indexes.json`의 모든 인덱스 생성 완료
- [ ] 보안 규칙 테스트 (Firebase Emulator)
- [ ] 데이터 검증 로직 확인
- [ ] 백업 정책 설정

---

## 🔧 유지보수

### 모니터링
- **사용 현황**: Firebase Console → 사용량
- **성능**: Firestore → 통계 및 모니터링
- **에러**: Firebase Console → 로그

### 스케일링
- **읽기/쓰기 제한**: 요금 계획 업그레이드
- **저장 용량**: 자동 증설 (종량제)
- **배열 크기**: 1000개 초과 시 별도 컬렉션 생성

---

**최종 업데이트**: 2024-06-09
**상태**: 프로덕션 준비 완료 ✅
