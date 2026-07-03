import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/utils/ui_feedback.dart';
import '../../../data/models/service_category.dart';
import '../../../data/models/therapist.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../widgets/therapist_card.dart';
import '../booking/express_booking_screen.dart';
import '../therapist/therapist_detail_screen.dart';
import 'nearby_screen.dart';

/// 홈 화면 — 프리미엄 리디자인.
/// 그라데이션 히어로 · 즉시예약/내주변 · 카테고리 · 딜 · 추천 관리사.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _Sort {
  rating('평점순'),
  distance('거리순'),
  price('가격순');

  const _Sort(this.label);
  final String label;
}

class _HomeScreenState extends State<HomeScreen> {
  String? _category; // null = 전체
  String _query = '';
  _Sort _sort = _Sort.rating;

  List<Therapist> get _filtered {
    final list = MockRepository.therapists.where((t) {
      final matchCategory =
          _category == null || t.specialties.contains(_category);
      final matchQuery = _query.isEmpty ||
          t.name.contains(_query) ||
          t.specialties.any((s) => s.contains(_query)) ||
          t.location.contains(_query);
      return matchCategory && matchQuery;
    }).toList();
    switch (_sort) {
      case _Sort.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case _Sort.distance:
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      case _Sort.price:
        list.sort((a, b) => a.minPrice.compareTo(b.minPrice));
    }
    return list;
  }

  void _cycleSort() {
    final next =
        _Sort.values[(_sort.index + 1) % _Sort.values.length];
    setState(() => _sort = next);
  }

  void _openDetail(Therapist t) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TherapistDetailScreen(therapist: t)),
      );

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _hero(),
          const SizedBox(height: AppSizes.lg),
          _quickActions(),
          const SizedBox(height: AppSizes.xl),
          _categorySection(),
          const SizedBox(height: AppSizes.xl),
          _dealsSection(),
          const SizedBox(height: AppSizes.xl),
          _listHeader(list.length),
          const SizedBox(height: AppSizes.md),
          if (list.isEmpty)
            const _EmptyResult()
          else
            ...list.map((t) => Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSizes.screenPadding, 0, AppSizes.screenPadding, AppSizes.md),
                  child: TherapistCard(therapist: t, onTap: () => _openDetail(t)),
                )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── 그라데이션 히어로 ─────────────────────────────
  Widget _hero() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppDecorations.brandGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
          AppSizes.screenPadding,
          MediaQuery.of(context).padding.top + 12,
          AppSizes.screenPadding,
          24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.showComingSoon('지역 변경'),
                child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.place_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text('서울 강남구',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5)),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.white, size: 18),
                  ],
                ),
              ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.showComingSoon('알림'),
                child: _circleIcon(Icons.notifications_none_rounded,
                    badge: true),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text('안녕하세요, 김학병님 👋',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 6),
          const Text('오늘 어떤 힐링이\n필요하세요?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.3,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppDecorations.brand(opacity: 0.18),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: '관리사, 서비스, 지역 검색',
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.navy),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, {bool badge = false}) {
    return Stack(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        if (badge)
          Positioned(
            right: 10,
            top: 9,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  color: AppColors.warning, shape: BoxShape.circle),
            ),
          ),
      ],
    );
  }

  // ── 즉시예약 · 내 주변 ────────────────────────────
  Widget _quickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Row(
        children: [
          Expanded(
            child: _actionTile(
              icon: Icons.bolt_rounded,
              title: '지금 바로 예약',
              subtitle: '5분 즉시 매칭',
              gradient: true,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ExpressBookingScreen())),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: _actionTile(
              icon: Icons.near_me_rounded,
              title: '내 주변',
              subtitle: '가까운 관리사',
              gradient: false,
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NearbyScreen())),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          gradient: gradient ? AppDecorations.brandGradient : null,
          color: gradient ? null : AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: gradient ? null : Border.all(color: AppColors.border),
          boxShadow: gradient
              ? AppDecorations.brand(opacity: 0.25)
              : AppDecorations.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: gradient
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.accentSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: gradient ? Colors.white : AppColors.navy, size: 22),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: gradient ? Colors.white : AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 12.5,
                    color: gradient ? Colors.white70 : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  // ── 카테고리 ─────────────────────────────────────
  Widget _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('서비스',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              if (_category != null)
                GestureDetector(
                  onTap: () => setState(() => _category = null),
                  child: const Text('전체 보기',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding),
            physics: const BouncingScrollPhysics(),
            itemCount: kServiceCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) => _categoryTile(kServiceCategories[i]),
          ),
        ),
      ],
    );
  }

  Widget _categoryTile(ServiceCategory c) {
    final selected = _category == c.name;
    return GestureDetector(
      onTap: () => setState(() => _category = selected ? null : c.name),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: selected ? AppDecorations.brandGradient : null,
              color: selected ? null : AppColors.accentSoft,
              borderRadius: BorderRadius.circular(18),
              boxShadow: selected ? AppDecorations.brand(opacity: 0.25) : null,
            ),
            child: Icon(c.icon,
                color: selected ? Colors.white : AppColors.navy, size: 26),
          ),
          const SizedBox(height: 7),
          Text(c.name,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? AppColors.navy : AppColors.textSecondary)),
        ],
      ),
    );
  }

  // ── 딜 / 혜택 ────────────────────────────────────
  Widget _dealsSection() {
    final deals = [
      (
        '첫 예약 20% 할인',
        '신규 회원 전용 쿠폰',
        Icons.card_giftcard_rounded,
        AppDecorations.brandGradient
      ),
      (
        '오늘의 타임딜',
        '오후 2-5시 예약 시 15%',
        Icons.bolt_rounded,
        const LinearGradient(colors: [Color(0xFFF5A623), Color(0xFFE5844D)])
      ),
      (
        '친구 초대 이벤트',
        '초대할 때마다 5,000P',
        Icons.people_alt_rounded,
        const LinearGradient(colors: [Color(0xFF46A85E), Color(0xFF2E9C86)])
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
          child: Text('혜택 · 이벤트',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: AppSizes.md),
        SizedBox(
          height: 118,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding),
            itemCount: deals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final d = deals[i];
              return GestureDetector(
                onTap: () => context.showToast('쿠폰함에 담았어요',
                    icon: Icons.confirmation_num_rounded),
                child: Container(
                width: 260,
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  gradient: d.$4,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(d.$1,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text(d.$2,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12.5)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(d.$3, color: Colors.white, size: 26),
                    ),
                  ],
                ),
              ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _listHeader(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_category == null ? '추천 관리사 $count명' : '$_category · $count명',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          GestureDetector(
            onTap: _cycleSort,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.swap_vert_rounded,
                      size: 15, color: AppColors.navy),
                  const SizedBox(width: 4),
                  Text(_sort.label,
                      style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: AppColors.textHint),
            SizedBox(height: 12),
            Text('검색 결과가 없어요',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            SizedBox(height: 4),
            Text('다른 조건으로 검색해 보세요',
                style: TextStyle(color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }
}
