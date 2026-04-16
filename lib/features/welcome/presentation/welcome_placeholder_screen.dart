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
      duration: const Duration(milliseconds: 1100),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _buttonsSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 1.00, curve: Curves.easeOutCubic),
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
    return Scaffold(
      backgroundColor: CavoColors.background,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
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
            const _GlowOrb(
              alignment: Alignment.topCenter,
              color: Color(0x18D4AF37),
              size: 300,
            ),
            const _GlowOrb(
              alignment: Alignment.center,
              color: Color(0x10D4AF37),
              size: 260,
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
                          selected: _selectedLanguage,
                          onChanged: (value) {
                            setState(() => _selectedLanguage = value);
                          },
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: SlideTransition(
                            position: _contentSlide,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ScaleTransition(
                                  scale: _logoScale,
                                  child: Container(
                                    width: 155,
                                    height: 155,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: CavoColors.gold.withValues(alpha: 0.18),
                                          blurRadius: 40,
                                          spreadRadius: 2,
                                        ),
                                        BoxShadow(
                                          color: CavoColors.goldLight.withValues(alpha: 0.06),
                                          blurRadius: 80,
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
                                const SizedBox(height: 28),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: CavoColors.surface.withValues(alpha: 0.92),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: CavoColors.border),
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
                                const Text(
                                  'Mirror Original',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CavoColors.textPrimary,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    height: 1.05,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'Premium Footwear designed to stand apart.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: CavoColors.textSecondary,
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
                                    color: CavoColors.surface.withValues(alpha: 0.88),
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(color: CavoColors.border),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.auto_awesome_rounded,
                                        color: CavoColors.gold,
                                        size: 18,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Mirror Original  •  Premium Footwear',
                                        style: TextStyle(
                                          color: CavoColors.textSecondary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
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
                            const Text(
                              'Refined by CAVO',
                              style: TextStyle(
                                color: CavoColors.textMuted,
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
  final ValueChanged<String> onChanged;

  const _LanguageSwitcher({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: CavoColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CavoColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangChip(
            label: 'EN',
            active: selected == 'EN',
            onTap: () => onChanged('EN'),
          ),
          const SizedBox(width: 6),
          _LangChip(
            label: 'AR',
            active: selected == 'AR',
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
  final VoidCallback onTap;

  const _LangChip({
    required this.label,
    required this.active,
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.black : CavoColors.textSecondary,
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