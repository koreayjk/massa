import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/service.dart';
import '../../../data/models/therapist.dart';
import 'booking_confirm_screen.dart';

/// 예약 화면 — 서비스 → 날짜 → 시간 → 주소.
class BookingScreen extends StatefulWidget {
  final Therapist therapist;
  const BookingScreen({super.key, required this.therapist});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Service? _service;
  DateTime? _date;
  String? _time;
  final _addressCtrl = TextEditingController();

  late DateTime _month = DateTime(_today.year, _today.month);
  static final DateTime _today = _dateOnly(DateTime(2026, 7, 2));

  static const _times = [
    '10:00', '11:00', '12:00', '13:00',
    '14:00', '15:00', '16:00', '17:00',
    '18:00', '19:00', '20:00', '21:00',
  ];

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  void initState() {
    super.initState();
    _service = widget.therapist.services.first;
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _service != null &&
      _date != null &&
      _time != null &&
      _addressCtrl.text.trim().isNotEmpty;

  void _confirm() {
    final parts = _time!.split(':');
    final scheduledAt = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingConfirmScreen(
          therapist: widget.therapist,
          service: _service!,
          scheduledAt: scheduledAt,
          address: _addressCtrl.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('예약하기')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding, AppSizes.md, AppSizes.screenPadding, 24),
        children: [
          _stepTitle('1', '서비스 선택'),
          const SizedBox(height: AppSizes.md),
          ...widget.therapist.services.map(_serviceOption),
          const SizedBox(height: AppSizes.xl),
          _stepTitle('2', '날짜 선택'),
          const SizedBox(height: AppSizes.md),
          _calendar(),
          const SizedBox(height: AppSizes.xl),
          _stepTitle('3', '시간 선택'),
          const SizedBox(height: AppSizes.md),
          _timeGrid(),
          const SizedBox(height: AppSizes.xl),
          _stepTitle('4', '방문 주소'),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _addressCtrl,
            onChanged: (_) => setState(() {}),
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: '마사지를 받으실 주소를 입력하세요\n예) 서울 강남구 테헤란로 123, 4층',
              prefixIcon: Icon(Icons.home_outlined),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _stepTitle(String num, String title) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
              color: AppColors.navy, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(num,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _serviceOption(Service s) {
    final selected = _service?.id == s.id;
    return GestureDetector(
      onTap: () => setState(() => _service = s),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.sm),
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentSoft : AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: selected ? AppColors.navy : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? AppColors.navy : AppColors.textHint,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(Formatters.duration(s.durationMinutes),
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Text(Formatters.won(s.price),
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy)),
          ],
        ),
      ),
    );
  }

  Widget _calendar() {
    final firstDay = DateTime(_month.year, _month.month, 1);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    // 월요일 시작 기준 앞쪽 공백 계산 (weekday: 월=1 … 일=7).
    final leadingBlanks = firstDay.weekday - 1;
    final canGoPrev =
        _month.isAfter(DateTime(_today.year, _today.month));

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: canGoPrev
                    ? () => setState(() =>
                        _month = DateTime(_month.year, _month.month - 1))
                    : null,
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Text(DateFormat('yyyy년 M월', 'ko_KR').format(_month),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              IconButton(
                onPressed: () => setState(() =>
                    _month = DateTime(_month.year, _month.month + 1)),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: ['월', '화', '수', '목', '금', '토', '일']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d,
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: d == '일'
                                    ? AppColors.danger
                                    : d == '토'
                                        ? AppColors.accent
                                        : AppColors.textSecondary)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...List.generate(leadingBlanks, (_) => const SizedBox()),
              ...List.generate(daysInMonth, (i) {
                final day = DateTime(_month.year, _month.month, i + 1);
                final isPast = day.isBefore(_today);
                final selected = _date != null &&
                    _dateOnly(_date!) == day;
                return GestureDetector(
                  onTap: isPast
                      ? null
                      : () => setState(() => _date = day),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.navy : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected
                            ? AppColors.white
                            : isPast
                                ? AppColors.textHint
                                : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _times.map((t) {
        final selected = _time == t;
        return GestureDetector(
          onTap: () => setState(() => _time = t),
          child: Container(
            width: (MediaQuery.of(context).size.width -
                    AppSizes.screenPadding * 2 -
                    24) /
                4,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: selected ? AppColors.navy : AppColors.border,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              t,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _bottomBar() {
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
      child: ElevatedButton(
        onPressed: _canContinue ? _confirm : null,
        child: const Text('예약 내용 확인'),
      ),
    );
  }
}
