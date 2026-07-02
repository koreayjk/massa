import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// 별점 + 숫자 배지.
class RatingBadge extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double iconSize;

  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: AppColors.star, size: iconSize),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: iconSize * 0.85,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 3),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: iconSize * 0.8,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
