import 'package:flutter/material.dart';

/// 앱 전역 컬러 팔레트.
/// 클라이언트 COTRAS(코트라스, 재활·의료기기 헬스케어 기업) 로고에서 추출한
/// 세룰리안 블루 → 그린 그라데이션 브랜드 컬러. (신뢰·케어·의료)
///
/// 로고: 블루(#2E93B5 계열) → 그린(#4CA85F 계열) 스월 + 화이트 포인트.
/// 참고: 필드명(navy 등)은 기존 코드 호환을 위해 유지하되 값은 브랜드 컬러로 조정됨.
class AppColors {
  AppColors._();

  // Brand (COTRAS cerulean-blue → green)
  static const Color navy = Color(0xFF127C99); // primary — 세룰리안 블루
  static const Color navyLight = Color(0xFF1690AE);
  static const Color navySoft = Color(0xFF2E9C86); // 블루→그린 브릿지 (그라데이션 중간)
  static const Color accent = Color(0xFF46A85E); // COTRAS 그린
  static const Color accentSoft = Color(0xFFE2F1F0); // 페일 틸 틴트

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF4F8F8);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4EBEE);
  static const Color textPrimary = Color(0xFF17323A); // 다크 슬레이트 잉크
  static const Color textSecondary = Color(0xFF5E7480);
  static const Color textHint = Color(0xFF9DAAB2);

  // Semantic
  static const Color success = Color(0xFF2BB673);
  static const Color warning = Color(0xFFF5A623);
  static const Color danger = Color(0xFFE5484D);
  static const Color star = Color(0xFFFFB800);
}
