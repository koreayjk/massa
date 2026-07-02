import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:massa/main.dart';

void main() {
  testWidgets('스플래시 화면에 브랜드명이 표시된다', (tester) async {
    await tester.pumpWidget(const MassaApp());
    // 스플래시 타이머(1.8초)가 만료되기 전 첫 프레임을 확인.
    expect(find.text('massa'), findsOneWidget);
    expect(find.text('집에서 만나는 프리미엄 마사지'), findsOneWidget);

    // 대기 중인 타이머를 소비해 테스트가 깔끔히 종료되도록 함.
    await tester.pump(const Duration(seconds: 2));
  });
}
