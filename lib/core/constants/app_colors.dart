import 'package:flutter/material.dart';

class AppColors {
  // ── Base ──
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // ── Brand Gradient ──
  static const Color gradientBlue   = Color(0xFF4A90E2); // أنقى
  static const Color gradientPurple = Color(0xFF6C4AB6); // أقل حِدّة
  static const Color gradientLight  = Color(0xFF9D7BDB); // أفتح ومتوازن

  // ── Primary (alias للـ gradientPurple) ──
  static const Color primary = gradientPurple;

  // ── Backgrounds ──
  static const Color background     = Color(0xFFF7F5FF); // أهدى للعين
  static const Color cardBackground = Color(0xFFFBFAFF); // أبيض مكسور نظيف
  static const Color cardBorder     = Color(0xFFE6E1F2); // subtle border

  // ── Text ──
  static const Color textPrimary   = Color(0xFF1F1147); // contrast عالي
  static const Color textSecondary = Color(0xFF5C4E8C);
  static const Color textMuted     = Color(0xFF9A8CC3);
  static const Color textDark      = Color(0xFF140B3D); // أغمق فعليًا
  static const Color textHint      = Color(0xFFB8A9D6);

  // ── Status ──
  static const Color success = Color(0xFF22C55E); // modern green
  static const Color error   = Color(0xFFEF4444); // أوضح
  static const Color warning = Color(0xFFF59E0B); // متوازن
  static const Color grey    = Color(0xFFB0A4C8); // neutral حقيقي

  // ── Social / Accent ──
  static const Color instructionPink = Color(0xFFE11D8E); // خليها Accent

  // ── Gradient Helper ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientBlue, gradientPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF4F1FF),
      Color(0xFFF8FBFF),
      Color(0xFFF6F2FF),
    ],
  );
}


/*
class AppColors {
  // ── Base ──
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // ── Brand Gradient ──
  static const Color gradientBlue   = Color(0xFF4A90D9);
  static const Color gradientPurple = Color(0xFF7B5EA7);
  static const Color gradientLight  = Color(0xFF9B6FD4);

  // ── Primary (alias للـ gradientPurple) ──
  static const Color primary = Color(0xFF7B5EA7);

  // ── Backgrounds ──
  static const Color background     = Color(0xFFF5F0FF);
  static const Color cardBackground = Color(0xFFF8F5FF);
  static const Color cardBorder     = Color(0xFFE9E3F5);

  // ── Text ──
  static const Color textPrimary   = Color(0xFF3D2B6B);
  static const Color textSecondary = Color(0xFF6B5A9E);
  static const Color textMuted     = Color(0xFF9E86C8);
  static const Color textDark      = Color(0xFF2D1B5E);
  static const Color textHint      = Color(0xFFB8A6D9);

  // ── Status ──
  static const Color success = Color(0xFF4CAF50);
  static const Color error   = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color grey    = Color(0xFF9E86C8);

  // ── Social ──
  static const Color instructionPink = Color(0xFFE11D8E);

  // ── Gradient Helper ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientBlue, gradientPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF0EBFF),
      Color(0xFFE8F0FF),
      Color(0xFFF5EEFF),
    ],
  );
}*/

