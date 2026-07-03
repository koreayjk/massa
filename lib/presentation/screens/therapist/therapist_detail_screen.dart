import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/ui_feedback.dart';
import '../../../data/models/review.dart';
import '../../../data/models/therapist.dart';
import '../../widgets/avatar.dart';
import '../../widgets/rating_badge.dart';
import '../booking/booking_screen.dart';

/// 테크니션 상세 화면 — 프로필 · 평점 · 서비스 · 리뷰.
class TherapistDetailScreen extends StatelessWidget {
  final Therapist therapist;
  const TherapistDetailScreen({super.key, required this.therapist});

  void _book(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BookingScreen(therapist: therapist)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관리사 프로필'),
        actions: [
          IconButton(
            onPressed: () => context.showToast('즐겨찾기에 추가했어요',
                icon: Icons.favorite_rounded),
            icon: const Icon(Icons.favorite_border_rounded),
          ),
          IconButton(
            onPressed: () => context.showToast('공유 링크를 복사했어요',
                icon: Icons.link_rounded),
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding, AppSizes.sm, AppSizes.screenPadding, 24),
        children: [
          _profileHeader(),
          const SizedBox(height: AppSizes.xl),
          _statsRow(),
          const SizedBox(height: AppSizes.lg),
          _trustRow(),
          const SizedBox(height: AppSizes.xl),
          _section('소개'),
          const SizedBox(height: AppSizes.sm),
          Text(
            therapist.bio,
            style: const TextStyle(
                fontSize: 14.5, height: 1.6, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.xl),
          _section('전문 분야'),
          const SizedBox(height: AppSizes.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: therapist.specialties
                .map((s) => Chip(
                      label: Text(s),
                      backgroundColor: AppColors.accentSoft,
                      side: BorderSide.none,
                      labelStyle: const TextStyle(
                          color: AppColors.navySoft,
                          fontWeight: FontWeight.w600),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSizes.xl),
          _section('서비스 & 가격'),
          const SizedBox(height: AppSizes.md),
          ...therapist.services.map(_serviceTile),
          const SizedBox(height: AppSizes.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _section('리뷰 ${therapist.reviewCount}개'),
              RatingBadge(rating: therapist.rating),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          ...therapist.reviews.map(_reviewTile),
        ],
      ),
      bottomNavigationBar: _bookingBar(context),
    );
  }

  Widget _profileHeader() {
    return Row(
      children: [
        Hero(
          tag: 'therapist-avatar-${therapist.id}',
          child: Material(
            type: MaterialType.transparency,
            child: Avatar(name: therapist.name, size: 84),
          ),
        ),
        const SizedBox(width: AppSizes.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(therapist.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 6),
                  if (therapist.verified)
                    const Icon(Icons.verified_rounded,
                        color: AppColors.accent, size: 20),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.place_outlined,
                      size: 15, color: AppColors.textSecondary),
                  const SizedBox(width: 2),
                  Text('${therapist.location} · ${therapist.distanceKm}km',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13.5)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: therapist.available
                      ? AppColors.success.withOpacity(0.12)
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  therapist.available ? '● 지금 예약 가능' : '● 오늘 마감',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: therapist.available
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _stat(therapist.rating.toStringAsFixed(1), '평점'),
          _divider(),
          _stat('${therapist.reviewCount}', '리뷰'),
          _divider(),
          _stat('${therapist.services.length}', '서비스'),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 12.5, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 32, color: AppColors.border);

  /// 신뢰 배지 — 신원인증 · 건강검진 · 안심결제 (Maso 참고).
  Widget _trustRow() {
    return Row(
      children: [
        _trustChip(Icons.verified_user_rounded, '신원인증'),
        const SizedBox(width: 8),
        _trustChip(Icons.health_and_safety_rounded, '건강검진'),
        const SizedBox(width: 8),
        _trustChip(Icons.lock_rounded, '안심결제'),
      ],
    );
  }

  Widget _trustChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.accentSoft,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.navy, size: 20),
            const SizedBox(height: 5),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navySoft)),
            const SizedBox(height: 2),
            const Text('완료',
                style: TextStyle(fontSize: 10, color: AppColors.success)),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
      );

  Widget _serviceTile(service) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text('${Formatters.duration(service.durationMinutes)} · ${service.description}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12.5, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(Formatters.won(service.price),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy)),
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
              RatingBadge(rating: r.rating, iconSize: 14),
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

  Widget _bookingBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.screenPadding,
        AppSizes.md,
        AppSizes.screenPadding,
        AppSizes.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('시작가',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              Text('${Formatters.won(therapist.minPrice)} ~',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy)),
            ],
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: ElevatedButton(
              onPressed: therapist.available ? () => _book(context) : null,
              child: Text(therapist.available ? '예약하기' : '예약 마감'),
            ),
          ),
        ],
      ),
    );
  }
}
