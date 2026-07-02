import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../data/models/service_category.dart';
import '../../../data/models/therapist.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../widgets/avatar.dart';
import '../../widgets/rating_badge.dart';
import 'booking_confirm_screen.dart';

/// 지금 바로 예약 (온디맨드) — 취향 기반으로 가까운 관리사를 즉시 매칭.
/// Glow의 5분 예약 + Maso의 강도·부위 취향 선택을 결합.
class ExpressBookingScreen extends StatefulWidget {
  const ExpressBookingScreen({super.key});

  @override
  State<ExpressBookingScreen> createState() => _ExpressBookingScreenState();
}

class _ExpressBookingScreenState extends State<ExpressBookingScreen> {
  String _service = '스웨디시';
  Intensity _intensity = Intensity.medium;
  BodyFocus _focus = BodyFocus.full;
  int _duration = 60;
  final _address = TextEditingController(text: '서울 강남구 테헤란로 123, 4층');
  bool _matching = false;
  Therapist? _matched;

  static const _services = ['스웨디시', '아로마', '딥티슈', '타이', '스포츠'];
  static const _durations = [60, 90, 120];

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  void _match() {
    setState(() => _matching = true);
    // 데모: 잠시 후 가장 평점 높은 예약가능 관리사를 매칭.
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final available = MockRepository.therapists
          .where((t) => t.available)
          .toList()
        ..sort((a, b) => b.rating.compareTo(a.rating));
      setState(() {
        _matched = available.first;
        _matching = false;
      });
    });
  }

  void _proceed() {
    final t = _matched!;
    final service = t.services.firstWhere(
      (s) => s.durationMinutes == _duration,
      orElse: () => t.services.first,
    );
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BookingConfirmScreen(
        therapist: t,
        service: service,
        scheduledAt: DateTime(2026, 7, 2, 15, 0),
        address: _address.text.trim(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('지금 바로 예약')),
      body: _matching
          ? const _MatchingView()
          : _matched != null
              ? _matchedView()
              : _formView(),
    );
  }

  Widget _formView() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  gradient: AppDecorations.brandGradient,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.bolt_rounded, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '취향만 알려주세요.\n가까운 관리사를 5분 안에 매칭해 드려요.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            height: 1.4,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              _label('서비스 종류'),
              _chipsWrap(_services, _service, (v) => setState(() => _service = v)),
              const SizedBox(height: AppSizes.xl),
              _label('강도'),
              _enumChips(Intensity.values.map((e) => e.label).toList(),
                  _intensity.label, (l) {
                setState(() => _intensity =
                    Intensity.values.firstWhere((e) => e.label == l));
              }),
              const SizedBox(height: AppSizes.xl),
              _label('집중 케어 부위'),
              _enumChips(BodyFocus.values.map((e) => e.label).toList(),
                  _focus.label, (l) {
                setState(() =>
                    _focus = BodyFocus.values.firstWhere((e) => e.label == l));
              }),
              const SizedBox(height: AppSizes.xl),
              _label('시간'),
              _chipsWrap(_durations.map((d) => '$d분').toList(), '$_duration분',
                  (v) => setState(() => _duration = int.parse(v.replaceAll('분', '')))),
              const SizedBox(height: AppSizes.xl),
              _label('방문 주소'),
              TextField(
                controller: _address,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.home_outlined),
                ),
              ),
            ],
          ),
        ),
        _bottomBar('가까운 관리사 매칭하기', _match),
      ],
    );
  }

  Widget _matchedView() {
    final t = _matched!;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            children: [
              Row(
                children: const [
                  Icon(Icons.check_circle_rounded,
                      color: AppColors.success, size: 22),
                  SizedBox(width: 8),
                  Text('매칭 완료!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 6),
              const Text('요청하신 조건에 가장 잘 맞는 관리사예요.',
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: AppSizes.lg),
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: AppDecorations.card(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Avatar(name: t.name, size: 64),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(t.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(width: 6),
                                const Icon(Icons.verified_rounded,
                                    color: AppColors.accent, size: 18),
                              ]),
                              const SizedBox(height: 4),
                              RatingBadge(
                                  rating: t.rating, reviewCount: t.reviewCount),
                              const SizedBox(height: 4),
                              Text('${t.location} · ${t.distanceKm}km',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    _summaryRow('서비스', '$_service · $_duration분'),
                    _summaryRow('강도', _intensity.label),
                    _summaryRow('집중 부위', _focus.label),
                    _summaryRow('예상 도착', '약 25분 후', last: true),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),
              Center(
                child: TextButton.icon(
                  onPressed: () => setState(() => _matched = null),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('다시 매칭'),
                ),
              ),
            ],
          ),
        ),
        _bottomBar('이 관리사로 예약하기', _proceed),
      ],
    );
  }

  Widget _summaryRow(String k, String v, {bool last = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(color: AppColors.textSecondary)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(t,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      );

  Widget _chipsWrap(List<String> items, String sel, ValueChanged<String> onSel) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((i) => _chip(i, i == sel, () => onSel(i))).toList(),
    );
  }

  Widget _enumChips(List<String> items, String sel, ValueChanged<String> onSel) =>
      _chipsWrap(items, sel, onSel);

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? AppColors.navy : AppColors.border),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }

  Widget _bottomBar(String label, VoidCallback onTap) {
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
      child: ElevatedButton(onPressed: onTap, child: Text(label)),
    );
  }
}

class _MatchingView extends StatelessWidget {
  const _MatchingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: AppDecorations.brandGradient,
              shape: BoxShape.circle,
              boxShadow: AppDecorations.brand(opacity: 0.35),
            ),
            child: const Icon(Icons.near_me_rounded,
                color: Colors.white, size: 44),
          ),
          const SizedBox(height: 24),
          const Text('가까운 관리사를 찾고 있어요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('잠시만 기다려 주세요...',
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 28),
          const SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(strokeWidth: 2.6),
          ),
        ],
      ),
    );
  }
}
