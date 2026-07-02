import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'massa · 홈 마사지 예약',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
