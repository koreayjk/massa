import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/therapist.dart';
import 'avatar.dart';
import 'rating_badge.dart';

/// 홈 목록에 표시되는 테크니션 카드.
class TherapistCard extends StatelessWidget {
  final Therapist therapist;
  final VoidCallback onTap;

  const TherapistCard({
    super.key,
    required this.therapist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: AppDecorations.card(radius: AppSizes.radiusLg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'therapist-avatar-${therapist.id}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Avatar(name: therapist.name, size: 64),
                  ),
                ),
                if (therapist.verified)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_rounded,
                          color: AppColors.accent, size: 18),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSizes.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          therapist.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _AvailabilityDot(available: therapist.available),
                    ],
                  ),
                  const SizedBox(height: 4),
                  RatingBadge(
                    rating: therapist.rating,
                    reviewCount: therapist.reviewCount,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 2),
                      Text(
                        '${therapist.location} · ${therapist.distanceKm}km',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: therapist.specialties
                        .map((s) => _Tag(s))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${Formatters.won(therapist.minPrice)} ~',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityDot extends StatelessWidget {
  final bool available;
  const _AvailabilityDot({required this.available});

  @override
  Widget build(BuildContext context) {
    final color = available ? AppColors.success : AppColors.textHint;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          available ? '예약가능' : '마감',
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.navySoft,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
