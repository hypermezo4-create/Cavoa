import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
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

  String _selectedLanguage = 'EN';

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

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final bg = isLight ? CavoColors.lightBackground : CavoColors.background;
    final cardBg = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final softBg =
        isLight ? CavoColors.lightSurfaceSoft : CavoColors.surfaceSoft;
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
            _GlowOrb(
              alignment: Alignment.center,
              color: isLight
                  ? const Color(0x10D4AF37)
                  : const Color(0x10D4AF37),
              size: 250,
            ),
            _GlowOrb(
              alignment: Alignment.bottomCenter,
              color: isLight
                  ? const Color(0x10F1D27A)
                  : const Color(0x10F1D27A),
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
                          selected: _selectedLanguage,
                          isLight: isLight,
                          onChanged: (value) {
                            setState(() => _selectedLanguage = value);
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
                                                color:
                                                    CavoColors.goldLight.withValues(
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
                                          border: Border.all(
                                            color: border,
                                          ),
                                          boxShadow: [
                                            if (isLight)
                                              BoxShadow(
                                                color: CavoColors.lightShadow
                                                    .withValues(alpha: 0.08),
                                                blurRadius: 14,
                                                offset: const Offset(0, 8),
                                              ),
                                          ],
                                        ),
                                        child: const Text(
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
                                        'Mirror Original',
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
                                            horizontal: 8),
                                        child: Text(
                                          'Premium Footwear designed to stand apart.',
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
                                          color: softBg.withValues(alpha: 0.90),
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          border: Border.all(
                                            color: border,
                                          ),
                                          boxShadow: [
                                            if (isLight)
                                              BoxShadow(
                                                color: CavoColors.lightShadow
                                                    .withValues(alpha: 0.06),
                                                blurRadius: 12,
                                                offset: const Offset(0, 6),
                                              ),
                                          ],
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
                                                'Mirror Original  •  Premium Footwear',
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
                              onPressed: _goToApp,
                              child: const Text('Explore Collection'),
                            ),
                            const SizedBox(height: 14),
                            OutlinedButton(
                              onPressed: _goToApp,
                              child: const Text('Continue as Guest'),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Refined by CAVO',
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
    final bg = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          if (isLight)
            BoxShadow(
              color: CavoColors.lightShadow.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangChip(
            label: 'EN',
            active: selected == 'EN',
            isLight: isLight,
            onTap: () => onChanged('EN'),
          ),
          const SizedBox(width: 6),
          _LangChip(
            label: 'AR',
            active: selected == 'AR',
            isLight: isLight,
            onTap: () => onChanged('AR'),
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final bool active;
  final bool isLight;
  final VoidCallback onTap;

  const _LangChip({
    required this.label,
    required this.active,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveText =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.black : inactiveText,
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
