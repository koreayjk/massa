import 'package:flutter/material.dart';

/// 홈 화면 서비스 카테고리 (마사지 + 홈케어 서비스).
/// Glow처럼 마사지 외 다양한 홈서비스로 확장 가능.
class ServiceCategory {
  final String name;
  final IconData icon;
  const ServiceCategory(this.name, this.icon);
}

/// 데모용 카테고리 목록.
const List<ServiceCategory> kServiceCategories = [
  ServiceCategory('스웨디시', Icons.spa_rounded),
  ServiceCategory('아로마', Icons.local_florist_rounded),
  ServiceCategory('딥티슈', Icons.self_improvement_rounded),
  ServiceCategory('타이', Icons.accessibility_new_rounded),
  ServiceCategory('스포츠', Icons.fitness_center_rounded),
  ServiceCategory('경락', Icons.waves_rounded),
  ServiceCategory('귀청소', Icons.hearing_rounded),
  ServiceCategory('왁싱', Icons.auto_awesome_rounded),
];

/// 마사지 강도 (Maso 취향 기반 선택).
enum Intensity {
  soft('약하게'),
  medium('보통'),
  strong('강하게');

  const Intensity(this.label);
  final String label;
}

/// 집중 케어 부위 (Maso 부위별 선택).
enum BodyFocus {
  neck('어깨·목'),
  back('등·허리'),
  legs('다리·발'),
  full('전신');

  const BodyFocus(this.label);
  final String label;
}
