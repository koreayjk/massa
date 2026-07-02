import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/report.dart';
import '../../../data/repositories/mock_repository.dart';
import 'blacklist_management_screen.dart';
import 'report_management_screen.dart';

/// 관리자 웹 포털 — 대시보드 · 신고 관리 · 블랙리스트 관리.
/// Flutter 웹 빌드로 브라우저에서 운영되는 관리자 화면.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 820;
    final pages = [
      const _OverviewPage(),
      const ReportManagementScreen(),
      const BlacklistManagementScreen(),
    ];

    final body = Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(AppSizes.xl),
      // 탭 전환 시 하위 화면(신고/블랙리스트)의 최신 데이터를 다시 읽도록 rebuild.
      child: pages[_index],
    );

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            _rail(),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('관리자 포털'),
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard_outlined), label: '대시보드'),
          NavigationDestination(
              icon: Icon(Icons.report_gmailerrorred_outlined), label: '신고'),
          NavigationDestination(
              icon: Icon(Icons.gpp_bad_outlined), label: '블랙리스트'),
        ],
      ),
    );
  }

  Widget _rail() {
    return NavigationRail(
      selectedIndex: _index,
      onDestinationSelected: (i) => setState(() => _index = i),
      backgroundColor: AppColors.white,
      labelType: NavigationRailLabelType.all,
      leading: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.spa_rounded,
                color: AppColors.white, size: 24),
          ),
          const SizedBox(height: 6),
          const Text('massa\n관리자',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11,
                  height: 1.3,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy)),
          const SizedBox(height: 16),
        ],
      ),
      selectedIconTheme: const IconThemeData(color: AppColors.navy),
      selectedLabelTextStyle: const TextStyle(
          color: AppColors.navy, fontWeight: FontWeight.w700),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: Text('대시보드'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.report_gmailerrorred_outlined),
          selectedIcon: Icon(Icons.report_rounded),
          label: Text('신고 관리'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.gpp_bad_outlined),
          selectedIcon: Icon(Icons.gpp_bad_rounded),
          label: Text('블랙리스트'),
        ),
      ],
    );
  }
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();

  @override
  Widget build(BuildContext context) {
    final repo = MockRepository.instance;
    final recent = repo.reports.take(3).toList();
    return ListView(
      children: [
        const Text('대시보드',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('플랫폼 안전 현황 요약',
            style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: AppSizes.lg),
        Wrap(
          spacing: AppSizes.md,
          runSpacing: AppSizes.md,
          children: [
            _statCard('접수 대기 신고', '${repo.pendingReportCount}',
                Icons.mark_email_unread_outlined, AppColors.danger),
            _statCard(
                '전체 신고',
                '${repo.reports.length}',
                Icons.report_gmailerrorred_outlined,
                AppColors.navy),
            _statCard('활성 블랙리스트', '${repo.activeBlacklistCount}',
                Icons.gpp_bad_outlined, AppColors.warning),
            _statCard('SOS 알림', '${repo.sosAlertCount}',
                Icons.sos_rounded, AppColors.danger),
          ],
        ),
        const SizedBox(height: AppSizes.xl),
        const Text('최근 신고',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSizes.md),
        ...recent.map(_recentTile),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: AppSizes.md),
          Text(value,
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _recentTile(Report r) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.flag_outlined,
              size: 18, color: AppColors.danger),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${r.reporterName} → ${r.targetName} · ${r.reason.label}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Text(r.status.label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Text(Formatters.date(r.createdAt),
              style: const TextStyle(
                  fontSize: 11.5, color: AppColors.textHint)),
        ],
      ),
    );
  }
}
