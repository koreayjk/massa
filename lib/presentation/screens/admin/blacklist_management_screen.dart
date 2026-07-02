import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/blacklist_entry.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../widgets/avatar.dart';

/// 관리자 웹 — 블랙리스트 관리.
class BlacklistManagementScreen extends StatefulWidget {
  const BlacklistManagementScreen({super.key});

  @override
  State<BlacklistManagementScreen> createState() =>
      _BlacklistManagementScreenState();
}

class _BlacklistManagementScreenState
    extends State<BlacklistManagementScreen> {
  final _repo = MockRepository.instance;
  bool _showInactiveToo = true;

  List<BlacklistEntry> get _visible => _showInactiveToo
      ? _repo.blacklist
      : _repo.blacklist.where((e) => e.active).toList();

  @override
  Widget build(BuildContext context) {
    final list = _visible;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('블랙리스트 관리',
                  style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            ),
            ElevatedButton.icon(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('수동 등록'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('활성 ${_repo.activeBlacklistCount}건. 이용이 제한된 고객·테크니션을 관리합니다.',
            style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: AppSizes.lg),
        Row(
          children: [
            Switch(
              value: _showInactiveToo,
              activeColor: AppColors.navy,
              onChanged: (v) => setState(() => _showInactiveToo = v),
            ),
            const Text('해제된 항목도 표시'),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        Expanded(
          child: list.isEmpty
              ? const Center(
                  child: Text('블랙리스트가 비어 있습니다.',
                      style: TextStyle(color: AppColors.textSecondary)),
                )
              : ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSizes.md),
                  itemBuilder: (_, i) => _entryCard(list[i]),
                ),
        ),
      ],
    );
  }

  Widget _entryCard(BlacklistEntry e) {
    return Opacity(
      opacity: e.active ? 1 : 0.55,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: e.active ? AppColors.danger.withOpacity(0.4) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Avatar(name: e.name, size: 48),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(e.name,
                          style: const TextStyle(
                              fontSize: 15.5, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentSoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(e.role.label,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navySoft)),
                      ),
                      if (!e.active) ...[
                        const SizedBox(width: 6),
                        const Text('· 해제됨',
                            style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textSecondary)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(e.reason,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 2),
                  Text('등록일 ${Formatters.date(e.addedAt)}',
                      style: const TextStyle(
                          fontSize: 11.5, color: AppColors.textHint)),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            e.active
                ? OutlinedButton(
                    onPressed: () => _toggle(e, false),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(0, 40)),
                    child: const Text('해제'),
                  )
                : OutlinedButton(
                    onPressed: () => _toggle(e, true),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                    ),
                    child: const Text('재등록'),
                  ),
          ],
        ),
      ),
    );
  }

  void _toggle(BlacklistEntry e, bool active) {
    setState(() => _repo.setBlacklistActive(e, active));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(active
              ? '${e.name} 님을 다시 블랙리스트에 등록했습니다.'
              : '${e.name} 님의 블랙리스트를 해제했습니다.')),
    );
  }

  Future<void> _showAddDialog() async {
    final nameCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    var role = BlacklistRole.customer;

    final added = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          title: const Text('블랙리스트 수동 등록'),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                      hintText: '이름 / 식별자', labelText: '대상'),
                ),
                const SizedBox(height: AppSizes.md),
                SegmentedButton<BlacklistRole>(
                  segments: const [
                    ButtonSegment(
                        value: BlacklistRole.customer, label: Text('고객')),
                    ButtonSegment(
                        value: BlacklistRole.technician, label: Text('테크니션')),
                  ],
                  selected: {role},
                  onSelectionChanged: (s) => setLocal(() => role = s.first),
                ),
                const SizedBox(height: AppSizes.md),
                TextField(
                  controller: reasonCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                      hintText: '등록 사유', labelText: '사유'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('등록'),
            ),
          ],
        ),
      ),
    );

    if (added == true) {
      setState(() {
        _repo.addToBlacklist(
          BlacklistEntry(
            id: 'bl${_repo.blacklist.length + 200}',
            name: nameCtrl.text.trim(),
            role: role,
            reason: reasonCtrl.text.trim().isEmpty
                ? '관리자 수동 등록'
                : reasonCtrl.text.trim(),
            addedAt: DateTime(2026, 7, 2),
          ),
        );
      });
    }
    nameCtrl.dispose();
    reasonCtrl.dispose();
  }
}
