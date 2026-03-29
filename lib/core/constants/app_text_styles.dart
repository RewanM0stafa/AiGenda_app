import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; // تأكد من مسار الملف عندك

class AppTextStyles {

  // ── Splash & Onboarding ──
  static final TextStyle splashTitle = GoogleFonts.outfit(
    fontSize: 46,
    fontWeight: FontWeight.w800,
    color: Colors.white, // أو AppColors.white لو متوفرة
    letterSpacing: 7,
    height: 1,
  );

  static final TextStyle taglineAr = GoogleFonts.cairo(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.primary, // ربطناها بألوان التطبيق بتاعتك
    height: 1.5,
  );

  static final TextStyle taglineEn = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static final TextStyle buttonTextPrimary = GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // ── Auth & Links ──
  static final TextStyle authLink = GoogleFonts.outfit(
    fontSize: 13,
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
  );

  static final TextStyle hintStyle = GoogleFonts.outfit(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  // ── Logo ──
  static final TextStyle logoText = GoogleFonts.outfit(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    letterSpacing: 4,
  );

  // ── Auth Titles ──
  static final TextStyle authTitle = GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark, // تأكد إن اللون ده موجود في AppColors
    letterSpacing: 0.3,
    height: 1.2,
  );

  static final TextStyle authSubtitle = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  static final TextStyle authInstruction = GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.instructionPink, // تأكد إن اللون ده موجود في AppColors
    height: 1.5,
  );

  static final TextStyle authCardTitle = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // ── Labels ──
  static final TextStyle fieldLabel = GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint, // تأكد إن اللون ده موجود في AppColors
  );

  // ── Headlines ──
  static final TextStyle headlineLarge = GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static final TextStyle headlineMedium = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle titleMedium = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Body ──
  static final TextStyle bodyRegular = GoogleFonts.outfit(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.outfit( // ضفناها عشان كانت مستخدمة في زرار تسجيل الدخول في الـ Splash
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static final TextStyle bodySmall = GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  // ── Buttons ──
  static final TextStyle buttonText = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white, // تأكد إن اللون ده موجود في AppColors
    letterSpacing: 0.3,
  );

  // ── Links ──
  static final TextStyle link = GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );
}