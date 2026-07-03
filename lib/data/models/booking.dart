import 'service.dart';
import 'therapist.dart';

enum BookingStatus {
  upcoming('예정'),
  completed('완료'),
  cancelled('취소');

  const BookingStatus(this.label);
  final String label;
}

/// 고객이 생성한 예약.
/// 데모에서 취소·리뷰 작성이 실제로 반영되도록 [status]와 [reviewed]는 가변.
class Booking {
  final String id;
  final Therapist therapist;
  final Service service;
  final DateTime scheduledAt;
  final String address;
  final int totalPrice;
  BookingStatus status;
  bool reviewed;

  Booking({
    required this.id,
    required this.therapist,
    required this.service,
    required this.scheduledAt,
    required this.address,
    required this.totalPrice,
    required this.status,
    this.reviewed = false,
  });
}
