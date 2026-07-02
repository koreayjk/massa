import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/ui_feedback.dart';
import '../admin/admin_dashboard_screen.dart';
import '../home/main_navigation.dart';
import '../technician/technician_home_screen.dart';
import 'signup_screen.dart';

/// 로그인 화면 (MVP: UI만, 실제 인증 없음).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  void _login() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding, vertical: AppSizes.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.spa_rounded,
                    color: AppColors.white, size: 34),
              ),
              const SizedBox(height: AppSizes.xl),
              const Text(
                '다시 오신 걸 환영해요',
                style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                '로그인하고 마사지 예약을 시작하세요.',
                style: TextStyle(
                    fontSize: 15, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSizes.xxl),
              const _FieldLabel('이메일'),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'example@email.com',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              const _FieldLabel('비밀번호'),
              TextField(
                controller: _pwCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: '비밀번호 입력',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.showComingSoon('비밀번호 찾기'),
                  child: const Text('비밀번호 찾기'),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              ElevatedButton(onPressed: _login, child: const Text('로그인')),
              const SizedBox(height: AppSizes.xl),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('또는',
                        style: TextStyle(color: AppColors.textHint)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppSizes.xl),
              _SocialButton(
                icon: Icons.chat_bubble_rounded,
                label: '카카오로 계속하기',
                background: const Color(0xFFFEE500),
                foreground: AppColors.navy,
                onTap: _login,
              ),
              const SizedBox(height: AppSizes.md),
              _SocialButton(
                icon: Icons.apple_rounded,
                label: 'Apple로 계속하기',
                background: AppColors.textPrimary,
                foreground: AppColors.white,
                onTap: _login,
              ),
              const SizedBox(height: AppSizes.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('아직 회원이 아니신가요?',
                      style: TextStyle(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SignupScreen()),
                    ),
                    child: const Text('회원가입'),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Center(
                child: TextButton.icon(
                  onPressed: () => _showDemoSheet(context),
                  icon: const Icon(Icons.grid_view_rounded,
                      size: 16, color: AppColors.textSecondary),
                  label: const Text('데모 모드 · 앱 둘러보기',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDemoSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 4, 8, 12),
                child: Text('데모 모드',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
              ),
              _demoTile(
                sheetContext,
                icon: Icons.phone_iphone_rounded,
                title: '고객 앱',
                subtitle: '검색 · 예약 · 양방향 평점',
                page: const MainNavigation(),
              ),
              _demoTile(
                sheetContext,
                icon: Icons.spa_rounded,
                title: '테크니션 앱',
                subtitle: '일정 · 고객 신고 · SOS 긴급 알림',
                page: const TechnicianHomeScreen(),
              ),
              _demoTile(
                sheetContext,
                icon: Icons.admin_panel_settings_outlined,
                title: '관리자 웹',
                subtitle: '신고 관리 · 블랙리스트 관리',
                page: const AdminDashboardScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _demoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.accentSoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.navy),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12.5)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20, color: foreground),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
      ),
    );
  }
}
