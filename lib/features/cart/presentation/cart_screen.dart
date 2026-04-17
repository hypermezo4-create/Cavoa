import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../data/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _showSoon(BuildContext context, String title) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: surface,
        behavior: SnackBarBehavior.floating,
        content: Text(
          '$title will be connected in the next step.',
          style: TextStyle(color: primaryText),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
    );
  }

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
        child: ValueListenableBuilder<List<CartItem>>(
          valueListenable: CartController.instance,
          builder: (context, items, _) {
            return SafeArea(
              child: items.isEmpty
                  ? _EmptyCartView(
                      isLight: isLight,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      mutedText: mutedText,
                      surface: surface,
                      border: border,
                      onContinue: () => _showSoon(context, 'Browse'),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                            children: [
                              Text(
                                'Cart',
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${items.length} item${items.length > 1 ? 's' : ''} ready for checkout',
                                style: TextStyle(
                                  color: mutedText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 22),
                              ...List.generate(
                                items.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: _CartItemCard(
                                    item: items[index],
                                    isLight: isLight,
                                    surface: surface,
                                    surfaceSoft: surfaceSoft,
                                    border: border,
                                    primaryText: primaryText,
                                    secondaryText: secondaryText,
                                    mutedText: mutedText,
                                    onPlus: () =>
                                        CartController.instance.increaseQuantity(index),
                                    onMinus: () =>
                                        CartController.instance.decreaseQuantity(index),
                                    onRemove: () =>
                                        CartController.instance.removeItem(index),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: surface.withOpacity(0.96),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: border),
                                  boxShadow: [
                                    if (isLight)
                                      BoxShadow(
                                        color:
                                            CavoColors.lightShadow.withOpacity(0.08),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    _SummaryRow(
                                      label: 'Subtotal',
                                      value:
                                          '${CartController.instance.subtotal} EGP',
                                      textColor: secondaryText,
                                    ),
                                    const SizedBox(height: 10),
                                    _SummaryRow(
                                      label: 'Delivery',
                                      value:
                                          '${CartController.instance.delivery} EGP',
                                      textColor: secondaryText,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 14),
                                      child: Divider(
                                        color: border,
                                        height: 1,
                                      ),
                                    ),
                                    _SummaryRow(
                                      label: 'Total',
                                      value: '${CartController.instance.total} EGP',
                                      textColor: primaryText,
                                      highlight: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                          decoration: BoxDecoration(
                            color: surface.withOpacity(0.96),
                            border: Border(
                              top: BorderSide(color: border),
                            ),
                          ),
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    _showSoon(context, 'Checkout'),
                                child: const Text('Proceed to Checkout'),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton(
                                onPressed: () =>
                                    _showSoon(context, 'Continue Shopping'),
                                child: const Text('Continue Shopping'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool isLight;
  final Color surface;
  final Color surfaceSoft;
  final Color border;
  final Color primaryText;
  final Color secondaryText;
  final Color mutedText;
  final VoidCallback onPlus;
  final VoidCallback onMinus;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.isLight,
    required this.surface,
    required this.surfaceSoft,
    required this.border,
    required this.primaryText,
    required this.secondaryText,
    required this.mutedText,
    required this.onPlus,
    required this.onMinus,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface.withOpacity(0.96),
        borderRadius: BorderRadius.circular(26),
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
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: surfaceSoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: CavoNetworkImage(
              imageUrl: item.product.coverUrl,
              fit: BoxFit.contain,
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.brand,
                  style: const TextStyle(
                    color: CavoColors.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.size == null ? 'No size selected' : 'Size ${item.size}',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${item.product.price} EGP',
                  style: const TextStyle(
                    color: CavoColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close_rounded,
                  color: mutedText,
                  size: 20,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: surfaceSoft,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    _QtyButton(icon: Icons.add_rounded, onTap: onPlus),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        '${item.quantity}',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _QtyButton(icon: Icons.remove_rounded, onTap: onMinus),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CavoColors.gold.withOpacity(0.12),
        ),
        child: Icon(
          icon,
          color: CavoColors.gold,
          size: 16,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final bool highlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.textColor,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: highlight ? 15 : 13,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlight ? CavoColors.gold : textColor,
            fontSize: highlight ? 16 : 13,
            fontWeight: highlight ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  final bool isLight;
  final Color primaryText;
  final Color secondaryText;
  final Color mutedText;
  final Color surface;
  final Color border;
  final VoidCallback onContinue;

  const _EmptyCartView({
    required this.isLight,
    required this.primaryText,
    required this.secondaryText,
    required this.mutedText,
    required this.surface,
    required this.border,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: surface.withOpacity(0.96),
            borderRadius: BorderRadius.circular(32),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CavoColors.gold.withOpacity(0.12),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: CavoColors.gold,
                  size: 38,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Start adding your favorite premium pieces to see them here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: onContinue,
                child: const Text('Explore Collection'),
              ),
              const SizedBox(height: 12),
              Text(
                'Mirror Original • Premium Footwear',
                style: TextStyle(
                  color: mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}