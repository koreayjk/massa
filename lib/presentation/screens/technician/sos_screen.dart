import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/ui_feedback.dart';
import '../../../data/repositories/mock_repository.dart';

/// SOS 긴급 알림 활성 화면.
/// 테크니션이 위험 상황에서 관리자·긴급연락처에 즉시 알림을 전송한 상태.
class SosActiveScreen extends StatefulWidget {
  const SosActiveScreen({super.key});

  /// SOS 발동 전 확인 → 발동 시 이 화면으로 이동.
  static Future<void> trigger(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        icon: const Icon(Icons.warning_amber_rounded,
            color: AppColors.danger, size: 40),
        title: const Text('SOS 긴급 알림'),
        content: const Text(
          '긴급 상황인가요?\n전송 시 관리자와 등록된 긴급 연락처에\n현재 위치와 함께 즉시 알림이 발송됩니다.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('SOS 전송'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      MockRepository.instance.triggerSos();
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SosActiveScreen()),
      );
    }
  }

  @override
  State<SosActiveScreen> createState() => _SosActiveScreenState();
}

class _SosActiveScreenState extends State<SosActiveScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.danger,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.1).animate(
                  CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                ),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sos_rounded,
                      color: AppColors.white, size: 72),
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              const Text('긴급 알림이 전송되었습니다',
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSizes.md),
              const Text(
                '관리자와 긴급 연락처에\n현재 위치가 실시간으로 공유되고 있습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontSize: 14.5, height: 1.5),
              ),
              const SizedBox(height: AppSizes.xl),
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.my_location_rounded,
                        color: AppColors.white, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '위치 공유 중 · 서울 강남구 테헤란로 일대',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.showToast('112로 긴급 연결 중입니다...',
                      icon: Icons.call_rounded),
                  icon: const Icon(Icons.call_rounded),
                  label: const Text('112 긴급 통화'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.danger,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    side: const BorderSide(color: Colors.white70),
                  ),
                  child: const Text('상황 종료 (알림 해제)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
