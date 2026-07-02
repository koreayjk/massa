import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/therapist.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../widgets/therapist_card.dart';
import '../therapist/therapist_detail_screen.dart';

/// 홈 화면 — 테크니션 목록 · 검색 · 카테고리 필터.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = MockRepository.instance;
  String _category = '전체';
  String _query = '';

  List<Therapist> get _filtered {
    return _repo.therapists.where((t) {
      final matchCategory =
          _category == '전체' || t.specialties.contains(_category);
      final matchQuery = _query.isEmpty ||
          t.name.contains(_query) ||
          t.specialties.any((s) => s.contains(_query)) ||
          t.location.contains(_query);
      return matchCategory && matchQuery;
    }).toList();
  }

  void _openDetail(Therapist t) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TherapistDetailScreen(therapist: t)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header()),
            SliverToBoxAdapter(child: _searchBar()),
            SliverToBoxAdapter(child: _categoryChips()),
            SliverToBoxAdapter(child: _promoBanner()),
            SliverToBoxAdapter(child: _listHeader(list.length)),
            if (list.isEmpty)
              const SliverToBoxAdapter(child: _EmptyResult())
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.screenPadding, 0, AppSizes.screenPadding, 24),
                sliver: SliverList.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSizes.md),
                  itemBuilder: (_, i) => TherapistCard(
                    therapist: list[i],
                    onTap: () => _openDetail(list[i]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenPadding, AppSizes.md, AppSizes.screenPadding, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.place_rounded,
                        color: AppColors.navy, size: 18),
                    SizedBox(width: 4),
                    Text('서울 강남구',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '오늘 어떤 힐링이 필요하세요?',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                side: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenPadding, AppSizes.lg, AppSizes.screenPadding, 0),
      child: TextField(
        onChanged: (v) => setState(() => _query = v),
        decoration: const InputDecoration(
          hintText: '관리사, 서비스, 지역 검색',
          prefixIcon: Icon(Icons.search_rounded),
        ),
      ),
    );
  }

  Widget _categoryChips() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding, AppSizes.md, AppSizes.screenPadding, 0),
        itemCount: MockRepository.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = MockRepository.categories[i];
          final selected = c == _category;
          return ChoiceChip(
            label: Text(c),
            selected: selected,
            onSelected: (_) => setState(() => _category = c),
            labelStyle: TextStyle(
              color: selected ? AppColors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _promoBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenPadding, AppSizes.lg, AppSizes.screenPadding, 0),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.navy, AppColors.navySoft],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('첫 예약 20% 할인',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('신규 회원 전용 쿠폰이 지급되었어요',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.card_giftcard_rounded,
                  color: AppColors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.screenPadding, AppSizes.xl, AppSizes.screenPadding, AppSizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('추천 관리사 $count명',
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w800)),
          Row(
            children: const [
              Icon(Icons.tune_rounded, size: 16, color: AppColors.textSecondary),
              SizedBox(width: 4),
              Text('평점순',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
            ],
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
            Icon(Icons.search_off_rounded,
                size: 56, color: AppColors.textHint),
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
