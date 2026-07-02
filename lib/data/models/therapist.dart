import 'review.dart';
import 'service.dart';

/// 홈 마사지 테크니션(관리사).
class Therapist {
  final String id;
  final String name;
  final String photoUrl;
  final String bio;
  final double rating;
  final int reviewCount;
  final String location;
  final double distanceKm;
  final List<String> specialties;
  final int minPrice;
  final bool verified;
  final bool available;
  final List<Service> services;
  final List<Review> reviews;

  const Therapist({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.bio,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.distanceKm,
    required this.specialties,
    required this.minPrice,
    required this.verified,
    required this.available,
    required this.services,
    required this.reviews,
  });
}
