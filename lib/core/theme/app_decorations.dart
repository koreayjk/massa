import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// 고품격 UI를 위한 공통 그림자·데코레이션 토큰.
class AppDecorations {
  AppDecorations._();

  /// 카드용 부드러운 그림자 (은은한 depth).
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: const Color(0xFF0E3A43).withOpacity(0.05),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];

  /// 살짝 더 도드라지는 그림자 (강조 카드/바텀시트).
  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: const Color(0xFF0E3A43).withOpacity(0.08),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
      ];

  /// 브랜드 컬러 그림자 (버튼/그라데이션 카드).
  static List<BoxShadow> brand({double opacity = 0.28}) => [
        BoxShadow(
          color: AppColors.navy.withOpacity(opacity),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ];

  /// 흰 카드 기본 데코레이션 (테두리 최소 + 소프트 섀도우).
  static BoxDecoration card({double radius = AppSizes.radiusLg}) =>
      BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.border.withOpacity(0.7)),
        boxShadow: soft,
      );

  /// COTRAS 로고 기반 블루→그린 브랜드 그라데이션.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.navy, AppColors.navySoft, AppColors.accent],
    stops: [0.0, 0.55, 1.0],
  );
}
