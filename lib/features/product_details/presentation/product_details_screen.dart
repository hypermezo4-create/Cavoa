import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/product.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../../cart/data/cart_controller.dart';
import '../../favorites/data/favorites_controller.dart';
import 'product_gallery_viewer_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final CavoProduct product;
  final String heroTagBase;

  ProductDetailsScreen({
    super.key,
    required this.product,
    String? heroTagBase,
  }) : heroTagBase = heroTagBase ?? 'product-hero-${product.id}';

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final PageController _pageController;
  late String _selectedSize;
  int _selectedIndex = 0;
  int _quantity = 1;

  List<String> get _gallery {
    final gallery = widget.product.gallery.where((item) => item.isNotEmpty).toList();
    if (gallery.isEmpty) return [widget.product.coverUrl];
    return gallery;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : '';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: surface,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(color: primary, fontWeight: FontWeight.w700),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: border),
        ),
      ),
    );
  }

  void _addToCart() {
    if (widget.product.sizes.isNotEmpty && _selectedSize.isEmpty) {
      _showMessage('${context.l10n.selectYourSize} first.');
      return;
    }

    CartController.instance.addItem(
      product: widget.product,
      size: _selectedSize.isEmpty ? null : _selectedSize,
      quantity: _quantity,
    );

    _showMessage('${widget.product.title} ${context.l10n.addedToCart}');
  }

  void _openGallery(int index) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (_, __, ___) {
          return ProductGalleryViewerScreen(
            images: _gallery,
            initialIndex: index,
            heroTag: _heroTagFor(index),
            title: widget.product.title,
          );
        },
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  String _heroTagFor(int index) => index == 0
      ? widget.heroTagBase
      : '${widget.heroTagBase}-$index';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final muted = isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: CavoGlassCard(
          isLight: isLight,
          padding: const EdgeInsets.all(14),
          borderRadius: const BorderRadius.all(Radius.circular(28)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.product.price * _quantity} EGP',
                      style: const TextStyle(
                        color: CavoColors.gold,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      _selectedSize.isEmpty
                          ? l10n.selectYourSize
                          : '${l10n.selectedSize}: $_selectedSize • Qty $_quantity',
                      style: TextStyle(
                        color: secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: Text(l10n.addToCart),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            children: [
              Row(
                children: [
                  CavoCircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    isLight: isLight,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  ValueListenableBuilder<Set<String>>(
                    valueListenable: FavoritesController.instance,
                    builder: (context, favorites, _) {
                      final isFavorite = favorites.contains(widget.product.id);
                      return CavoCircleIconButton(
                        icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        isLight: isLight,
                        iconColor: isFavorite ? CavoColors.gold : null,
                        onTap: () async {
                          final added = await FavoritesController.instance.toggle(widget.product.id);
                          if (!mounted) return;
                          _showMessage(
                            added ? context.l10n.addedToFavorites : context.l10n.removedFromFavorites,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _PremiumGallerySection(
                product: widget.product,
                isLight: isLight,
                gallery: _gallery,
                currentIndex: _selectedIndex,
                pageController: _pageController,
                heroTagFor: _heroTagFor,
                onPageChanged: (value) => setState(() => _selectedIndex = value),
                onTapImage: _openGallery,
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CavoPillTag(
                    label: widget.product.brand,
                    isLight: isLight,
                    selected: true,
                  ),
                  CavoPillTag(
                    label: widget.product.category.localizedLabel(context),
                    isLight: isLight,
                  ),
                  if (widget.product.originalPrice != null)
                    CavoPillTag(
                      label: '${_discountPercent(widget.product)}% OFF',
                      isLight: isLight,
                      selected: true,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.product.title,
                style: TextStyle(
                  color: primary,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  height: 0.98,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.product.shortDescription,
                style: TextStyle(
                  color: secondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CavoMetricChip(
                    value: '4.9',
                    label: '256 reviews',
                    icon: Icons.star_rounded,
                    isLight: isLight,
                  ),
                  CavoMetricChip(
                    value: '1.3K',
                    label: 'sold this week',
                    icon: Icons.local_fire_department_rounded,
                    isLight: isLight,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _PriceBlock(product: widget.product, isLight: isLight),
                        ),
                        _QuantityStepper(
                          quantity: _quantity,
                          onMinus: () {
                            if (_quantity == 1) return;
                            setState(() => _quantity--);
                          },
                          onPlus: () => setState(() => _quantity++),
                          isLight: isLight,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      l10n.availableSizes,
                      style: TextStyle(
                        color: primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.selectYourSize,
                      style: TextStyle(
                        color: secondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.product.sizes.map((size) {
                        final selected = _selectedSize == size;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSize = size),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: selected
                                  ? CavoColors.gold
                                  : (isLight ? Colors.white : CavoColors.surfaceSoft)
                                      .withValues(alpha: 0.90),
                              border: Border.all(
                                color: selected
                                    ? CavoColors.gold
                                    : (isLight ? CavoColors.lightBorder : CavoColors.border),
                              ),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: CavoColors.gold.withValues(alpha: 0.18),
                                        blurRadius: 18,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                size,
                                style: TextStyle(
                                  color: selected ? Colors.black : primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              CavoSectionHeader(
                title: l10n.details,
                subtitle: 'Crafted to feel elevated in hand, on foot, and on screen.',
                isLight: isLight,
              ),
              const SizedBox(height: 12),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Text(
                  widget.product.description,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.7,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: CavoBenefitTile(
                      icon: Icons.workspace_premium_rounded,
                      title: 'Premium quality',
                      subtitle: 'Mirror original finish',
                      isLight: isLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CavoBenefitTile(
                      icon: Icons.local_shipping_outlined,
                      title: 'Fast pickup',
                      subtitle: 'Hurghada store only',
                      isLight: isLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CavoBenefitTile(
                      icon: Icons.rotate_right_rounded,
                      title: 'Smooth checkout',
                      subtitle: 'Premium flow inside CAVO',
                      isLight: isLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CavoBenefitTile(
                      icon: Icons.photo_size_select_large_rounded,
                      title: 'Full-screen view',
                      subtitle: 'Tap any image for HD zoom',
                      isLight: isLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Tap the product image to open the full-screen gallery with zoom and swipe gestures.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
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

class _PremiumGallerySection extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;
  final List<String> gallery;
  final int currentIndex;
  final PageController pageController;
  final String Function(int index) heroTagFor;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onTapImage;

  const _PremiumGallerySection({
    required this.product,
    required this.isLight,
    required this.gallery,
    required this.currentIndex,
    required this.pageController,
    required this.heroTagFor,
    required this.onPageChanged,
    required this.onTapImage,
  });

  @override
  Widget build(BuildContext context) {
    return CavoGlassCard(
      isLight: isLight,
      padding: const EdgeInsets.all(14),
      borderRadius: const BorderRadius.all(Radius.circular(34)),
      child: Column(
        children: [
          SizedBox(
            height: 420,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: RadialGradient(
                        colors: [
                          CavoColors.gold.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                PageView.builder(
                  controller: pageController,
                  itemCount: gallery.length,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, index) {
                    final image = gallery[index];
                    return GestureDetector(
                      onTap: () => onTapImage(index),
                      child: Hero(
                        tag: heroTagFor(index),
                        child: CavoNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.contain,
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 14,
                  top: 14,
                  child: CavoPillTag(
                    label: product.brand,
                    isLight: isLight,
                    selected: true,
                  ),
                ),
                Positioned(
                  right: 14,
                  bottom: 14,
                  child: CavoGlassCard(
                    isLight: isLight,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.open_in_full_rounded, color: CavoColors.gold, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'HD View',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 74,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: gallery.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final selected = currentIndex == index;
                      return GestureDetector(
                        onTap: () {
                          pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: 74,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? CavoColors.gold
                                  : CavoColors.gold.withValues(alpha: 0.10),
                            ),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: CavoColors.gold.withValues(alpha: 0.16),
                                      blurRadius: 18,
                                    ),
                                  ]
                                : null,
                          ),
                          child: CavoNetworkImage(
                            imageUrl: gallery[index],
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceBlock extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;

  const _PriceBlock({required this.product, required this.isLight});

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final discount = _discountPercent(product);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.price,
          style: TextStyle(
            color: secondary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${product.price} EGP',
          style: const TextStyle(
            color: CavoColors.gold,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (product.originalPrice != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '${product.originalPrice} EGP',
                style: TextStyle(
                  color: secondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 10),
              CavoPillTag(
                label: '$discount% OFF',
                isLight: isLight,
                selected: true,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool isLight;

  const _QuantityStepper({
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    return CavoGlassCard(
      isLight: isLight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Row(
        children: [
          _QtyCircle(icon: Icons.remove_rounded, onTap: onMinus),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$quantity',
              style: TextStyle(
                color: primary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _QtyCircle(icon: Icons.add_rounded, onTap: onPlus),
        ],
      ),
    );
  }
}

class _QtyCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyCircle({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CavoColors.gold.withValues(alpha: 0.12),
        ),
        child: Icon(icon, color: CavoColors.gold),
      ),
    );
  }
}

int _discountPercent(CavoProduct product) {
  final original = product.originalPrice;
  if (original == null || original <= product.price) return 0;
  return (((original - product.price) / original) * 100).round();
}
