
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class AuthBackground extends StatefulWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppValues.animBlob,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Stack(
        children: [
          // ── Base Gradient ──
          Container(decoration: const BoxDecoration(gradient: AppColors.backgroundGradient)),

          // ── Blob Top Left ──
          Positioned(
            top: -80 + (_controller.value * 30),
            left: -60,
            child: _Blob(size: 280, color: AppColors.gradientPurple.withOpacity(0.18)),
          ),

          // ── Blob Top Right ──
          Positioned(
            top: 100 - (_controller.value * 20),
            right: -80,
            child: _Blob(size: 220, color: AppColors.gradientBlue.withOpacity(0.15)),
          ),

          // ── Blob Bottom Center ──
          Positioned(
            bottom: -60 + (_controller.value * 25),
            left: MediaQuery.of(context).size.width * 0.2,
            child: _Blob(size: 300, color: AppColors.gradientLight.withOpacity(0.12)),
          ),

          // ── Blob Bottom Right ──
          Positioned(
            bottom: 100,
            right: -40,
            child: _Blob(size: 180, color: AppColors.gradientBlue.withOpacity(0.10)),
          ),

          widget.child,
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 0.6),
          topRight: Radius.circular(size * 0.3),
          bottomLeft: Radius.circular(size * 0.4),
          bottomRight: Radius.circular(size * 0.7),
        ),
      ),
    );
  }
}
 
 