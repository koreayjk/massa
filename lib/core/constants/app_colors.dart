import 'package:flutter/material.dart';

/// 앱 전역 컬러 팔레트.
/// 브랜드 메인 컬러는 딥 네이비(#0B2545), 배경은 화이트 위주.
class AppColors {
  AppColors._();

  // Brand
  static const Color navy = Color(0xFF0B2545);
  static const Color navyLight = Color(0xFF13315C);
  static const Color navySoft = Color(0xFF1D4E89);
  static const Color accent = Color(0xFF5FA8D3);
  static const Color accentSoft = Color(0xFFDCEEFB);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF6F8FB);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE6EBF1);
  static const Color textPrimary = Color(0xFF0B2545);
  static const Color textSecondary = Color(0xFF6B7A90);
  static const Color textHint = Color(0xFFA0AAB8);

  // Semantic
  static const Color success = Color(0xFF2BB673);
  static const Color warning = Color(0xFFF5A623);
  static const Color danger = Color(0xFFE5484D);
  static const Color star = Color(0xFFFFB800);
}
