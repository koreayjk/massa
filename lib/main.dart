import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 한국어 날짜 포맷(요일/오전·오후) 초기화.
  await initializeDateFormatting('ko_KR', null);
  runApp(const MassaApp());
}

class MassaApp extends StatelessWidget {
  const MassaApp({super.key});

  /// 모바일 앱을 넓은 데스크탑/웹 화면에서 볼 때 폰 너비로 가운데 정렬.
  /// (좁은 화면=실제 모바일에서는 그대로 전체 사용)
  static const double _phoneWidth = 430;

  Widget _responsiveWrapper(BuildContext context, Widget? child) {
    final media = MediaQuery.of(context);
    if (media.size.width <= _phoneWidth + 40) return child!;
    return ColoredBox(
      color: const Color(0xFFE6ECEF),
      child: Center(
        child: Container(
          width: _phoneWidth,
          height: media.size.height,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 40,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          // 콘텐츠가 폰 너비를 기준으로 레이아웃되도록 MediaQuery 크기도 재정의.
          child: MediaQuery(
            data: media.copyWith(size: Size(_phoneWidth, media.size.height)),
            child: child!,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'massa · 홈 마사지 예약',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: _responsiveWrapper,
      home: const SplashScreen(),
    );
  }
}
