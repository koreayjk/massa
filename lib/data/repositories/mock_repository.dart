import '../models/blacklist_entry.dart';
import '../models/booking.dart';
import '../models/report.dart';
import '../models/review.dart';
import '../models/service.dart';
import '../models/therapist.dart';

/// MVP 데모용 인메모리 데이터 저장소.
/// 실제 백엔드(Supabase) 연동 전, UI 확인을 위한 목업 데이터.
class MockRepository {
  MockRepository._();
  static final MockRepository instance = MockRepository._();

  /// 홈 화면 서비스 카테고리 필터.
  static const List<String> categories = [
    '전체',
    '스웨디시',
    '아로마',
    '딥티슈',
    '스포츠',
    '타이',
    '경락',
  ];

  static final List<Service> _swedish = [
    const Service(
      id: 's1',
      name: '스웨디시 60분',
      durationMinutes: 60,
      price: 70000,
      description: '부드러운 오일 마사지로 전신 이완과 혈액순환 개선.',
    ),
    const Service(
      id: 's2',
      name: '스웨디시 90분',
      durationMinutes: 90,
      price: 95000,
      description: '깊은 이완을 위한 전신 프리미엄 케어.',
    ),
    const Service(
      id: 's3',
      name: '아로마 테라피 90분',
      durationMinutes: 90,
      price: 110000,
      description: '천연 에센셜 오일을 활용한 심신 안정 케어.',
    ),
  ];

  static final List<Service> _deep = [
    const Service(
      id: 'd1',
      name: '딥티슈 60분',
      durationMinutes: 60,
      price: 80000,
      description: '뭉친 근육을 집중적으로 풀어주는 강도 높은 케어.',
    ),
    const Service(
      id: 'd2',
      name: '스포츠 마사지 60분',
      durationMinutes: 60,
      price: 85000,
      description: '운동 후 근육 회복과 피로 해소에 최적화.',
    ),
  ];

  static final List<Service> _homecare = [
    const Service(
      id: 'h1',
      name: '귀청소 30분',
      durationMinutes: 30,
      price: 30000,
      description: '전문 도구로 안전하게 진행하는 귀 세정 케어.',
    ),
    const Service(
      id: 'h2',
      name: '왁싱 (전신) 60분',
      durationMinutes: 60,
      price: 90000,
      description: '저자극 왁스로 매끄럽게 마무리하는 제모 케어.',
    ),
    const Service(
      id: 'h3',
      name: '스웨디시 60분',
      durationMinutes: 60,
      price: 68000,
      description: '부드러운 전신 이완 마사지.',
    ),
  ];

  static final List<Review> _reviews = [
    Review(
      id: 'r1',
      authorName: '김민지',
      rating: 5,
      comment: '정말 시원했어요. 손 힘이 좋으시고 시간도 정확하게 지켜주셨어요!',
      createdAt: DateTime(2026, 6, 20),
    ),
    Review(
      id: 'r2',
      authorName: '이서준',
      rating: 4.5,
      comment: '집으로 방문해주셔서 편했고 응대도 친절했습니다.',
      createdAt: DateTime(2026, 6, 12),
    ),
    Review(
      id: 'r3',
      authorName: '박지우',
      rating: 5,
      comment: '어깨 뭉친 게 확실히 풀렸어요. 재예약 의사 100%!',
      createdAt: DateTime(2026, 5, 30),
    ),
    Review(
      id: 'r4',
      authorName: '정예린',
      rating: 4.5,
      comment: '예약부터 방문까지 깔끔했어요. 위생 관리도 꼼꼼하셔서 믿음이 갔습니다.',
      createdAt: DateTime(2026, 5, 22),
    ),
    Review(
      id: 'r5',
      authorName: '한동석',
      rating: 5,
      comment: '출장 마사지는 처음이었는데 기대 이상이었어요. 강도도 딱 맞게 조절해 주셨습니다.',
      createdAt: DateTime(2026, 5, 15),
    ),
  ];

  static final List<Therapist> therapists = [
    Therapist(
      id: 't1',
      name: '이수정',
      photoUrl: '',
      bio: '10년 경력의 스웨디시·아로마 전문 관리사입니다. 고객 한 분 한 분께 편안한 힐링을 선물해 드립니다.',
      rating: 4.9,
      reviewCount: 128,
      location: '서울 강남구',
      distanceKm: 1.2,
      specialties: ['스웨디시', '아로마', '경락'],
      minPrice: 70000,
      verified: true,
      available: true,
      services: _swedish,
      reviews: _reviews,
    ),
    Therapist(
      id: 't2',
      name: '박준호',
      photoUrl: '',
      bio: '스포츠·딥티슈 전문. 운동 후 근육 회복과 만성 통증 완화에 강점이 있습니다.',
      rating: 4.7,
      reviewCount: 86,
      location: '서울 서초구',
      distanceKm: 2.5,
      specialties: ['딥티슈', '스포츠'],
      minPrice: 80000,
      verified: true,
      available: true,
      services: _deep,
      reviews: _reviews.sublist(0, 2),
    ),
    Therapist(
      id: 't3',
      name: '최유나',
      photoUrl: '',
      bio: '타이 마사지와 아로마 테라피로 몸과 마음의 균형을 찾아드립니다.',
      rating: 4.8,
      reviewCount: 64,
      location: '서울 송파구',
      distanceKm: 3.8,
      specialties: ['타이', '아로마'],
      minPrice: 75000,
      verified: true,
      available: false,
      services: _swedish,
      reviews: _reviews.sublist(1),
    ),
    Therapist(
      id: 't4',
      name: '정하늘',
      photoUrl: '',
      bio: '경락과 림프 순환 관리 전문. 붓기 완화와 디톡스에 효과적입니다.',
      rating: 4.6,
      reviewCount: 42,
      location: '서울 마포구',
      distanceKm: 5.1,
      specialties: ['경락', '스웨디시'],
      minPrice: 65000,
      verified: false,
      available: true,
      services: [..._swedish.sublist(0, 2), ..._deep.sublist(0, 1)],
      reviews: _reviews.sublist(0, 1),
    ),
    Therapist(
      id: 't5',
      name: '한지민',
      photoUrl: '',
      bio: '귀청소·스웨디시 전문. 섬세한 손길과 철저한 위생 관리로 편안한 홈케어를 제공합니다.',
      rating: 4.85,
      reviewCount: 73,
      location: '서울 용산구',
      distanceKm: 2.9,
      specialties: ['귀청소', '스웨디시'],
      minPrice: 30000,
      verified: true,
      available: true,
      services: _homecare,
      reviews: _reviews.sublist(2, 4),
    ),
    Therapist(
      id: 't6',
      name: '오세훈',
      photoUrl: '',
      bio: '왁싱·아로마 전문 관리사. 저자극 제품과 위생을 최우선으로 케어합니다.',
      rating: 4.75,
      reviewCount: 51,
      location: '서울 성동구',
      distanceKm: 4.2,
      specialties: ['왁싱', '아로마'],
      minPrice: 90000,
      verified: true,
      available: true,
      services: [_homecare[1], _swedish[2]],
      reviews: _reviews.sublist(3),
    ),
  ];

  /// 데모용 예약 목록(런타임에 추가/변경 가능).
  final List<Booking> bookings = [
    Booking(
      id: 'b1',
      therapist: therapists[0],
      service: _swedish[0],
      scheduledAt: DateTime(2026, 7, 8, 14, 0),
      address: '서울 강남구 테헤란로 123, 4층',
      totalPrice: 70000,
      status: BookingStatus.upcoming,
    ),
    Booking(
      id: 'b2',
      therapist: therapists[1],
      service: _deep[0],
      scheduledAt: DateTime(2026, 6, 18, 19, 30),
      address: '서울 서초구 반포대로 45',
      totalPrice: 80000,
      status: BookingStatus.completed,
    ),
  ];

  void addBooking(Booking booking) => bookings.insert(0, booking);

  // ─────────────────────────────────────────────────────────────
  // 양방향 평점 시스템 (고객 ↔ 테크니션)
  // ─────────────────────────────────────────────────────────────

  /// 로그인한 고객이 테크니션으로부터 받은 "매너 평점".
  double myMannerRating = 4.8;
  int myMannerRatingCount = 12;

  /// 고객이 테크니션에게 받은 리뷰(양방향 평점의 반대편).
  final List<Review> myReceivedReviews = [
    Review(
      id: 'mr1',
      authorName: '이수정 관리사',
      rating: 5,
      comment: '시간 약속을 잘 지켜주시고 응대가 친절하셨어요. 다시 만나뵙고 싶은 고객님입니다!',
      createdAt: DateTime(2026, 6, 18),
    ),
    Review(
      id: 'mr2',
      authorName: '박준호 관리사',
      rating: 4.5,
      comment: '쾌적한 환경에서 편하게 케어해 드렸습니다. 감사합니다 :)',
      createdAt: DateTime(2026, 5, 20),
    ),
  ];

  /// 고객이 테크니션에게 남긴 리뷰 저장(예약 완료 후).
  final List<Review> customerWrittenReviews = [];

  void addCustomerReview(Review review) =>
      customerWrittenReviews.insert(0, review);

  // ─────────────────────────────────────────────────────────────
  // 신고 관리 (관리자 웹)
  // ─────────────────────────────────────────────────────────────

  final List<Report> reports = [
    Report(
      id: 'rp1',
      reporterRole: ReporterRole.technician,
      reporterName: '박준호',
      targetName: '익명 고객 (김OO)',
      bookingId: 'b2',
      reason: ReportReason.harassment,
      detail: '방문 중 부적절한 신체 접촉 및 성희롱 발언이 있었습니다. 즉시 현장을 떠났습니다.',
      createdAt: DateTime(2026, 6, 30, 21, 12),
      status: ReportStatus.pending,
    ),
    Report(
      id: 'rp2',
      reporterRole: ReporterRole.customer,
      reporterName: '김민지',
      targetName: '정하늘',
      bookingId: 'b1',
      reason: ReportReason.noShow,
      detail: '예약 시간에 관리사가 나타나지 않았고 연락도 되지 않았습니다.',
      createdAt: DateTime(2026, 6, 28, 15, 40),
      status: ReportStatus.reviewing,
    ),
    Report(
      id: 'rp3',
      reporterRole: ReporterRole.customer,
      reporterName: '이서준',
      targetName: '최유나',
      reason: ReportReason.payment,
      detail: '결제 금액이 예약 시 안내받은 금액과 다르게 청구되었습니다.',
      createdAt: DateTime(2026, 6, 25, 11, 5),
      status: ReportStatus.resolved,
    ),
  ];

  void addReport(Report report) => reports.insert(0, report);

  void updateReportStatus(Report report, ReportStatus status) =>
      report.status = status;

  int get pendingReportCount =>
      reports.where((r) => r.status == ReportStatus.pending).length;

  // ─────────────────────────────────────────────────────────────
  // 블랙리스트 관리 (관리자 웹)
  // ─────────────────────────────────────────────────────────────

  final List<BlacklistEntry> blacklist = [
    BlacklistEntry(
      id: 'bl1',
      name: '익명 고객 (박OO)',
      role: BlacklistRole.customer,
      reason: '반복적인 노쇼 (3회) 및 예약금 미납',
      addedAt: DateTime(2026, 6, 10),
      active: true,
    ),
    BlacklistEntry(
      id: 'bl2',
      name: '홍길동',
      role: BlacklistRole.technician,
      reason: '무단 예약 취소 반복, 고객 불만 다수 접수',
      addedAt: DateTime(2026, 5, 28),
      active: true,
    ),
  ];

  void addToBlacklist(BlacklistEntry entry) => blacklist.insert(0, entry);

  void setBlacklistActive(BlacklistEntry entry, bool active) =>
      entry.active = active;

  int get activeBlacklistCount =>
      blacklist.where((e) => e.active).length;

  // ─────────────────────────────────────────────────────────────
  // SOS 긴급 알림 이력 (테크니션 → 관리자/긴급연락처)
  // ─────────────────────────────────────────────────────────────

  int sosAlertCount = 0;

  void triggerSos() => sosAlertCount++;
}
