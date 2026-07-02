/// 신고 접수 주체(고객 ↔ 테크니션 양방향).
enum ReporterRole {
  customer('고객'),
  technician('테크니션');

  const ReporterRole(this.label);
  final String label;
}

/// 신고 처리 상태.
enum ReportStatus {
  pending('접수'),
  reviewing('처리중'),
  resolved('처리완료'),
  dismissed('반려');

  const ReportStatus(this.label);
  final String label;
}

/// 신고 사유(공통 카테고리).
enum ReportReason {
  noShow('노쇼 / 약속 불이행'),
  inappropriate('부적절한 언행'),
  harassment('성희롱 / 성추행'),
  payment('결제 / 환불 분쟁'),
  safety('안전 위협'),
  etc('기타');

  const ReportReason(this.label);
  final String label;
}

/// 신고 건. 관리자 웹에서 상태를 갱신하므로 [status]는 가변.
class Report {
  final String id;
  final ReporterRole reporterRole;
  final String reporterName;
  final String targetName;
  final String? bookingId;
  final ReportReason reason;
  final String detail;
  final DateTime createdAt;
  ReportStatus status;

  Report({
    required this.id,
    required this.reporterRole,
    required this.reporterName,
    required this.targetName,
    this.bookingId,
    required this.reason,
    required this.detail,
    required this.createdAt,
    this.status = ReportStatus.pending,
  });

  /// 신고 대상의 역할(신고자의 반대편).
  String get targetRoleLabel =>
      reporterRole == ReporterRole.customer ? '테크니션' : '고객';
}
