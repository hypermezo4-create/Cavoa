import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../../checkout/presentation/checkout_screen.dart';
import '../../auth/presentation/login_screen.dart';
import '../data/cart_controller.dart';
import '../../main_navigation/presentation/main_navigation_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: ValueListenableBuilder<List<CartItem>>(
            valueListenable: CartController.instance,
            builder: (context, items, _) {
              return Stack(
                children: [
                  ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20, 14, 20, items.isEmpty ? 120 : 180),
                    children: [
                      CavoSectionHeader(
                        title: context.l10n.cart,
                        subtitle: items.isEmpty
                            ? context.l10n.yourCartIsEmpty
                            : '${items.length} ${items.length == 1 ? context.l10n.item : context.l10n.items} ${context.l10n.readyForCheckout}',
                        isLight: isLight,
                      ),
                      const SizedBox(height: 18),
                      if (items.isEmpty)
                        _EmptyCartView(isLight: isLight)
                      else ...[
                        ...items.asMap().entries.map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _CartItemCard(
                                  item: entry.value,
                                  index: entry.key,
                                  isLight: isLight,
                                ),
                              ),
                            ),
                        const SizedBox(height: 18),
                        CavoSectionHeader(
                          title: 'Order summary',
                          subtitle: 'Premium checkout prepared for your selected pieces.',
                          isLight: isLight,
                        ),
                        const SizedBox(height: 12),
                        CavoGlassCard(
                          isLight: isLight,
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                          child: Column(
                            children: [
                              _SummaryRow(
                                label: context.l10n.subtotal,
                                value: '${CartController.instance.subtotal} EGP',
                                isLight: isLight,
                              ),
                              const SizedBox(height: 12),
                              _SummaryRow(
                                label: context.l10n.storePickup,
                                value: '${CartController.instance.delivery} EGP',
                                isLight: isLight,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Divider(color: CavoColors.border, height: 1),
                              ),
                              _SummaryRow(
                                label: context.l10n.total,
                                value: '${CartController.instance.total} EGP',
                                isLight: isLight,
                                highlight: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (items.isNotEmpty)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 12,
                      child: SafeArea(
                        child: CavoGlassCard(
                          isLight: isLight,
                          padding: const EdgeInsets.all(14),
                          borderRadius: const BorderRadius.all(Radius.circular(28)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.l10n.total,
                                          style: TextStyle(
                                            color: secondary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${CartController.instance.total} EGP',
                                          style: const TextStyle(
                                            color: CavoColors.gold,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final user = FirebaseAuth.instance.currentUser;
                                        if (user == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: isLight ? CavoColors.lightSurface : CavoColors.surface,
                                              behavior: SnackBarBehavior.floating,
                                              content: Text(
                                                context.l10n.guestModeSignInForFullAccess,
                                                style: TextStyle(
                                                  color: isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          );
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                                          );
                                          return;
                                        }

                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                                        );
                                      },
                                      child: Text(context.l10n.proceedToCheckout),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => MainNavigationController.instance.goTo(1),
                                  child: Text(context.l10n.continueShopping),
                                ),
                              ),
                            ],
                          ),
                        ),
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

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final int index;
  final bool isLight;

  const _CartItemCard({
    required this.item,
    required this.index,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return CavoGlassCard(
      isLight: isLight,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Row(
        children: [
          Container(
            width: 106,
            height: 106,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: CavoNetworkImage(
              imageUrl: item.product.thumbnailUrl ?? item.product.coverUrl,
              borderRadius: BorderRadius.circular(24),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.brand,
                        style: const TextStyle(
                          color: CavoColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => CartController.instance.removeItem(index),
                      child: Icon(Icons.close_rounded, color: secondary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.size == null
                      ? context.l10n.noSizeSelected
                      : '${context.l10n.size}: ${item.size}',
                  style: TextStyle(
                    color: secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product.price} EGP',
                        style: const TextStyle(
                          color: CavoColors.gold,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    _QuantityControl(index: index, quantity: item.quantity, isLight: isLight),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int index;
  final int quantity;
  final bool isLight;

  const _QuantityControl({
    required this.index,
    required this.quantity,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    return CavoGlassCard(
      isLight: isLight,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(
            icon: Icons.remove_rounded,
            onTap: () => CartController.instance.decreaseQuantity(index),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$quantity',
              style: TextStyle(
                color: primary,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _QtyButton(
            icon: Icons.add_rounded,
            onTap: () => CartController.instance.increaseQuantity(index),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CavoColors.gold.withValues(alpha: 0.12),
        ),
        child: Icon(icon, color: CavoColors.gold, size: 18),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLight;
  final bool highlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isLight,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: highlight ? 15 : 13,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlight ? CavoColors.gold : textColor,
            fontSize: highlight ? 17 : 13,
            fontWeight: highlight ? FontWeight.w900 : FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  final bool isLight;

  const _EmptyCartView({required this.isLight});

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return CavoGlassCard(
      isLight: isLight,
      borderRadius: const BorderRadius.all(Radius.circular(34)),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CavoColors.gold.withValues(alpha: 0.12),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: CavoColors.gold, size: 40),
          ),
          const SizedBox(height: 18),
          Text(
            context.l10n.yourCartIsEmpty,
            style: TextStyle(
              color: primary,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.startAddingFavorites,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => MainNavigationController.instance.goTo(1),
              child: Text(context.l10n.exploreCollection),
            ),
          ),
        ],
      ),
    );
  }
}
