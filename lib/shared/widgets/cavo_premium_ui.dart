import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CavoPremiumBackground extends StatelessWidget {
  final Widget child;
  final bool isLight;

  const CavoPremiumBackground({
    super.key,
    required this.child,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final baseGradient = isLight
        ? const LinearGradient(
            colors: [
              Color(0xFFF9F8F5),
              Color(0xFFF4F1EA),
              Color(0xFFEEE9DE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : const LinearGradient(
            colors: [
              Color(0xFF020202),
              Color(0xFF080808),
              Color(0xFF0F0A04),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: baseGradient),
          ),
        ),
        Positioned(
          top: -80,
          right: -20,
          child: _GlowOrb(
            size: 220,
            color: CavoColors.gold.withValues(alpha: isLight ? 0.11 : 0.18),
          ),
        ),
        Positioned(
          top: 180,
          left: -60,
          child: _GlowOrb(
            size: 180,
            color: CavoColors.goldLight.withValues(alpha: isLight ? 0.08 : 0.12),
          ),
        ),
        Positioned(
          bottom: -120,
          right: -80,
          child: _GlowOrb(
            size: 280,
            color: CavoColors.gold.withValues(alpha: isLight ? 0.08 : 0.12),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (isLight ? Colors.white : Colors.black).withValues(alpha: isLight ? 0.16 : 0.18),
                  Colors.transparent,
                  (isLight ? Colors.black : Colors.black).withValues(alpha: isLight ? 0.06 : 0.28),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class CavoGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final bool isLight;
  final Color? color;
  final List<BoxShadow>? boxShadow;

  const CavoGlassCard({
    super.key,
    required this.child,
    required this.isLight,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
    this.color,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final fill = color ??
        (isLight
            ? const Color(0xFFFFFFFF).withValues(alpha: 0.88)
            : const Color(0xFF111111).withValues(alpha: 0.94));

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(
          color: isLight
              ? CavoColors.lightBorder.withValues(alpha: 0.72)
              : CavoColors.gold.withValues(alpha: 0.14),
        ),
        color: fill,
        gradient: LinearGradient(
          colors: [
            isLight ? Colors.white.withValues(alpha: 0.88) : Colors.white.withValues(alpha: 0.03),
            Colors.white.withValues(alpha: 0.0),
            isLight ? CavoColors.lightBackground.withValues(alpha: 0.55) : Colors.black.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: (isLight ? CavoColors.lightShadow : Colors.black)
                    .withValues(alpha: isLight ? 0.16 : 0.20),
                blurRadius: isLight ? 22 : 18,
                offset: Offset(0, isLight ? 12 : 10),
              ),
            ],
      ),
      child: child,
    );
  }
}

class CavoPillTag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLight;
  final bool selected;

  const CavoPillTag({
    super.key,
    required this.label,
    required this.isLight,
    this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: selected
            ? CavoColors.gold.withValues(alpha: isLight ? 0.14 : 0.18)
            : (isLight
                ? CavoColors.lightSurfaceSoft.withValues(alpha: 0.95)
                : CavoColors.surfaceSoft.withValues(alpha: 0.88)),
        border: Border.all(
          color: selected
              ? CavoColors.gold.withValues(alpha: 0.32)
              : (isLight ? CavoColors.lightBorder : CavoColors.border),
        ),
        boxShadow: [
          if (selected)
            BoxShadow(
              color: CavoColors.gold.withValues(alpha: 0.12),
              blurRadius: 18,
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: CavoColors.gold),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: selected
                  ? (isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary)
                  : (isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class CavoSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onActionTap;
  final bool isLight;

  const CavoSectionHeader({
    super.key,
    required this.title,
    required this.isLight,
    this.subtitle,
    this.action,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.7,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (action != null)
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  Text(
                    action!,
                    style: TextStyle(
                      color: isLight ? CavoColors.goldSoft : CavoColors.gold,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isLight ? CavoColors.goldSoft : CavoColors.gold,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class CavoCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isLight;
  final double size;
  final Color? iconColor;

  const CavoCircleIconButton({
    super.key,
    required this.icon,
    required this.isLight,
    this.onTap,
    this.size = 52,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isLight ? CavoColors.lightSurface : CavoColors.surface).withValues(alpha: 0.92),
            border: Border.all(
              color: (isLight ? CavoColors.lightBorder : CavoColors.gold).withValues(alpha: isLight ? 0.8 : 0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: (isLight ? CavoColors.lightShadow : Colors.black)
                    .withValues(alpha: isLight ? 0.08 : 0.22),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: iconColor ??
                (isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

class Cavo3DHeadline extends StatelessWidget {
  final String lineOne;
  final String lineTwo;
  final bool isLight;
  final double fontSize;

  const Cavo3DHeadline({
    super.key,
    required this.lineOne,
    required this.lineTwo,
    required this.isLight,
    this.fontSize = 34,
  });

  @override
  Widget build(BuildContext context) {
    final white = isLight ? CavoColors.lightTextPrimary : Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LayeredTitle(
          text: lineOne,
          color: white,
          shadowColor: Colors.black.withValues(alpha: isLight ? 0.10 : 0.42),
          fontSize: fontSize,
        ),
        const SizedBox(height: 2),
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [Color(0xFFFFE7A0), CavoColors.gold, Color(0xFFB57C0B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: _LayeredTitle(
            text: lineTwo,
            color: Colors.white,
            shadowColor: Colors.black.withValues(alpha: 0.45),
            fontSize: fontSize + 6,
          ),
        ),
      ],
    );
  }
}

class _LayeredTitle extends StatelessWidget {
  final String text;
  final Color color;
  final Color shadowColor;
  final double fontSize;

  const _LayeredTitle({
    required this.text,
    required this.color,
    required this.shadowColor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    const fontWeight = FontWeight.w900;
    return Stack(
      children: [
        Positioned(
          left: 4,
          top: 6,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              foreground: Paint()..color = shadowColor.withValues(alpha: 0.45),
              letterSpacing: -1.2,
              height: 0.95,
            ),
          ),
        ),
        Positioned(
          left: 2,
          top: 3,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              foreground: Paint()..color = shadowColor.withValues(alpha: 0.24),
              letterSpacing: -1.2,
              height: 0.95,
            ),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            letterSpacing: -1.2,
            height: 0.95,
          ),
        ),
      ],
    );
  }
}

class CavoMetricChip extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool isLight;

  const CavoMetricChip({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return CavoGlassCard(
      isLight: isLight,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, size: 16, color: CavoColors.gold),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: secondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CavoBenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLight;

  const CavoBenefitTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return CavoGlassCard(
      isLight: isLight,
      padding: const EdgeInsets.all(14),
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CavoColors.gold.withValues(alpha: 0.12),
            ),
            child: Icon(icon, color: CavoColors.gold, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class _PremiumGridPainter extends CustomPainter {
  final Color color;

  const _PremiumGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    const gap = 22.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PremiumGridPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
