import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../main_navigation/presentation/main_shell.dart';
import '../../welcome/presentation/welcome_placeholder_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _pulseController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.78, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );
    _logoFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.52, curve: Curves.easeOutCubic),
    );
    _titleFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.18, 0.90, curve: Curves.easeOutCubic),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    _timer = Timer(const Duration(milliseconds: 2400), _goNext);
  }

  void _goNext() {
    if (!mounted) return;
    final next = FirebaseAuth.instance.currentUser != null
        ? const MainShell()
        : const WelcomePlaceholderScreen();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 360),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: next,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CavoColors.black,
      body: Stack(
        children: [
          Positioned(
            top: -90,
            right: -40,
            child: _GlowOrb(
              size: 240,
              color: CavoColors.gold.withValues(alpha: 0.20),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -50,
            child: _GlowOrb(
              size: 280,
              color: CavoColors.goldLight.withValues(alpha: 0.14),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.22),
                      Colors.black.withValues(alpha: 0.40),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _logoFade,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final extra = 1 + (_pulseController.value * 0.04);
                        return Transform.scale(scale: extra, child: child);
                      },
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Container(
                          width: 144,
                          height: 144,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: CavoColors.gold.withValues(alpha: 0.28),
                                blurRadius: 46,
                                spreadRadius: 3,
                              ),
                            ],
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.08),
                                CavoColors.gold.withValues(alpha: 0.12),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/branding/cavo_logo_circle.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Column(
                        children: const [
                          Text(
                            'CAVO',
                            style: TextStyle(
                              color: CavoColors.gold,
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Mirror Original • Premium Footwear',
                            style: TextStyle(
                              color: Color(0xFFCAC2B4),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

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
              color,
              color.withValues(alpha: color.opacity * 0.38),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
