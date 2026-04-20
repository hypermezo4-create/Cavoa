import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/data/cart_controller.dart';
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

    final isLight = Theme.of(context).brightness == Brightness.light;
    final navBackground = isLight
        ? CavoColors.bottomBarLight.withValues(alpha: 0.97)
        : CavoColors.bottomBarDark.withValues(alpha: 0.95);
    final navBorder = isLight ? CavoColors.lightBorder : CavoColors.border;
    final activeText = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final inactiveText = isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;

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
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ValueListenableBuilder<int>(
        valueListenable: MainNavigationController.instance,
        builder: (context, currentIndex, _) {
          return IndexedStack(index: currentIndex, children: pages);
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: navBackground,
            gradient: LinearGradient(
              colors: isLight
                  ? [
                      Colors.white.withValues(alpha: 0.98),
                      const Color(0xFFEFF4FE).withValues(alpha: 0.98),
                    ]
                  : [
                      const Color(0xFF191919).withValues(alpha: 0.98),
                      const Color(0xFF121212).withValues(alpha: 0.98),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: navBorder.withValues(alpha: isLight ? 0.9 : 0.7)),
            boxShadow: [
              BoxShadow(
                color: (isLight ? CavoColors.lightShadow : Colors.black)
                    .withValues(alpha: isLight ? 0.14 : 0.32),
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
                          behavior: HitTestBehavior.opaque,
                          onTap: () => MainNavigationController.instance.goTo(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              gradient: active
                                  ? LinearGradient(
                                      colors: [
                                        CavoColors.gold.withValues(alpha: isLight ? 0.30 : 0.24),
                                        CavoColors.gold.withValues(alpha: isLight ? 0.16 : 0.10),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                  : null,
                              border: active
                                  ? Border.all(
                                      color: CavoColors.gold.withValues(alpha: isLight ? 0.32 : 0.24),
                                    )
                                  : null,
                              boxShadow: active
                                  ? [
                                      BoxShadow(
                                        color: CavoColors.gold.withValues(alpha: isLight ? 0.20 : 0.14),
                                        blurRadius: 24,
                                        offset: const Offset(0, 8),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _NavIcon(
                                  item: item,
                                  index: index,
                                  active: active,
                                  isLight: isLight,
                                  activeText: activeText,
                                  inactiveText: inactiveText,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: active ? activeText : inactiveText,
                                    fontSize: 11,
                                    fontWeight: active ? FontWeight.w900 : FontWeight.w600,
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
    );
  }
}

class _NavIcon extends StatelessWidget {
  final _NavItem item;
  final int index;
  final bool active;
  final bool isLight;
  final Color activeText;
  final Color inactiveText;

  const _NavIcon({
    required this.item,
    required this.index,
    required this.active,
    required this.isLight,
    required this.activeText,
    required this.inactiveText,
  });

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      item.icon,
      size: 22,
      color: active ? CavoColors.gold : inactiveText,
    );

    if (index != 2) return icon;

    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: CartController.instance,
      builder: (context, items, _) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            icon,
            if (items.isNotEmpty)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: CavoColors.gold,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${items.length}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
