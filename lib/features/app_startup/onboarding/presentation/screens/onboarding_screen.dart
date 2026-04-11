// onboarding/presentation/screens/onboarding_screen.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../data/models/onboarding_data.dart';
import '../widgets/onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _pages = OnboardingData.list;

  // ── Background animation ──
  late AnimationController _bgController;
  late Animation<double> _bgPulse;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    _bgController = AnimationController(
        vsync: this, duration: const Duration(seconds: 5))
      ..repeat(reverse: true);
    _bgPulse =
        CurvedAnimation(parent: _bgController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage == _pages.length - 1) {
      context.go(RouteNames.login);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgPulse,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFFEDE8FF),
                    const Color(0xFFE8E2FF),
                    _bgPulse.value)!,
                  Color.lerp(
                    const Color(0xFFD8D0F8),
                    const Color(0xFFE2D8FF),
                    _bgPulse.value)!,
                  Color.lerp(
                    const Color(0xFFE8E4FF),
                    const Color(0xFFCEC8F0),
                    1 - _bgPulse.value)!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            // ── Ambient blobs ──
            _AmbientBlobs(bgPulse: _bgPulse),

            // ── Pages ──
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => OnboardingSlide(
                dataModel: _pages[i],
                buttonText: i == _pages.length - 1
                    ? AppStrings.getStarted
                    : AppStrings.next,
                currentPage: _currentPage,
                pageCount: _pages.length,
                onButtonTap: _goNext,
              ),
            ),

            // ── Skip ──
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 20,
              child: GestureDetector(
                onTap: () => context.go(RouteNames.login),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.4), width: 1),
                  ),
                  child: Text(
                    AppStrings.skip,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4A2D8A),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Ambient blobs ──
class _AmbientBlobs extends StatelessWidget {
  final Animation<double> bgPulse;
  const _AmbientBlobs({required this.bgPulse});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bgPulse,
      builder: (_, __) => Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            child: Opacity(
              opacity: 0.5 + 0.15 * bgPulse.value,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFFB39DDB),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: -60,
            child: Opacity(
              opacity: 0.3 + 0.1 * (1 - bgPulse.value),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF9575CD),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -40,
            child: Opacity(
              opacity: 0.25 + 0.1 * bgPulse.value,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF7E57C2),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}