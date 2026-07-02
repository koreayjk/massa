import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/blacklist_entry.dart';
import '../../../data/models/report.dart';
import '../../../data/repositories/mock_repository.dart';

/// 관리자 웹 — 신고 관리 시스템.
class ReportManagementScreen extends StatefulWidget {
  const ReportManagementScreen({super.key});

  @override
  State<ReportManagementScreen> createState() =>
      _ReportManagementScreenState();
}

class _ReportManagementScreenState extends State<ReportManagementScreen> {
  final _repo = MockRepository.instance;
  ReportStatus? _filter; // null = 전체

  List<Report> get _filtered => _filter == null
      ? _repo.reports
      : _repo.reports.where((r) => r.status == _filter).toList();

  static (Color, Color) statusColors(ReportStatus s) => switch (s) {
        ReportStatus.pending => (AppColors.danger, Color(0xFFFCE8E8)),
        ReportStatus.reviewing => (AppColors.warning, Color(0xFFFDF3E2)),
        ReportStatus.resolved => (AppColors.success, Color(0xFFE6F6EE)),
        ReportStatus.dismissed => (AppColors.textSecondary, AppColors.border),
      };

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('신고 관리',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('접수된 신고를 검토하고 조치합니다. 접수 대기 ${_repo.pendingReportCount}건.',
            style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: AppSizes.lg),
        _filterBar(),
        const SizedBox(height: AppSizes.lg),
        Expanded(
          child: list.isEmpty
              ? const Center(
                  child: Text('해당 상태의 신고가 없습니다.',
                      style: TextStyle(color: AppColors.textSecondary)),
                )
              : ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSizes.md),
                  itemBuilder: (_, i) => _reportCard(list[i]),
                ),
        ),
      ],
    );
  }

  Widget _filterBar() {
    final filters = <(String, ReportStatus?)>[
      ('전체', null),
      ('접수', ReportStatus.pending),
      ('처리중', ReportStatus.reviewing),
      ('처리완료', ReportStatus.resolved),
      ('반려', ReportStatus.dismissed),
    ];
    return Wrap(
      spacing: 8,
      children: filters.map((f) {
        final selected = _filter == f.$2;
        return ChoiceChip(
          label: Text(f.$1),
          selected: selected,
          onSelected: (_) => setState(() => _filter = f.$2),
          showCheckmark: false,
          labelStyle: TextStyle(
            color: selected ? AppColors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }

  Widget _reportCard(Report r) {
    final (fg, bg) = statusColors(r.status);
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
          Row(
            children: [
              _badge(r.status.label, fg, bg),
              const SizedBox(width: 8),
              _badge(r.reason.label, AppColors.navySoft, AppColors.accentSoft),
              const Spacer(),
              Text(Formatters.dateTime(r.createdAt),
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textHint)),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              _party('신고자', '${r.reporterName} (${r.reporterRole.label})'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.arrow_forward_rounded,
                    size: 18, color: AppColors.textHint),
              ),
              _party('대상', '${r.targetName} (${r.targetRoleLabel})'),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Text(r.detail,
                style: const TextStyle(
                    fontSize: 13.5, height: 1.5, color: AppColors.textPrimary)),
          ),
          const SizedBox(height: AppSizes.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _actionButton('처리중', Icons.hourglass_top_rounded,
                  () => _setStatus(r, ReportStatus.reviewing)),
              _actionButton('처리완료', Icons.check_circle_outline_rounded,
                  () => _setStatus(r, ReportStatus.resolved)),
              _actionButton('반려', Icons.block_rounded,
                  () => _setStatus(r, ReportStatus.dismissed)),
              _actionButton('블랙리스트 등록', Icons.gpp_bad_outlined,
                  () => _addToBlacklist(r),
                  danger: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _party(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11.5, color: AppColors.textHint)),
          const SizedBox(height: 2),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _badge(String text, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
    );
  }

  Widget _actionButton(String label, IconData icon, VoidCallback onTap,
      {bool danger = false}) {
    final color = danger ? AppColors.danger : AppColors.navy;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: TextStyle(color: color, fontSize: 13)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        side: BorderSide(color: danger ? AppColors.danger : AppColors.border),
      ),
    );
  }

  void _setStatus(Report r, ReportStatus status) {
    setState(() => _repo.updateReportStatus(r, status));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('신고 상태를 "${status.label}"(으)로 변경했습니다.')),
    );
  }

  void _addToBlacklist(Report r) {
    final alreadyListed =
        _repo.blacklist.any((e) => e.name == r.targetName && e.active);
    if (alreadyListed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 블랙리스트에 등록된 대상입니다.')),
      );
      return;
    }
    setState(() {
      _repo.addToBlacklist(
        BlacklistEntry(
          id: 'bl${_repo.blacklist.length + 100}',
          name: r.targetName,
          role: r.reporterRole == ReporterRole.customer
              ? BlacklistRole.technician
              : BlacklistRole.customer,
          reason: '신고 접수: ${r.reason.label}',
          addedAt: DateTime(2026, 7, 2),
          relatedReportId: r.id,
        ),
      );
      _repo.updateReportStatus(r, ReportStatus.resolved);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${r.targetName} 님을 블랙리스트에 등록했습니다.')),
    );
  }
}
