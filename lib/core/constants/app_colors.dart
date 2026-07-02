import 'package:flutter/material.dart';

/// 앱 전역 컬러 팔레트.
/// 클라이언트 COTRAS(재활·의료기기 헬스케어 기업) 이미지에 맞춘
/// 메디컬 틸-블루(teal-blue) 계열. 신뢰감·청결·케어를 강조.
///
/// 참고: 필드명(navy 등)은 기존 코드 호환을 위해 유지하되 값은 브랜드 컬러로 조정됨.
class AppColors {
  AppColors._();

  // Brand (COTRAS medical teal-blue)
  static const Color navy = Color(0xFF0C5C6E); // primary
  static const Color navyLight = Color(0xFF0E6E82);
  static const Color navySoft = Color(0xFF12768C); // secondary
  static const Color accent = Color(0xFF17B3A6); // mint-teal
  static const Color accentSoft = Color(0xFFD8F1EE);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF4F8FA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4EBEE);
  static const Color textPrimary = Color(0xFF0E3A43);
  static const Color textSecondary = Color(0xFF5E7480);
  static const Color textHint = Color(0xFF9DAAB2);

  // Semantic
  static const Color success = Color(0xFF2BB673);
  static const Color warning = Color(0xFFF5A623);
  static const Color danger = Color(0xFFE5484D);
  static const Color star = Color(0xFFFFB800);
}
