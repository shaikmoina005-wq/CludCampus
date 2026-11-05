import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';

/// Full-bleed brand cover splash — holds at least 3 seconds (matches web demo).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const _minSplash = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(_minSplash, _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    final auth = ref.read(authControllerProvider);
    if (!auth.initialized) {
      Future<void>.delayed(const Duration(milliseconds: 200), _navigate);
      return;
    }
    if (auth.isLoggedIn) {
      context.go('/home');
    } else if (auth.hasCollege) {
      context.go('/login');
    } else {
      context.go('/cover');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/branding/cludcampus-cover.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => const ColoredBox(
              color: Color(0xFFF2F4F7),
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
