import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

Route<T> buildCavoFadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 650),
    reverseTransitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (_, animation, __) => page,
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.035),
            end: Offset.zero,
          ).animate(curved),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}

class AuthPremiumScaffold extends StatelessWidget {
  final Widget child;

  const AuthPremiumScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CavoColors.black,
      body: Stack(
        children: [
          const Positioned.fill(child: _AuthGradientBackground()),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _AuthDotPatternPainter(),
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -30,
            child: _BlurOrb(
              size: 220,
              colors: [
                CavoColors.gold.withOpacity(0.24),
                CavoColors.goldLight.withOpacity(0.06),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            top: 120,
            left: -110,
            child: _BlurOrb(
              size: 240,
              colors: [
                CavoColors.gold.withOpacity(0.11),
                CavoColors.goldLight.withOpacity(0.03),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            bottom: -90,
            left: -30,
            child: _BlurOrb(
              size: 260,
              colors: [
                CavoColors.gold.withOpacity(0.16),
                CavoColors.goldLight.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
          ),
          Positioned(
            bottom: -55,
            right: -20,
            child: _BlurOrb(
              size: 200,
              colors: [
                CavoColors.goldLight.withOpacity(0.12),
                CavoColors.gold.withOpacity(0.04),
                Colors.transparent,
              ],
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.22),
                      Colors.transparent,
                      Colors.black.withOpacity(0.30),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class AuthGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const AuthGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: CavoColors.glassDark.withOpacity(0.90),
            borderRadius: borderRadius,
            border: Border.all(
              color: CavoColors.gold.withOpacity(0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.30),
                blurRadius: 24,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: CavoColors.gold.withOpacity(0.08),
                blurRadius: 26,
                spreadRadius: 1,
              ),
            ],
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.04),
                Colors.white.withOpacity(0.015),
                Colors.black.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class AuthLogoMedallion extends StatelessWidget {
  final double size;

  const AuthLogoMedallion({
    super.key,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(0.18),
            CavoColors.gold.withOpacity(0.22),
            Colors.transparent,
          ],
          stops: const [0.0, 0.62, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: CavoColors.gold.withOpacity(0.28),
            blurRadius: 46,
            spreadRadius: 6,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.10),
          ),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.06),
              Colors.black.withOpacity(0.14),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/branding/cavo_logo_circle.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class AuthBadge extends StatelessWidget {
  final String text;
  final IconData? icon;

  const AuthBadge({
    super.key,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: CavoColors.gold.withOpacity(0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: CavoColors.gold.withOpacity(0.08),
            blurRadius: 22,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: CavoColors.goldLight),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: const TextStyle(
              color: CavoColors.goldLight,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class AuthBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AuthBackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.04),
          border: Border.all(
            color: CavoColors.gold.withOpacity(0.16),
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: CavoColors.textPrimary,
          size: 20,
        ),
      ),
    );
  }
}

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffix,
    this.onChanged,
    this.textInputAction,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isFocused
              ? CavoColors.gold.withOpacity(0.55)
              : CavoColors.gold.withOpacity(0.12),
          width: isFocused ? 1.2 : 1,
        ),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(isFocused ? 0.08 : 0.04),
            Colors.white.withOpacity(0.015),
            Colors.black.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          if (isFocused)
            BoxShadow(
              color: CavoColors.gold.withOpacity(0.16),
              blurRadius: 24,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Row(
        children: [
          Icon(widget.icon, color: CavoColors.textPrimary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              style: const TextStyle(
                color: CavoColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: CavoColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (widget.suffix != null) widget.suffix!,
        ],
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData trailingIcon;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.trailingIcon = Icons.arrow_forward_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : 0.7,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  CavoColors.goldLight,
                  CavoColors.gold,
                  CavoColors.goldSoft,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: CavoColors.gold.withOpacity(0.28),
                  blurRadius: 22,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.6,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : Text(
                          label,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
                Positioned(
                  right: 12,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.86),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.16),
                      ),
                    ),
                    child: Icon(
                      trailingIcon,
                      color: CavoColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool compact;

  const AuthOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(compact ? 18 : 24),
        child: Ink(
          height: compact ? 58 : 68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 18 : 24),
            color: Colors.white.withOpacity(0.02),
            border: Border.all(
              color: CavoColors.gold.withOpacity(0.14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, color: CavoColors.textPrimary, size: 20),
                const SizedBox(width: 12),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: CavoColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthDividerLabel extends StatelessWidget {
  final String text;

  const AuthDividerLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: CavoColors.gold.withOpacity(0.14),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(
              color: CavoColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: CavoColors.gold.withOpacity(0.14),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

class AuthIconAction extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final String? label;

  const AuthIconAction({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            height: label == null ? 70 : 78,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.025),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: CavoColors.gold.withOpacity(0.14),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                if (label != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    label!,
                    style: const TextStyle(
                      color: CavoColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthFooterLink extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onPressed;

  const AuthFooterLink({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: CavoColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              actionLabel,
              style: const TextStyle(
                color: CavoColors.goldLight,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AuthProgressDots extends StatelessWidget {
  final int activeIndex;
  final int count;

  const AuthProgressDots({
    super.key,
    required this.activeIndex,
    this.count = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == activeIndex;
        return Container(
          width: active ? 34 : 14,
          height: 14,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: active
                ? CavoColors.gold
                : Colors.white.withOpacity(0.08),
            border: Border.all(
              color: active
                  ? CavoColors.goldLight.withOpacity(0.45)
                  : CavoColors.gold.withOpacity(0.10),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: CavoColors.gold.withOpacity(0.28),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

class _BlurOrb extends StatelessWidget {
  final double size;
  final List<Color> colors;

  const _BlurOrb({
    required this.size,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 34, sigmaY: 34),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}

class _AuthGradientBackground extends StatelessWidget {
  const _AuthGradientBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF020202),
            Color(0xFF060606),
            Color(0xFF0B0804),
            Color(0xFF030303),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CavoColors.gold.withOpacity(0.20),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthDotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    const spacing = 14.0;
    const radius = 0.9;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
