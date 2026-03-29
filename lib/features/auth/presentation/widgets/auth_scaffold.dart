import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../screens/auth_widget.dart';

class AuthScaffold extends StatefulWidget {
  final Widget child;
  final String headerTitle;
  final String headerSubtitle;
  const AuthScaffold({
    super.key,
    required this.child,
    required this.headerTitle,
    required this.headerSubtitle,
  });
  @override
  State<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<AuthScaffold>
    with TickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late AnimationController _bgCtrl;
  late Animation<double> _bgPulse;
  late AnimationController _orbitCtrl;
  late AnimationController _cardCtrl;
  late Animation<double> _cardSlide;
  late Animation<double> _cardOpacity;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _bgPulse = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);
    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardSlide = Tween<double>(
      begin: 80,
      end: 0,
    ).animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic));
    _cardOpacity = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 80), () => _cardCtrl.forward());
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _bgCtrl.dispose();
    _orbitCtrl.dispose();
    _cardCtrl.dispose();
    super.dispose();
  }

  Widget _orbitDot({
    required Size size,
    required double orbitRadius,
    required double dotSize,
    required Color color,
    required double opacity,
    required double speed,
    required double angleOffset,
  }) {
    final double cx = size.width / 2;
    final double cy = size.height * 0.22;
    final double angle = _orbitCtrl.value * 2 * math.pi * speed + angleOffset;
    final double x = cx + orbitRadius * math.cos(angle) - dotSize / 2;
    final double y = cy + orbitRadius * 0.4 * math.sin(angle) - dotSize / 2;
    return Positioned(
      left: x,
      top: y,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.6),
                blurRadius: dotSize * 2,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF0EEF8),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _bgCtrl,
          _orbitCtrl,
          _floatCtrl,
          _cardCtrl,
        ]),
        builder: (context, _) {
          final double floatOffset = math.sin(_floatCtrl.value * math.pi) * 7;
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        const Color(0xFFEEEBF8),
                        const Color(0xFFF5F2FF),
                        _bgPulse.value,
                      )!,
                      Color.lerp(
                        const Color(0xFFE8E4F5),
                        const Color(0xFFEDF0FF),
                        _bgPulse.value,
                      )!,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -80,
                left: -80,
                child: Opacity(
                  opacity: 0.14 + 0.06 * _bgPulse.value,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [Color(0xFF7C5CBF), Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),
              _orbitDot(
                size: size,
                orbitRadius: 90,
                dotSize: 6,
                color: const Color(0xFF7C5CBF),
                opacity: 0.4,
                speed: 1.0,
                angleOffset: 0.0,
              ),
              _orbitDot(
                size: size,
                orbitRadius: 110,
                dotSize: 4,
                color: const Color(0xFF3ECFCF),
                opacity: 0.35,
                speed: 0.7,
                angleOffset: 2.1,
              ),
              _orbitDot(
                size: size,
                orbitRadius: 75,
                dotSize: 5,
                color: const Color(0xFFAB8EE0),
                opacity: 0.35,
                speed: 1.3,
                angleOffset: 4.2,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: size.height * 0.37,
                child: SafeArea(
                  bottom: false,
                  child: Transform.translate(
                    offset: Offset(0, -floatOffset),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF7C5CBF,
                                    ).withOpacity(0.28 + 0.1 * _bgPulse.value),
                                    blurRadius: 40,
                                    spreadRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 118,
                              height: 118,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                    0xFF7C5CBF,
                                  ).withOpacity(0.18),
                                  width: 1,
                                ),
                              ),
                            ),
                            Image.asset(
                              AppAssets.logo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF4A2D8A),
                              Color(0xFF7C5CBF),
                              Color(0xFF9B7FD4),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'AIGENDA',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 5,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: size.height * 0.31,
                child: Transform.translate(
                  offset: Offset(0, _cardSlide.value),
                  child: Opacity(
                    opacity: _cardOpacity.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Color(0xFFFAF9FF)],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(36),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C3FC8).withOpacity(0.12),
                            blurRadius: 30,
                            offset: const Offset(0, -8),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(28, 20, 28, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthCardHeader(
                              title: widget.headerTitle,
                              subtitle: widget.headerSubtitle,
                            ),
                            const SizedBox(height: 20),
                            widget.child,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


