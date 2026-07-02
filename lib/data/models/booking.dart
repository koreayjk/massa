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
class Booking {
  final String id;
  final Therapist therapist;
  final Service service;
  final DateTime scheduledAt;
  final String address;
  final int totalPrice;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.therapist,
    required this.service,
    required this.scheduledAt,
    required this.address,
    required this.totalPrice,
    required this.status,
  });
}
