/// 블랙리스트 등록 대상 역할.
enum BlacklistRole {
  customer('고객'),
  technician('테크니션');

  const BlacklistRole(this.label);
  final String label;
}

/// 블랙리스트 항목. 관리자가 활성/해제를 토글하므로 [active]는 가변.
class BlacklistEntry {
  final String id;
  final String name;
  final BlacklistRole role;
  final String reason;
  final DateTime addedAt;
  final String? relatedReportId;
  bool active;

  BlacklistEntry({
    required this.id,
    required this.name,
    required this.role,
    required this.reason,
    required this.addedAt,
    this.relatedReportId,
    this.active = true,
  });
}
