import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../widgets/avatar.dart';
import 'report_customer_screen.dart';
import 'sos_screen.dart';

class _Job {
  final String customerName;
  final String service;
  final String time;
  final String address;
  final String status;
  const _Job(this.customerName, this.service, this.time, this.address,
      this.status);
}

/// 테크니션 앱 홈 — 오늘의 예약(작업) 목록.
/// 상단 고정 SOS 긴급 알림, 각 예약별 고객 신고 기능 포함.
class TechnicianHomeScreen extends StatelessWidget {
  const TechnicianHomeScreen({super.key});

  static const _jobs = [
    _Job('김민지', '스웨디시 90분', '오후 2:00', '서울 강남구 테헤란로 123, 4층', '진행중'),
    _Job('이서준', '딥티슈 60분', '오후 5:00', '서울 서초구 반포대로 45', '예약확정'),
    _Job('박지우', '아로마 90분', '오후 8:00', '서울 송파구 올림픽로 300', '예약확정'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('테크니션 · 오늘의 일정'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          _earningsCard(),
          const SizedBox(height: AppSizes.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('오늘의 예약 3건',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              Text('2026.07.02',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          ..._jobs.map((j) => _jobCard(context, j)),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => SosActiveScreen.trigger(context),
        backgroundColor: AppColors.danger,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.sos_rounded),
        label: const Text('SOS',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
      ),
    );
  }

  Widget _earningsCard() {
    return Container(
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
                Text('오늘 예상 수입',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 4),
                Text('275,000원',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.account_balance_wallet_rounded,
                color: AppColors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _jobCard(BuildContext context, _Job job) {
    final active = job.status == '진행중';
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: active ? AppColors.navy : AppColors.border,
          width: active ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.success.withOpacity(0.12)
                      : AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(job.status,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color:
                            active ? AppColors.success : AppColors.navySoft)),
              ),
              const Spacer(),
              Text(job.time,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy)),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Avatar(name: job.customerName, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.customerName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(job.service,
                        style: const TextStyle(
                            fontSize: 13.5, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              _menuButton(context, job),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              const Icon(Icons.place_outlined,
                  size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(job.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.navigation_outlined, size: 18),
                  label: const Text('내비게이션'),
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44)),
                  child: Text(active ? '체크아웃' : '체크인'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuButton(BuildContext context, _Job job) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
      onSelected: (value) {
        if (value == 'report') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  ReportCustomerScreen(customerName: job.customerName),
            ),
          );
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'chat',
          child: Row(
            children: [
              Icon(Icons.chat_bubble_outline_rounded,
                  size: 18, color: AppColors.textPrimary),
              SizedBox(width: 10),
              Text('고객과 채팅'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'report',
          child: Row(
            children: [
              Icon(Icons.flag_outlined, size: 18, color: AppColors.danger),
              SizedBox(width: 10),
              Text('고객 신고', style: TextStyle(color: AppColors.danger)),
            ],
          ),
        ),
      ],
    );
  }
}
