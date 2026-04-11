// onboarding/presentation/widgets/onboarding_slide.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/onboarding_model.dart';
import 'onboarding_page_indicator.dart';

class OnboardingSlide extends StatefulWidget {
  final OnboardingModel dataModel;
  final String buttonText;
  final int currentPage;
  final int pageCount;
  final VoidCallback onButtonTap;

  const OnboardingSlide({
    super.key,
    required this.dataModel,
    required this.buttonText,
    required this.currentPage,
    required this.pageCount,
    required this.onButtonTap,
  });

  @override
  State<OnboardingSlide> createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<OnboardingSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // ── Image area ──
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 52,
                left: 32,
                right: 32,
              ),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: _ImageFrame(image: widget.dataModel.image),
              ),
            ),
          ),
        ),

        // ── Glass Card ──
        SlideTransition(
          position: _slideAnim,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: _GlassCard(
              height: size.height * 0.38,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C5CBF).withOpacity(0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Title
                  Text(
                    widget.dataModel.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E0F5C),
                      letterSpacing: -0.3,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(
                    widget.dataModel.description,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: const Color(0xFF5C4E8C),
                      height: 1.65,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const Spacer(),

                  // Dots
                  OnboardingIndicator(
                    currentIndex: widget.currentPage,
                    length: widget.pageCount,
                  ),
                  const SizedBox(height: 20),

                  // Button
                  _GlassButton(
                    text: widget.buttonText,
                    onTap: widget.onButtonTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Image Frame ──
class _ImageFrame extends StatelessWidget {
  final String image;
  const _ImageFrame({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        // Gradient border
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB39DDB), // بنفسجي فاتح
            Color(0xFF7C5CBF), // بنفسجي
            Color(0xFF9575CD), // لافندر
            Color(0xFFCE93D8), // موف فاتح
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C5CBF).withOpacity(0.25),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF9575CD).withOpacity(0.15),
            blurRadius: 60,
            spreadRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(3), // سُمك الـ gradient border
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          // خلفية فاتحة جوه الفريم
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF0EBFF),
              const Color(0xFFEDE8FF),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Glass Card ──
class _GlassCard extends StatelessWidget {
  final Widget child;
  final double height;
  const _GlassCard({required this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.7),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 18, 28, 28),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ── Glass Button ──
class _GlassButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _GlassButton({required this.text, required this.onTap});

  @override
  State<_GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<_GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF8B6FD4), Color(0xFF5B3A9E)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C3FC8).withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFF6C3FC8).withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.text,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}