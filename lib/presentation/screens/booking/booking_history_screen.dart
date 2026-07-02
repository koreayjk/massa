import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/ui_feedback.dart';
import '../../../data/models/booking.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../widgets/avatar.dart';
import '../chat/chat_screen.dart';
import '../customer/rating/write_review_screen.dart';

/// 예약 내역 화면 — 예정 / 완료 탭.
class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('예약 내역'),
          bottom: const TabBar(
            labelColor: AppColors.navy,
            unselectedLabelColor: AppColors.textHint,
            indicatorColor: AppColors.navy,
            indicatorWeight: 2.5,
            labelStyle: TextStyle(fontWeight: FontWeight.w700),
            tabs: [Tab(text: '예정'), Tab(text: '완료')],
          ),
        ),
        body: TabBarView(
          children: [
            _BookingList(status: BookingStatus.upcoming),
            _BookingList(status: BookingStatus.completed),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final BookingStatus status;
  const _BookingList({required this.status});

  @override
  Widget build(BuildContext context) {
    final items = MockRepository.instance.bookings
        .where((b) => b.status == status)
        .toList();

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_busy_rounded,
                size: 56, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(
              status == BookingStatus.upcoming
                  ? '예정된 예약이 없어요'
                  : '완료된 예약이 없어요',
              style: const TextStyle(
                  fontSize: 15, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
      itemBuilder: (_, i) => _BookingTile(booking: items[i]),
    );
  }
}

class _BookingTile extends StatelessWidget {
  final Booking booking;
  const _BookingTile({required this.booking});

  @override
  Widget build(BuildContext context) {
    final upcoming = booking.status == BookingStatus.upcoming;
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
            children: [
              _statusBadge(booking.status),
              const Spacer(),
              Text(Formatters.dateTime(booking.scheduledAt),
                  style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Avatar(name: booking.therapist.name, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.therapist.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(booking.service.name,
                        style: const TextStyle(
                            fontSize: 13.5, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Text(Formatters.won(booking.totalPrice),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy)),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              const Icon(Icons.place_outlined,
                  size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(booking.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
              ),
            ],
          ),
          if (upcoming) ...[
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _confirmCancel(context),
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44)),
                    child: const Text('예약 취소'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ChatScreen(peerName: booking.therapist.name),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44)),
                    child: const Text('채팅하기'),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: AppSizes.md),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WriteReviewScreen(booking: booking),
                ),
              ),
              icon: const Icon(Icons.rate_review_outlined, size: 18),
              label: const Text('리뷰 작성'),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44)),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        title: const Text('예약을 취소할까요?'),
        content: Text(
            '${booking.therapist.name} 관리사 · ${Formatters.dateTime(booking.scheduledAt)}\n예약을 취소하면 되돌릴 수 없어요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dctx).pop(),
            child: const Text('닫기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dctx).pop();
              context.showToast('예약이 취소되었어요',
                  icon: Icons.cancel_outlined);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                minimumSize: const Size(88, 44)),
            child: const Text('예약 취소'),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(BookingStatus status) {
    final (color, bg) = switch (status) {
      BookingStatus.upcoming => (AppColors.navy, AppColors.accentSoft),
      BookingStatus.completed => (
          AppColors.success,
          AppColors.success.withOpacity(0.12)
        ),
      BookingStatus.cancelled => (AppColors.danger, AppColors.border),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status.label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: color)),
    );
  }
}
