import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/review.dart';
import '../../../../data/repositories/mock_repository.dart';
import '../../../widgets/avatar.dart';
import '../../../widgets/star_rating_input.dart';

/// 내가 받은 매너 평점 — 양방향 평점 시스템에서 테크니션이 고객을 평가한 결과.
class ReceivedRatingsScreen extends StatelessWidget {
  const ReceivedRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MockRepository.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('내 매너 평점')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          _summaryCard(repo.myMannerRating, repo.myMannerRatingCount),
          const SizedBox(height: AppSizes.lg),
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline_rounded,
                    size: 18, color: AppColors.navySoft),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '매너 평점은 방문한 관리사가 남긴 평가예요. 서로 존중하는 문화를 위해 운영됩니다.',
                    style:
                        TextStyle(fontSize: 12.5, color: AppColors.navySoft),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          const Text('받은 후기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSizes.md),
          ...repo.myReceivedReviews.map(_reviewTile),
        ],
      ),
    );
  }

  Widget _summaryCard(double rating, int count) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.navySoft],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        children: [
          Text(rating.toStringAsFixed(1),
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          StarRow(rating: rating, size: 22),
          const SizedBox(height: 8),
          Text('$count명의 관리사가 평가했어요',
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _reviewTile(Review r) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(name: r.authorName, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.authorName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(Formatters.date(r.createdAt),
                        style: const TextStyle(
                            fontSize: 11.5, color: AppColors.textHint)),
                  ],
                ),
              ),
              StarRow(rating: r.rating, size: 14),
            ],
          ),
          const SizedBox(height: 10),
          Text(r.comment,
              style: const TextStyle(
                  fontSize: 13.5, height: 1.5, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
