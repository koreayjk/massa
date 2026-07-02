/// 테크니션이 제공하는 마사지 서비스.
class Service {
  final String id;
  final String name;
  final int durationMinutes;
  final int price;
  final String description;

  const Service({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.price,
    required this.description,
  });
}
