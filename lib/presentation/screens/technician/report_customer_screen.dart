import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/models/report.dart';
import '../../../data/repositories/mock_repository.dart';

/// 고객 신고 화면 — 테크니션이 고객을 신고(양방향 신고의 테크니션→고객 방향).
class ReportCustomerScreen extends StatefulWidget {
  final String customerName;
  final String? bookingId;

  const ReportCustomerScreen({
    super.key,
    required this.customerName,
    this.bookingId,
  });

  @override
  State<ReportCustomerScreen> createState() => _ReportCustomerScreenState();
}

class _ReportCustomerScreenState extends State<ReportCustomerScreen> {
  ReportReason? _reason;
  final _detailCtrl = TextEditingController();

  @override
  void dispose() {
    _detailCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _reason != null && _detailCtrl.text.trim().isNotEmpty;

  void _submit() {
    MockRepository.instance.addReport(
      Report(
        id: 'rp${MockRepository.instance.reports.length + 100}',
        reporterRole: ReporterRole.technician,
        reporterName: '나 (테크니션)',
        targetName: widget.customerName,
        bookingId: widget.bookingId,
        reason: _reason!,
        detail: _detailCtrl.text.trim(),
        createdAt: DateTime(2026, 7, 2, 20, 0),
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        title: const Text('신고가 접수되었습니다'),
        content: const Text(
            '관리자가 검토 후 조치할 예정입니다.\n신고자 정보는 비공개로 처리됩니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('고객 신고')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline_rounded,
                    color: AppColors.textSecondary),
                const SizedBox(width: 10),
                const Text('신고 대상',
                    style: TextStyle(color: AppColors.textSecondary)),
                const Spacer(),
                Text(widget.customerName,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          const Text('신고 사유',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSizes.sm),
          ...ReportReason.values.map(_reasonTile),
          const SizedBox(height: AppSizes.xl),
          const Text('상세 내용',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _detailCtrl,
            onChanged: (_) => setState(() {}),
            maxLines: 5,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: '발생한 상황을 구체적으로 작성해 주세요.\n허위 신고 시 불이익을 받을 수 있습니다.',
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
          onPressed: _canSubmit ? _submit : null,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
          child: const Text('신고 접수'),
        ),
      ),
    );
  }

  Widget _reasonTile(ReportReason reason) {
    final selected = _reason == reason;
    return GestureDetector(
      onTap: () => setState(() => _reason = reason),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.sm),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg, vertical: 14),
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
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(reason.label,
                style: const TextStyle(
                    fontSize: 14.5, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
