import '../models/booking.dart';
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
}
