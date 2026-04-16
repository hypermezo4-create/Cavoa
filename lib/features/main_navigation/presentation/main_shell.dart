import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../cart/presentation/cart_screen.dart';
import '../../categories/presentation/categories_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../links/presentation/links_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
  HomeScreen(),
  CategoriesScreen(),
  CartScreen(),
  ProfileScreen(),
  LinksScreen(),
];

  final List<_NavItem> _items = const [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.grid_view_rounded, label: 'Browse'),
    _NavItem(icon: Icons.shopping_bag_outlined, label: 'Cart'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
    _NavItem(icon: Icons.link_rounded, label: 'Links'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final navBackground =
        isLight ? CavoColors.bottomBarLight : CavoColors.bottomBarDark;
    final navBorder =
        isLight ? CavoColors.lightBorder : CavoColors.border;
    final shadowColor =
        isLight ? CavoColors.lightShadow : Colors.black.withValues(alpha: 0.26);
    final selectedBg = isLight
        ? CavoColors.gold.withValues(alpha: 0.12)
        : CavoColors.gold.withValues(alpha: 0.16);
    final activeText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final inactiveText =
        isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: navBackground,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: navBorder),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  final active = _currentIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _currentIndex = index),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: active ? selectedBg : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.icon,
                              size: 22,
                              color: active ? CavoColors.gold : inactiveText,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: active ? activeText : inactiveText,
                                fontSize: 11,
                                fontWeight:
                                    active ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.label,
  });
}
