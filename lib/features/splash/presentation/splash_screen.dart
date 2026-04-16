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

    _logoScale = Tween<double>(begin: 0.88, end: 1.00).animate(
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
    final isLight = Theme.of(context).brightness == Brightness.light;

    final titleColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final subtitleColor =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final mutedColor =
        isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;

    return Scaffold(
      backgroundColor:
          isLight ? CavoColors.lightBackground : CavoColors.background,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLight
                ? const [
                    Color(0xFFF8F6F1),
                    Color(0xFFF1ECE2),
                    Color(0xFFE9E2D5),
                  ]
                : const [
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
            _BackgroundGlow(
              alignment: Alignment.topCenter,
              color: isLight
                  ? CavoColors.heroLightGlow
                  : const Color(0x18D4AF37),
              size: 320,
            ),
            _BackgroundGlow(
              alignment: Alignment.center,
              color: isLight
                  ? const Color(0x14D4AF37)
                  : const Color(0x10D4AF37),
              size: 260,
            ),
            _BackgroundGlow(
              alignment: Alignment.bottomCenter,
              color: isLight
                  ? const Color(0x12F1D27A)
                  : const Color(0x12F1D27A),
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
                                                color: CavoColors.gold
                                                    .withValues(alpha: isLight ? 0.16 : 0.22),
                                                blurRadius: isLight ? 42 : 60,
                                                spreadRadius: isLight ? 2 : 4,
                                              ),
                                              BoxShadow(
                                                color: CavoColors.goldLight
                                                    .withValues(alpha: isLight ? 0.05 : 0.08),
                                                blurRadius: isLight ? 72 : 95,
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
                                Text(
                                  'Mirror Original',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: titleColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Premium Footwear',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: subtitleColor,
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
                          _PremiumLoadingBar(
                            controller: _loaderController,
                            isLight: isLight,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Crafted for distinction.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: mutedColor,
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
  final bool isLight;

  const _PremiumLoadingBar({
    required this.controller,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final barBg = isLight
        ? CavoColors.lightSurface.withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.05);
    final barBorder = isLight
        ? CavoColors.lightBorder.withValues(alpha: 0.80)
        : Colors.white.withValues(alpha: 0.05);

    return Container(
      width: 170,
      height: 7,
      decoration: BoxDecoration(
        color: barBg,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: barBorder),
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
                      color: CavoColors.gold.withValues(alpha: 0.32),
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
