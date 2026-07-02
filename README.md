# 🏠 massa — 홈 마사지 예약 플랫폼 (MVP)

한국 홈 마사지 시장을 타겟으로 한 O2O 예약 플랫폼의 **고객용 앱 MVP**입니다.
견적서와 함께 클라이언트에게 데모로 보여줄 수 있는 수준의 UI/UX를 Flutter로 구현했습니다.

> **클라이언트**: COTRAS (김학병 대표) · **개발**: IM America Group Corp

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

디자인: 딥 네이비(`#0B2545`) + 화이트 기반의 모던·미니멀 테마.

## ⛔ MVP에서 제외 (다음 단계)

실제 결제 연동 · 실시간 GPS 추적 · AI 챗봇 · 테크니션 앱 · 관리자 웹.
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
