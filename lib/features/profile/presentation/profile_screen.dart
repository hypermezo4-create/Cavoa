import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_mode_controller.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/presentation/register_screen.dart';
import '../../main_navigation/presentation/main_navigation_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bg = isLight ? CavoColors.lightBackground : CavoColors.background;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final surfaceSoft =
        isLight ? CavoColors.lightSurfaceSoft : CavoColors.surfaceSoft;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondaryText =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final mutedText =
        isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;

    return Scaffold(
      backgroundColor: bg,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLight
                ? const [
                    Color(0xFFF8F6F1),
                    Color(0xFFF2EEE5),
                    Color(0xFFECE6DA),
                  ]
                : const [
                    Color(0xFF050505),
                    Color(0xFF080808),
                    Color(0xFF0D0A06),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data;

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user == null
                        ? 'Guest mode • Sign in for full access'
                        : (user.email ?? 'My Account'),
                    style: TextStyle(
                      color: mutedText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surface.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: border),
                      boxShadow: [
                        if (isLight)
                          BoxShadow(
                            color: CavoColors.lightShadow.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: surfaceSoft,
                            border: Border.all(color: border),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: CavoColors.gold,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName?.trim().isNotEmpty == true
                                    ? user!.displayName!
                                    : (user != null
                                        ? 'CAVO Member'
                                        : 'Guest User'),
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? 'Sign in for full access',
                                style: TextStyle(
                                  color: secondaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (user == null) ...[
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: surface.withOpacity(0.96),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('Login'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('Register'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Create an account to save your cart, manage orders, and sync your preferences.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: surface.withOpacity(0.96),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoRow(
                            label: 'Email',
                            value: user.email ?? '-',
                            primaryText: primaryText,
                            secondaryText: secondaryText,
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            label: 'Account status',
                            value: 'Signed in securely',
                            primaryText: primaryText,
                            secondaryText: secondaryText,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Logged out successfully.'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  Text(
                    'Quick Access',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickCard(
                          title: 'Cart',
                          icon: Icons.shopping_bag_outlined,
                          isLight: isLight,
                          onTap: () => MainNavigationController.instance.goTo(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickCard(
                          title: 'Checkout',
                          icon: Icons.receipt_long_rounded,
                          isLight: isLight,
                          onTap: () => MainNavigationController.instance.goTo(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickCard(
                          title: 'Links',
                          icon: Icons.link_rounded,
                          isLight: isLight,
                          onTap: () => MainNavigationController.instance.goTo(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Appearance',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ThemeToggleCard(isLight: isLight),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color primaryText;
  final Color secondaryText;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: primaryText,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isLight;
  final VoidCallback onTap;

  const _QuickCard({
    required this.title,
    required this.icon,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final textColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: surface.withOpacity(0.96),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Icon(icon, color: CavoColors.gold, size: 24),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggleCard extends StatelessWidget {
  final bool isLight;

  const _ThemeToggleCard({required this.isLight});

  @override
  Widget build(BuildContext context) {
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final glass = isLight
        ? CavoColors.glassLight.withOpacity(0.68)
        : CavoColors.glassDark.withOpacity(0.68);

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: glass,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: border),
          ),
          child: ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeModeController.instance,
            builder: (context, mode, _) {
              return Row(
                children: [
                  Expanded(
                    child: _ThemeOption(
                      label: 'Light',
                      icon: Icons.light_mode_rounded,
                      selected: mode == ThemeMode.light,
                      isLight: isLight,
                      onTap: ThemeModeController.instance.setLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ThemeOption(
                      label: 'Dark',
                      icon: Icons.dark_mode_rounded,
                      selected: mode == ThemeMode.dark,
                      isLight: isLight,
                      onTap: ThemeModeController.instance.setDark,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool isLight;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeText = isLight
        ? CavoColors.lightTextPrimary
        : CavoColors.textPrimary;
    final inactiveText = isLight
        ? CavoColors.lightTextSecondary
        : CavoColors.textSecondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected
            ? CavoColors.gold.withOpacity(0.14)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected
              ? CavoColors.gold.withOpacity(0.30)
              : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: selected ? CavoColors.gold : inactiveText,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? activeText : inactiveText,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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