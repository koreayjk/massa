import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// 데모 완성도를 위한 공통 피드백 헬퍼.
/// 아직 실제 동작이 없는 보조 기능도 "반응"하게 만들어 끊김 없는 시연 흐름 제공.
extension UiFeedback on BuildContext {
  void showToast(String message, {IconData? icon}) {
    final messenger = ScaffoldMessenger.of(this);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSizes.lg),
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(message,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  /// 아직 준비 중인 기능에 대한 안내.
  void showComingSoon([String? feature]) {
    showToast(
      feature == null ? '곧 제공될 기능이에요.' : '$feature 기능은 곧 제공될 예정이에요.',
      icon: Icons.hourglass_bottom_rounded,
    );
  }
}
