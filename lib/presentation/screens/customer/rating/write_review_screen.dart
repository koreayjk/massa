import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../data/models/booking.dart';
import '../../../../data/models/review.dart';
import '../../../../data/repositories/mock_repository.dart';
import '../../../widgets/avatar.dart';
import '../../../widgets/star_rating_input.dart';

/// 리뷰 작성 화면 — 고객이 테크니션을 평가(양방향 평점의 고객→테크니션 방향).
class WriteReviewScreen extends StatefulWidget {
  final Booking booking;
  const WriteReviewScreen({super.key, required this.booking});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _rating = 5;
  final _commentCtrl = TextEditingController();
  final Set<String> _tags = {};

  static const _quickTags = [
    '시간 약속을 잘 지켜요',
    '실력이 좋아요',
    '친절해요',
    '청결해요',
    '설명이 자세해요',
    '재예약 의사 있어요',
  ];

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  String get _ratingLabel => switch (_rating) {
        5 => '최고예요!',
        4 => '좋아요',
        3 => '보통이에요',
        2 => '아쉬워요',
        _ => '별로예요',
      };

  void _submit() {
    MockRepository.instance.addCustomerReview(
      Review(
        id: 'cr${MockRepository.instance.customerWrittenReviews.length}',
        authorName: '나',
        rating: _rating.toDouble(),
        comment: _commentCtrl.text.trim().isEmpty
            ? _tags.join(', ')
            : _commentCtrl.text.trim(),
        createdAt: widget.booking.scheduledAt,
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        title: const Text('리뷰 등록 완료'),
        content: const Text('소중한 리뷰 감사합니다.\n더 나은 서비스에 반영하겠습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그
              Navigator.of(context).pop(); // 리뷰 화면
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.booking.therapist;
    return Scaffold(
      appBar: AppBar(title: const Text('리뷰 작성')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        children: [
          Column(
            children: [
              Avatar(name: t.name, size: 72),
              const SizedBox(height: AppSizes.md),
              Text(t.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(widget.booking.service.name,
                  style: const TextStyle(
                      fontSize: 13.5, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSizes.xl),
          Text('서비스는 어떠셨나요?',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSizes.lg),
          StarRatingInput(
            value: _rating,
            onChanged: (v) => setState(() => _rating = v),
            size: 44,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(_ratingLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy)),
          const SizedBox(height: AppSizes.xl),
          const Text('어떤 점이 좋았나요?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSizes.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickTags.map((tag) {
              final selected = _tags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: selected,
                onSelected: (_) => setState(() {
                  selected ? _tags.remove(tag) : _tags.add(tag);
                }),
                showCheckmark: false,
                labelStyle: TextStyle(
                  fontSize: 13,
                  color: selected ? AppColors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                selectedColor: AppColors.navy,
                backgroundColor: AppColors.white,
                side: BorderSide(
                    color: selected ? AppColors.navy : AppColors.border),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.xl),
          const Text('자세한 후기 (선택)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _commentCtrl,
            maxLines: 4,
            maxLength: 300,
            decoration: const InputDecoration(
              hintText: '경험을 자유롭게 남겨주세요.',
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
          onPressed: _submit,
          child: const Text('리뷰 등록'),
        ),
      ),
    );
  }
}
