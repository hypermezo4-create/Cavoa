import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/presentation/cart_screen.dart';
import '../../categories/presentation/categories_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../links/presentation/links_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import 'main_navigation_controller.dart';

class MainShell extends StatelessWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    if (MainNavigationController.instance.value != initialIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        MainNavigationController.instance.goTo(initialIndex);
      });
    }

    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final navBackground =
        isLight ? CavoColors.bottomBarLight : CavoColors.bottomBarDark;
    final navBorder = isLight ? CavoColors.lightBorder : CavoColors.border;
    final shadowColor =
        isLight ? CavoColors.lightShadow : Colors.black.withValues(alpha: 0.26);
    final selectedBg = isLight
        ? CavoColors.gold.withValues(alpha: 0.12)
        : CavoColors.gold.withValues(alpha: 0.16);
    final activeText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final inactiveText =
        isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;

    final pages = const [
      HomeScreen(),
      CategoriesScreen(),
      CartScreen(),
      ProfileScreen(),
      LinksScreen(),
    ];

    final l10n = context.l10n;
    final items = [
      _NavItem(icon: Icons.home_rounded, label: l10n.home),
      _NavItem(icon: Icons.grid_view_rounded, label: l10n.browse),
      _NavItem(icon: Icons.shopping_bag_outlined, label: l10n.cart),
      _NavItem(icon: Icons.person_outline_rounded, label: l10n.profile),
      _NavItem(icon: Icons.link_rounded, label: l10n.links),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      body: ValueListenableBuilder<int>(
        valueListenable: MainNavigationController.instance,
        builder: (context, currentIndex, _) {
          return IndexedStack(
            index: currentIndex,
            children: pages,
          );
        },
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
              child: ValueListenableBuilder<int>(
                valueListenable: MainNavigationController.instance,
                builder: (context, currentIndex, _) {
                  return Row(
                    children: List.generate(items.length, (index) {
                      final item = items[index];
                      final active = currentIndex == index;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => MainNavigationController.instance.goTo(index),
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
                  );
                },
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
