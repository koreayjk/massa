import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// 네트워크 이미지 없이 이름 이니셜을 표시하는 아바타.
/// (데모에서 외부 이미지 로딩 없이 안정적으로 동작)
class Avatar extends StatelessWidget {
  final String name;
  final double size;

  const Avatar({super.key, required this.name, this.size = 48});

  static const List<Color> _palette = [
    AppColors.navy,
    AppColors.navySoft,
    AppColors.accent,
    AppColors.success,
    AppColors.warning,
  ];

  Color get _color {
    if (name.isEmpty) return AppColors.navySoft;
    return _palette[name.codeUnitAt(0) % _palette.length];
  }

  String get _initial => name.isEmpty ? '?' : name.characters.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _initial,
        style: TextStyle(
          color: _color,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
