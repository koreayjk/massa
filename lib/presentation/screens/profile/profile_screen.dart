import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../widgets/avatar.dart';
import '../../widgets/star_rating_input.dart';
import '../auth/login_screen.dart';
import '../customer/rating/received_ratings_screen.dart';

class _MenuItem {
  final IconData icon;
  final String label;
  final String? trailing;
  const _MenuItem(this.icon, this.label, {this.trailing});
}

/// 마이페이지 — 프로필 · Wallet · 멤버십 · 설정.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _account = [
    _MenuItem(Icons.person_outline_rounded, '내 정보 수정'),
    _MenuItem(Icons.favorite_border_rounded, '즐겨찾기'),
    _MenuItem(Icons.local_offer_outlined, '쿠폰', trailing: '3장'),
    _MenuItem(Icons.location_on_outlined, '주소 관리'),
  ];

  static const _support = [
    _MenuItem(Icons.notifications_none_rounded, '알림 설정'),
    _MenuItem(Icons.headset_mic_outlined, '고객센터'),
    _MenuItem(Icons.description_outlined, '이용약관'),
    _MenuItem(Icons.info_outline_rounded, '앱 정보', trailing: 'v0.1.0'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('마이페이지'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          _profileCard(),
          const SizedBox(height: AppSizes.md),
          _mannerRatingTile(context),
          const SizedBox(height: AppSizes.md),
          _walletMembership(),
          const SizedBox(height: AppSizes.xl),
          _sectionLabel('계정'),
          _menuGroup(_account),
          const SizedBox(height: AppSizes.xl),
          _sectionLabel('지원'),
          _menuGroup(_support),
          const SizedBox(height: AppSizes.xl),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            ),
            icon: const Icon(Icons.logout_rounded,
                size: 18, color: AppColors.danger),
            label: const Text('로그아웃',
                style: TextStyle(color: AppColors.danger)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Avatar(name: '김학병', size: 60),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('김학병',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
                SizedBox(height: 3),
                Text('imamerica2414@gmail.com',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.textHint),
        ],
      ),
    );
  }

  Widget _mannerRatingTile(BuildContext context) {
    final repo = MockRepository.instance;
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ReceivedRatingsScreen()),
      ),
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.handshake_outlined,
                color: AppColors.navy, size: 22),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('내 매너 평점',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
            StarRow(rating: repo.myMannerRating, size: 16),
            const SizedBox(width: 6),
            Text(repo.myMannerRating.toStringAsFixed(1),
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy)),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _walletMembership() {
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
              children: [
                Row(
                  children: const [
                    Icon(Icons.workspace_premium_rounded,
                        color: AppColors.star, size: 18),
                    SizedBox(width: 4),
                    Text('GOLD 멤버',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Wallet 잔액',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 2),
                Text(Formatters.won(48000),
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                const Text('2,400 P 보유',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.navy,
              minimumSize: const Size(88, 40),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('충전'),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: AppSizes.sm),
      child: Text(text,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary)),
    );
  }

  Widget _menuGroup(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            ListTile(
              leading: Icon(items[i].icon, color: AppColors.navy, size: 22),
              title: Text(items[i].label,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (items[i].trailing != null)
                    Text(items[i].trailing!,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textHint),
                ],
              ),
              onTap: () {},
            ),
            if (i < items.length - 1)
              const Divider(
                  height: 1, indent: 54, endIndent: 16),
          ],
        ],
      ),
    );
  }
}
