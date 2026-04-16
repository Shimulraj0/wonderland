import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundBase = Color(0xFF000D1A);
  static const Color textPrimary = Color(0xFFFEFEFE);
  static const Color textSecondary = Color(0xCCFEFEFE);
  static const Color accent = Color(0xFFE89C30);
  
  static const Gradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE89C30),
      Color(0xFFFFDBA7),
    ],
  );
}
