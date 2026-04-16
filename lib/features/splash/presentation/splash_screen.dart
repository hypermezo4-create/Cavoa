import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../welcome/presentation/welcome_placeholder_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _loaderController;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _glowPulse;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);

    _logoFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.00, 0.45, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: 0.86, end: 1.00).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.00, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.00, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _textFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.22, 0.82, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.20, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _glowPulse = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(
        parent: _loaderController,
        curve: Curves.easeInOut,
      ),
    );

    _introController.forward();

    _navigationTimer = Timer(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (_, animation, __) => FadeTransition(
            opacity: animation,
            child: const WelcomePlaceholderScreen(),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _introController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF020202),
              Color(0xFF070707),
              Color(0xFF0D0A06),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            const _BackgroundGlow(
              alignment: Alignment.topCenter,
              color: Color(0x18D4AF37),
              size: 320,
            ),
            const _BackgroundGlow(
              alignment: Alignment.center,
              color: Color(0x10D4AF37),
              size: 260,
            ),
            const _BackgroundGlow(
              alignment: Alignment.bottomCenter,
              color: Color(0x12F1D27A),
              size: 300,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: FadeTransition(
                          opacity: _textFade,
                          child: SlideTransition(
                            position: _textSlide,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SlideTransition(
                                  position: _logoSlide,
                                  child: FadeTransition(
                                    opacity: _logoFade,
                                    child: ScaleTransition(
                                      scale: _logoScale,
                                      child: AnimatedBuilder(
                                        animation: _glowPulse,
                                        builder: (context, child) {
                                          return Transform.scale(
                                            scale: _glowPulse.value,
                                            child: child,
                                          );
                                        },
                                        child: Container(
                                          width: 178,
                                          height: 178,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: CavoColors.gold.withValues(alpha: 0.22),
                                                blurRadius: 60,
                                                spreadRadius: 4,
                                              ),
                                              BoxShadow(
                                                color: CavoColors.goldLight.withValues(alpha: 0.08),
                                                blurRadius: 95,
                                                spreadRadius: 8,
                                              ),
                                            ],
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
                                ),
                                const SizedBox(height: 30),
                                const Text(
                                  'CAVO',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CavoColors.gold,
                                    fontSize: 46,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.2,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Mirror Original',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CavoColors.textPrimary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Premium Footwear',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CavoColors.textSecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _textFade,
                      child: Column(
                        children: [
                          _PremiumLoadingBar(controller: _loaderController),
                          const SizedBox(height: 18),
                          const Text(
                            'Crafted for distinction.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CavoColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumLoadingBar extends StatelessWidget {
  final AnimationController controller;

  const _PremiumLoadingBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 7,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Align(
              alignment: Alignment(-1 + (controller.value * 2), 0),
              child: Container(
                width: 82,
                height: 7,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      CavoColors.goldSoft,
                      CavoColors.gold,
                      CavoColors.goldLight,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: [
                    BoxShadow(
                      color: CavoColors.gold.withValues(alpha: 0.40),
                      blurRadius: 14,
                      spreadRadius: 0.6,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final double size;

  const _BackgroundGlow({
    required this.alignment,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}