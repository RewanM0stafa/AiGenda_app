import 'package:flutter/material.dart';

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
  static const Color success = Color(0xFF43A047);
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
}