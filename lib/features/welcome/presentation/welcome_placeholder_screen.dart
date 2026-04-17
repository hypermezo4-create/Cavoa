import 'package:flutter/material.dart';

import '../../../core/localization/app_locale_controller.dart';
import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/presentation/register_screen.dart';
import '../../main_navigation/presentation/main_shell.dart';

class WelcomePlaceholderScreen extends StatefulWidget {
  const WelcomePlaceholderScreen({super.key});

  @override
  State<WelcomePlaceholderScreen> createState() =>
      _WelcomePlaceholderScreenState();
}

class _WelcomePlaceholderScreenState extends State<WelcomePlaceholderScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _contentSlide;
  late final Animation<Offset> _buttonsSlide;
  late final Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    _buttonsSlide = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.28, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _logoScale = Tween<double>(
      begin: 0.92,
      end: 1.00,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MainShell(),
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final selectedLanguage = AppLocaleController.instance.code;

    final bg = isLight ? CavoColors.lightBackground : CavoColors.background;
    final cardBg = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final titleColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final bodyColor =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final mutedColor =
        isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;

    return Scaffold(
      backgroundColor: bg,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLight
                ? const [
                    Color(0xFFF8F6F1),
                    Color(0xFFF2EEE5),
                    Color(0xFFECE6DA),
                  ]
                : const [
                    Color(0xFF040404),
                    Color(0xFF090909),
                    Color(0xFF0D0B08),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            _GlowOrb(
              alignment: Alignment.topCenter,
              color: isLight
                  ? CavoColors.heroLightGlow
                  : const Color(0x18D4AF37),
              size: 300,
            ),
            const _GlowOrb(
              alignment: Alignment.center,
              color: Color(0x10D4AF37),
              size: 250,
            ),
            const _GlowOrb(
              alignment: Alignment.bottomCenter,
              color: Color(0x10F1D27A),
              size: 300,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _LanguageSwitcher(
                          selected: selectedLanguage,
                          isLight: isLight,
                          onChanged: (value) {
                            AppLocaleController.instance.setByCode(value);
                            setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: SlideTransition(
                              position: _contentSlide,
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 360,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ScaleTransition(
                                        scale: _logoScale,
                                        child: Container(
                                          width: 150,
                                          height: 150,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: CavoColors.gold.withValues(
                                                  alpha: isLight ? 0.16 : 0.18,
                                                ),
                                                blurRadius: isLight ? 34 : 40,
                                                spreadRadius: 2,
                                              ),
                                              BoxShadow(
                                                color: CavoColors.goldLight
                                                    .withValues(
                                                  alpha: isLight ? 0.05 : 0.06,
                                                ),
                                                blurRadius: isLight ? 64 : 82,
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
                                      const SizedBox(height: 26),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: cardBg.withValues(alpha: 0.92),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          border: Border.all(color: border),
                                        ),
                                        child: Text(
                                          'CAVO',
                                          style: TextStyle(
                                            color: CavoColors.gold,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.4,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 22),
                                      Text(
                                        l10n.mirrorOriginal,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: titleColor,
                                          fontSize: 34,
                                          fontWeight: FontWeight.w900,
                                          height: 1.05,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          l10n.chooseHowToContinue,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: bodyColor,
                                            fontSize: 15,
                                            height: 1.55,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 22),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: cardBg.withValues(alpha: 0.88),
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          border: Border.all(color: border),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.auto_awesome_rounded,
                                              color: CavoColors.gold,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 10),
                                            Flexible(
                                              child: Text(
                                                l10n.languageSupportSummary,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: bodyColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SlideTransition(
                        position: _buttonsSlide,
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: _goToLogin,
                              child: Text(l10n.login),
                            ),
                            const SizedBox(height: 14),
                            OutlinedButton(
                              onPressed: _goToRegister,
                              child: Text(l10n.register),
                            ),
                            const SizedBox(height: 14),
                            TextButton(
                              onPressed: _goToApp,
                              child: Text(l10n.continueAsGuest),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              l10n.refinedByCavo,
                              style: TextStyle(
                                color: mutedColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.25,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
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

class _LanguageSwitcher extends StatelessWidget {
  final String selected;
  final bool isLight;
  final ValueChanged<String> onChanged;

  const _LanguageSwitcher({
    required this.selected,
    required this.isLight,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final inactiveColor =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          _LangChip(
            label: 'EN',
            active: selected == 'EN',
            inactiveColor: inactiveColor,
            onTap: () => onChanged('EN'),
          ),
          _LangChip(
            label: 'AR',
            active: selected == 'AR',
            inactiveColor: inactiveColor,
            onTap: () => onChanged('AR'),
          ),
          _LangChip(
            label: 'RU',
            active: selected == 'RU',
            inactiveColor: inactiveColor,
            onTap: () => onChanged('RU'),
          ),
          _LangChip(
            label: 'DE',
            active: selected == 'DE',
            inactiveColor: inactiveColor,
            onTap: () => onChanged('DE'),
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _LangChip({
    required this.label,
    required this.active,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: active ? CavoColors.gold : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.black : inactiveColor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final double size;

  const _GlowOrb({
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
