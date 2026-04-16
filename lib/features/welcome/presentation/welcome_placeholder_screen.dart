import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

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
  late final Animation<Offset> _logoSlide;
  late final Animation<Offset> _titleSlide;
  late final Animation<Offset> _cardSlide;
  late final Animation<Offset> _buttonSlide;

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

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.24),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.12, 0.62, curve: Curves.easeOutCubic),
      ),
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.28),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.22, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.34),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.34, 1.00, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CavoColors.surface,
        behavior: SnackBarBehavior.floating,
        content: const Text(
          'Next step: Home screen and bottom navigation.',
          style: TextStyle(color: CavoColors.textPrimary),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: CavoColors.border),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF050505),
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
              size: 280,
            ),
            const _GlowOrb(
              alignment: Alignment.centerLeft,
              color: Color(0x10F1D27A),
              size: 220,
            ),
            const _GlowOrb(
              alignment: Alignment.bottomCenter,
              color: Color(0x10D4AF37),
              size: 300,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _LanguageSwitcher(
                          selected: _selectedLanguage,
                          onChanged: (value) {
                            setState(() => _selectedLanguage = value);
                          },
                        ),
                      ),
                      const SizedBox(height: 22),
                      SlideTransition(
                        position: _logoSlide,
                        child: Center(
                          child: Container(
                            width: 126,
                            height: 126,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: CavoColors.gold.withValues(alpha: 0.14),
                                  blurRadius: 34,
                                  spreadRadius: 1,
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
                      const SizedBox(height: 28),
                      SlideTransition(
                        position: _titleSlide,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _BadgeLabel(text: 'CAVO'),
                            SizedBox(height: 18),
                            Text(
                              'Mirror Original',
                              style: TextStyle(
                                color: CavoColors.textPrimary,
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                height: 1.05,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Premium Footwear designed to stand apart.',
                              style: TextStyle(
                                color: CavoColors.textSecondary,
                                fontSize: 15,
                                height: 1.55,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      SlideTransition(
                        position: _cardSlide,
                        child: _FeatureCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Made for a refined shopping experience',
                                style: TextStyle(
                                  color: CavoColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: const [
                                  _InfoChip(
                                    icon: Icons.workspace_premium_rounded,
                                    label: 'Premium Finish',
                                  ),
                                  _InfoChip(
                                    icon: Icons.local_mall_outlined,
                                    label: 'Men / Women / Kids',
                                  ),
                                  _InfoChip(
                                    icon: Icons.flash_on_rounded,
                                    label: 'Smooth Experience',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: CavoColors.border),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.auto_awesome_rounded,
                                      color: CavoColors.gold,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Mirror Original • Premium Footwear',
                                        style: TextStyle(
                                          color: CavoColors.textSecondary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
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
                      const Spacer(),
                      SlideTransition(
                        position: _buttonSlide,
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: _showComingSoon,
                              child: const Text('Explore Collection'),
                            ),
                            const SizedBox(height: 14),
                            OutlinedButton(
                              onPressed: _showComingSoon,
                              child: const Text('Continue as Guest'),
                            ),
                            const SizedBox(height: 18),
                            const Center(
                              child: Text(
                                'Refined by CAVO',
                                style: TextStyle(
                                  color: CavoColors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.25,
                                ),
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
        color: CavoColors.surface.withValues(alpha: 0.90),
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

class _BadgeLabel extends StatelessWidget {
  final String text;

  const _BadgeLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: CavoColors.surface.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CavoColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: CavoColors.gold,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.3,
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final Widget child;

  const _FeatureCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CavoColors.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: CavoColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CavoColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: CavoColors.gold, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: CavoColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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