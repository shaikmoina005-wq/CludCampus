import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Pale blue-gray scaffold with subtle radial blue washes (demo look).
/// In dark mode uses solid dark navy scaffold (no light wash).
class WashBackground extends StatelessWidget {
  const WashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return ColoredBox(
        color: AppColors.darkBackground,
        child: child,
      );
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        gradient: RadialGradient(
          center: Alignment(-0.85, -0.9),
          radius: 1.15,
          colors: [
            Color(0xFFDBE8F3),
            AppColors.background,
          ],
          stops: [0.0, 0.55],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            right: -40,
            bottom: -60,
            child: _WashBlob(
              size: 280,
              color: Color(0xFFD5E4F2),
            ),
          ),
          const Positioned(
            left: -80,
            top: 180,
            child: _WashBlob(
              size: 220,
              color: Color(0xFFE4EAF3),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _WashBlob extends StatelessWidget {
  const _WashBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.9),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}
