import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../home/main_navigation.dart';

/// 회원가입 화면 (MVP: UI만).
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pw = TextEditingController();
  bool _agree = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _pw.dispose();
    super.dispose();
  }

  void _signup() {
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('약관에 동의해 주세요.')),
      );
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding, vertical: AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '몇 가지 정보만 입력하면 끝!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                '가입 후 바로 예약을 시작할 수 있어요.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSizes.xl),
              _labeled('이름', TextField(
                controller: _name,
                decoration: const InputDecoration(
                  hintText: '홍길동',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              )),
              _labeled('이메일', TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'example@email.com',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
              )),
              _labeled('휴대폰 번호', TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '010-0000-0000',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              )),
              _labeled('비밀번호', TextField(
                controller: _pw,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '8자 이상',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              )),
              const SizedBox(height: AppSizes.sm),
              CheckboxListTile(
                value: _agree,
                onChanged: (v) => setState(() => _agree = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.navy,
                title: const Text(
                  '이용약관 및 개인정보 처리방침에 동의합니다.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              ElevatedButton(onPressed: _signup, child: const Text('가입하기')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labeled(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 2),
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          field,
        ],
      ),
    );
  }
}
