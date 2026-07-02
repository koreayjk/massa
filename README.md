# 🏠 massa — 홈 마사지 예약 플랫폼 (MVP)

한국 홈 마사지 시장을 타겟으로 한 O2O 예약 플랫폼의 **고객용 앱 MVP**입니다.
견적서와 함께 클라이언트에게 데모로 보여줄 수 있는 수준의 UI/UX를 Flutter로 구현했습니다.

> **클라이언트**: COTRAS (김학병 대표) · **개발**: IM America Group Corp

---

## 🌿 랜딩 페이지 (LP)

전체 기능과 실제 MVP 화면을 소개하는 랜딩 페이지입니다.

- **바로 보기 (링크)**: https://claude.ai/code/artifact/e5edd87b-a360-4058-96d5-f4bc9b5850c3
- **소스 파일**: [`docs/index.html`](docs/index.html) — 폰트·이미지가 모두 내장된 단일 HTML(오프라인에서도 열림)

### GitHub Pages로 공개 URL 만들기 (선택)
1. GitHub 저장소 → **Settings → Pages**
2. **Source**: `Deploy from a branch` → Branch를 `main`(또는 이 브랜치), 폴더를 **`/docs`** 로 선택 → Save
3. 1~2분 뒤 `https://koreayjk.github.io/massa/` 에서 공개됩니다.

---

## 🎯 이 MVP에 포함된 것

브라우저(`flutter run -d chrome`)에서 바로 확인 가능한 **8개 핵심 화면**:

| 화면 | 파일 |
|------|------|
| 스플래시 | `lib/presentation/screens/splash/` |
| 온보딩 | `lib/presentation/screens/onboarding/` |
| 로그인 · 회원가입 | `lib/presentation/screens/auth/` |
| 홈 (테크니션 목록·검색·필터) | `lib/presentation/screens/home/` |
| 테크니션 상세 (프로필·리뷰) | `lib/presentation/screens/therapist/` |
| 예약 (서비스·달력·시간·주소) | `lib/presentation/screens/booking/` |
| 예약 확정 (요약·결제 UI) | `lib/presentation/screens/booking/` |
| 예약 내역 · 채팅 · 마이페이지 | `lib/presentation/screens/{booking,chat,profile}/` |

**동작하는 전체 흐름**: 스플래시 → 온보딩 → 로그인 → 홈 → 테크니션 상세 →
예약(달력) → 결제 확인 → 예약 완료 → 예약 내역.

디자인: 클라이언트 COTRAS(코트라스, 재활·의료기기 기업) **로고에서 추출한**
세룰리안 블루(`#127C99`) → 그린(`#46A85E`) 그라데이션 + 화이트 기반 테마.

## 🛡 신뢰 · 안전 기능 (Trust & Safety)

세 앱에 걸친 신고·안전 기능을 데모용으로 구현했습니다. 로그인 화면 하단
**"데모 모드 · 앱 둘러보기"** 에서 고객 앱 / 테크니션 앱 / 관리자 웹으로 바로 진입할 수 있습니다.

| 앱 | 기능 | 위치 |
|----|------|------|
| 고객 앱 | **양방향 평점 시스템** — 테크니션 리뷰 작성 + 내가 받은 "매너 평점" 조회 | `lib/presentation/screens/customer/rating/` |
| 테크니션 앱 | **고객 신고 버튼** (예약별 신고) | `lib/presentation/screens/technician/report_customer_screen.dart` |
| 테크니션 앱 | **SOS 긴급 알림** (위치 공유 · 관리자/긴급연락처 즉시 통보) | `lib/presentation/screens/technician/sos_screen.dart` |
| 관리자 웹 | **신고 관리 시스템** — 상태 필터 · 처리(처리중/완료/반려) · 블랙리스트 연동 | `lib/presentation/screens/admin/report_management_screen.dart` |
| 관리자 웹 | **블랙리스트 관리** — 등록/해제 · 수동 등록 · 신고 연동 | `lib/presentation/screens/admin/blacklist_management_screen.dart` |

신고(`Report`)·블랙리스트(`BlacklistEntry`) 모델과 데이터는
`lib/data/models/` 및 `lib/data/repositories/mock_repository.dart`에 있습니다.
고객↔테크니션 신고는 양방향으로 접수되며, 관리자 웹의 신고 처리 → 블랙리스트 등록이
실제로 연동됩니다.

## ⛔ MVP에서 제외 (다음 단계)

실제 결제 연동 · 실시간 GPS 추적 · AI 챗봇.
테크니션 앱과 관리자 웹은 위 신뢰·안전 기능 위주로 데모 수준만 구현되어 있으며,
전체 기능(일정 관리·정산·회원 관리·KYC 등)은 다음 단계입니다.
현재는 **목업 데이터**(`lib/data/repositories/mock_repository.dart`)로 동작하며,
백엔드(Supabase) 연동은 `lib/services/` 레이어에 추가할 예정입니다.

---

## 🚀 실행 방법

```bash
# 1) 의존성 설치
flutter pub get

# 2) 웹 브라우저에서 실행 (가장 빠른 데모)
flutter run -d chrome

# (선택) 플랫폼 폴더가 없다는 오류가 나면 — lib/는 그대로 두고 스캐폴딩만 생성
flutter create . --platforms=web,android,ios
flutter pub get
flutter run -d chrome
```

> Flutter 3.19+ 권장. `intl` 패키지의 한국어 날짜 포맷은 `main.dart`에서
> `initializeDateFormatting('ko_KR')`으로 초기화됩니다.

---

## 🗂 프로젝트 구조

```
lib/
├── main.dart                     # 앱 진입점 · 로케일 초기화
├── core/
│   ├── constants/                # 컬러 · 사이즈 상수
│   ├── theme/                    # 전역 Material 테마
│   └── utils/                    # 금액 · 날짜 포매터
├── data/
│   ├── models/                   # Therapist · Service · Booking · Review
│   └── repositories/             # 데모용 인메모리 목업 저장소
└── presentation/
    ├── screens/                  # 화면 (auth · home · therapist · booking · chat · profile)
    └── widgets/                  # 공통 위젯 (Avatar · RatingBadge · TherapistCard)
```

---

## 🔜 다음 단계

1. Supabase 연동 (`lib/services/supabase_service.dart`) — Auth · therapists 테이블
2. 실제 PG 결제 연동
3. 실시간 위치 추적 (Google Maps + Supabase Realtime)
4. AI 기능 (Gemini) — 챗봇 · 리뷰 감성분석 · KYC
5. 테크니션용 앱 · 관리자 웹 포털
