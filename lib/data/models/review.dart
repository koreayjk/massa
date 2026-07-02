/// 예약 후 남기는 리뷰.
class Review {
  final String id;
  final String authorName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
