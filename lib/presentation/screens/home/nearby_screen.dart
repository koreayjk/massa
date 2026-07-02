import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../widgets/therapist_card.dart';
import '../therapist/therapist_detail_screen.dart';

/// 내 주변 — 거리순 관리사 (Glow의 Near Me).
class NearbyScreen extends StatelessWidget {
  const NearbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final list = [...MockRepository.instance.therapists]
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return Scaffold(
      appBar: AppBar(title: const Text('내 주변 관리사')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          _mapBanner(),
          const SizedBox(height: AppSizes.lg),
          Row(
            children: [
              const Icon(Icons.near_me_rounded,
                  size: 18, color: AppColors.navy),
              const SizedBox(width: 6),
              Text('가까운 순 · ${list.length}명',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          ...list.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.md),
                child: TherapistCard(
                  therapist: t,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => TherapistDetailScreen(therapist: t))),
                ),
              )),
        ],
      ),
    );
  }

  Widget _mapBanner() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: AppDecorations.brandGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: AppDecorations.brand(opacity: 0.22),
      ),
      child: Stack(
        children: [
          // 지도 느낌의 장식 원들.
          Positioned(
              left: 40,
              top: 30,
              child: _pin(Icons.person_pin_circle_rounded, 34)),
          Positioned(
              right: 60,
              top: 70,
              child: _pin(Icons.person_pin_circle_rounded, 28)),
          Positioned(
              left: 120,
              bottom: 24,
              child: _pin(Icons.person_pin_circle_rounded, 24)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.my_location_rounded,
                    color: Colors.white, size: 30),
                SizedBox(height: 8),
                Text('실시간 지도에서\n주변 관리사를 확인하세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pin(IconData icon, double size) =>
      Icon(icon, color: Colors.white.withOpacity(0.5), size: size);
}
