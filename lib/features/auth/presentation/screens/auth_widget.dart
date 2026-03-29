// lib/features/auth/views/auth_widgets.dart
import 'dart:math' as math;
import 'package:ajenda_app/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// SHARED WIDGETS
class AuthCardHeader extends StatelessWidget {
  final String title, subtitle;
  const AuthCardHeader({super.key, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF7C5CBF), Color(0xFFAB8EE0)]),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22, fontWeight: FontWeight.w700,
              color: const Color(0xFF1E0F5C), letterSpacing: -0.3,
            )),
        const SizedBox(height: 3),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 12.5, color: const Color(0xFF7C5CBF))),
      ],
    );
  }
}

class AuthErrorBanner extends StatelessWidget {
  final String message;
  const AuthErrorBanner({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCDD2), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFE74C3C), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFFE74C3C),
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class AuthFieldLabel extends StatelessWidget {
  final String label;
  const AuthFieldLabel({super.key, required this.label});
  @override
  Widget build(BuildContext context) => Text(label,
      style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF8A84A3)));
}

class AuthEyeToggle extends StatelessWidget {
  final bool obscure;
  final VoidCallback onToggle;
  const AuthEyeToggle({super.key, required this.obscure, required this.onToggle});
  @override
  Widget build(BuildContext context) => IconButton(
      icon: Icon(
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: const Color(0xFF8A84A3), size: 20,
      ),
      onPressed: onToggle);
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscure, enabled;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller, required this.hint,
    required this.prefixIcon, this.obscure = false,
    this.enabled = true, this.suffixIcon,
    this.keyboardType, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled,
      style: GoogleFonts.poppins(
          fontSize: 14, color: const Color(0xFF1E0F5C)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
            fontSize: 13, color: const Color(0xFFBBB8CC)),
        prefixIcon:
        Icon(prefixIcon, color: const Color(0xFF8A84A3), size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: enabled
            ? const Color(0xFFF7F5FF)
            : const Color(0xFFEFEEF5),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E4F5), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7C5CBF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8E4F5), width: 1.2),
        ),
        errorStyle: GoogleFonts.poppins(
            fontSize: 11, color: const Color(0xFFE74C3C)),
      ),
    );
  }
}

class AuthGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  const AuthGradientButton({
    super.key,
    required this.label, required this.onTap, this.isLoading = false,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity, height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: isLoading
                ? [const Color(0xFFAA99D9), const Color(0xFF8870B8)]
                : [const Color(0xFF8B6FD4), const Color(0xFF5B3A9E)],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: isLoading ? [] : [
            BoxShadow(
                color: const Color(0xFF6C3FC8).withOpacity(0.38),
                blurRadius: 18, offset: const Offset(0, 8))
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(width: 22, height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
              : Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w600,
                  color: Colors.white, letterSpacing: 0.3)),
        ),
      ),
    );
  }
}





