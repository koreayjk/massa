import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/booking.dart';
import '../../../data/models/service.dart';
import '../../../data/models/therapist.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../widgets/avatar.dart';
import '../home/main_navigation.dart';

/// 예약 확정 화면 — 요약 · 결제(UI만).
class BookingConfirmScreen extends StatefulWidget {
  final Therapist therapist;
  final Service service;
  final DateTime scheduledAt;
  final String address;
  final String? preferences; // 케어 옵션(강도 · 부위) 요약

  const BookingConfirmScreen({
    super.key,
    required this.therapist,
    required this.service,
    required this.scheduledAt,
    required this.address,
    this.preferences,
  });

  @override
  State<BookingConfirmScreen> createState() => _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends State<BookingConfirmScreen> {
  int _payment = 0; // 0: 카드, 1: 카카오페이, 2: Wallet

  static const _fee = 3000;

  int get _total => widget.service.price + _fee;

  void _pay() {
    MockRepository.instance.addBooking(
      Booking(
        id: 'b${DateTime(2026).microsecond}${MockRepository.instance.bookings.length}',
        therapist: widget.therapist,
        service: widget.service,
        scheduledAt: widget.scheduledAt,
        address: widget.address,
        totalPrice: _total,
        status: BookingStatus.upcoming,
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(scheduledAt: widget.scheduledAt),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('예약 확인')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding, AppSizes.md, AppSizes.screenPadding, 24),
        children: [
          _card(
            title: '관리사',
            child: Row(
              children: [
                Avatar(name: widget.therapist.name, size: 48),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.therapist.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(widget.therapist.location,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),
          _card(
            title: '예약 정보',
            child: Column(
              children: [
                _row(Icons.spa_outlined, '서비스', widget.service.name),
                _row(Icons.schedule_rounded, '소요시간',
                    Formatters.duration(widget.service.durationMinutes)),
                if (widget.preferences != null)
                  _row(Icons.tune_rounded, '케어 옵션', widget.preferences!),
                _row(Icons.event_rounded, '일시',
                    Formatters.dateTime(widget.scheduledAt)),
                _row(Icons.home_outlined, '주소', widget.address, last: true),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),
          _card(
            title: '결제 수단',
            child: Column(
              children: [
                _payOption(0, Icons.credit_card_rounded, '신용/체크카드'),
                _payOption(1, Icons.chat_bubble_rounded, '카카오페이'),
                _payOption(2, Icons.account_balance_wallet_outlined,
                    'Wallet 잔액', last: true),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),
          _card(
            title: '결제 금액',
            child: Column(
              children: [
                _priceRow('서비스 금액', Formatters.won(widget.service.price)),
                _priceRow('출장비', Formatters.won(_fee)),
                const Divider(height: 24),
                _priceRow('총 결제금액', Formatters.won(_total), highlight: true),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),
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
                    'MVP 데모입니다. 실제 결제는 진행되지 않아요.',
                    style: TextStyle(
                        fontSize: 12.5, color: AppColors.navySoft),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
          onPressed: _pay,
          child: Text('${Formatters.won(_total)} 결제하기'),
        ),
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary)),
          const SizedBox(height: AppSizes.md),
          child,
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value,
      {bool last = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : AppSizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          SizedBox(
            width: 60,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13.5, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _payOption(int idx, IconData icon, String label,
      {bool last = false}) {
    final selected = _payment == idx;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : AppSizes.sm),
      child: GestureDetector(
        onTap: () => setState(() => _payment = idx),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.navy),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14.5, fontWeight: FontWeight.w500)),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? AppColors.navy : AppColors.textHint,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: highlight ? 15 : 14,
                  fontWeight: highlight ? FontWeight.w700 : FontWeight.w400,
                  color: highlight
                      ? AppColors.textPrimary
                      : AppColors.textSecondary)),
          Text(value,
              style: TextStyle(
                  fontSize: highlight ? 18 : 14,
                  fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
                  color: highlight ? AppColors.navy : AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final DateTime scheduledAt;
  const _SuccessDialog({required this.scheduledAt});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: AppColors.success, size: 42),
            ),
            const SizedBox(height: AppSizes.lg),
            const Text('예약이 완료되었어요!',
                style:
                    TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              '${Formatters.dateTime(scheduledAt)}\n관리사가 방문 예정입니다.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.xl),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) =>
                          const MainNavigation(initialIndex: 1)),
                  (route) => false,
                );
              },
              child: const Text('예약 내역 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
