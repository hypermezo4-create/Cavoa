import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/product.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../../cart/data/cart_controller.dart';

class ProductDetailsScreen extends StatefulWidget {
  final CavoProduct product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final PageController _pageController;
  int _pageIndex = 0;
  String? _selectedSize;
  bool _favorite = false;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _selectedSize =
        widget.product.sizes.isNotEmpty ? widget.product.sizes.first : null;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addToCart() {
    final l10n = context.l10n;

    CartController.instance.addItem(
      product: widget.product,
      size: _selectedSize,
      quantity: _quantity,
    );

    final sizeText = _selectedSize == null ? '' : ' • Size $_selectedSize';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? CavoColors.lightSurface
            : CavoColors.surface,
        behavior: SnackBarBehavior.floating,
        content: Text(
          '${widget.product.title} x$_quantity$sizeText ${l10n.addedToCart}',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? CavoColors.lightTextPrimary
                : CavoColors.textPrimary,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? CavoColors.lightBorder
                : CavoColors.border,
          ),
        ),
      ),
    );
  }


  String _categoryLabel(BuildContext context, ProductCategory category) {
    final l10n = context.l10n;
    switch (category) {
      case ProductCategory.women:
        return l10n.women;
      case ProductCategory.kids:
        return l10n.kids;
      case ProductCategory.men:
      default:
        return l10n.men;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final product = widget.product;
    final gallery =
        product.gallery.isEmpty ? [product.coverUrl] : product.gallery;

    final isLight = Theme.of(context).brightness == Brightness.light;
    final bg = isLight ? CavoColors.lightBackground : CavoColors.background;
    final section = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondaryText =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final mutedText =
        isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;
    final imageBg =
        isLight ? CavoColors.productImageLight : CavoColors.productImageDark;

    return Scaffold(
      backgroundColor: bg,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLight
                ? const [
                    Color(0xFFF8F6F1),
                    Color(0xFFF2EEE5),
                    Color(0xFFEDE7DB),
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
          bottom: false,
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 430,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: imageBg,
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(36),
                                  ),
                                ),
                                child: Hero(
                                  tag: 'product-${product.id}',
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount: gallery.length,
                                    onPageChanged: (index) {
                                      setState(() => _pageIndex = index);
                                    },
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          12,
                                          60,
                                          12,
                                          50,
                                        ),
                                        child: CavoNetworkImage(
                                          imageUrl: gallery[index],
                                          fit: BoxFit.contain,
                                          borderRadius:
                                              BorderRadius.circular(28),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 14,
                                left: 18,
                                right: 18,
                                child: Row(
                                  children: [
                                    _GlassIconButton(
                                      icon: Icons.arrow_back_ios_new_rounded,
                                      onTap: () => Navigator.of(context).pop(),
                                      isLight: isLight,
                                    ),
                                    const Spacer(),
                                    _GlassIconButton(
                                      icon: _favorite
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      onTap: () =>
                                          setState(() => _favorite = !_favorite),
                                      active: _favorite,
                                      isLight: isLight,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 16,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    gallery.length,
                                    (index) => AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 220),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: _pageIndex == index ? 18 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _pageIndex == index
                                            ? CavoColors.gold
                                            : mutedText.withValues(alpha: 0.30),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (gallery.length > 1)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                            child: SizedBox(
                              height: 88,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: gallery.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final active = _pageIndex == index;
                                  return GestureDetector(
                                    onTap: () {
                                      _pageController.animateToPage(
                                        index,
                                        duration:
                                            const Duration(milliseconds: 260),
                                        curve: Curves.easeOutCubic,
                                      );
                                      setState(() => _pageIndex = index);
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 220),
                                      width: 88,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: section.withValues(alpha: 0.92),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                          color: active
                                              ? CavoColors.gold
                                                  .withValues(alpha: 0.35)
                                              : border,
                                        ),
                                      ),
                                      child: CavoNetworkImage(
                                        imageUrl: gallery[index],
                                        fit: BoxFit.contain,
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            children: [
                              _TagChip(
                                text: product.brand,
                                isLight: isLight,
                                highlighted: true,
                              ),
                              const SizedBox(width: 10),
                              _TagChip(
                                text: _categoryLabel(context, product.category),
                                isLight: isLight,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Text(
                            product.title,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              height: 1.02,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.shortDescription,
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.55,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: section.withValues(alpha: 0.94),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(color: border),
                              boxShadow: [
                                BoxShadow(
                                  color: (isLight
                                          ? CavoColors.lightShadow
                                          : Colors.black)
                                      .withValues(alpha: isLight ? 0.10 : 0.18),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.price,
                                        style: TextStyle(
                                          color: mutedText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${product.price} EGP',
                                        style: const TextStyle(
                                          color: CavoColors.gold,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      if (product.originalPrice != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          '${product.originalPrice} EGP',
                                          style: TextStyle(
                                            color: mutedText,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                _QuantityStepper(
                                  isLight: isLight,
                                  quantity: _quantity,
                                  onMinus: () {
                                    if (_quantity > 1) {
                                      setState(() => _quantity--);
                                    }
                                  },
                                  onPlus: () {
                                    setState(() => _quantity++);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.availableSizes,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: product.sizes.map((size) {
                              final active = _selectedSize == size;
                              return _GlassChoiceChip(
                                label: size,
                                selected: active,
                                isLight: isLight,
                                onTap: () =>
                                    setState(() => _selectedSize = size),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 18),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 16,
                                sigmaY: 16,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isLight
                                      ? CavoColors.glassLight
                                          .withValues(alpha: 0.55)
                                      : CavoColors.glassDark
                                          .withValues(alpha: 0.60),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: isLight
                                        ? CavoColors.lightBorder
                                            .withValues(alpha: 0.75)
                                        : CavoColors.glassStrokeDark,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.straighten_rounded,
                                      color: CavoColors.gold,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _selectedSize == null
                                            ? l10n.selectYourSize
                                            : '${l10n.selectedSize}: $_selectedSize',
                                        style: TextStyle(
                                          color: secondaryText,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 26),
                          Text(
                            l10n.details,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: section.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(color: border),
                            ),
                            child: Text(
                              product.description,
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 14,
                                height: 1.65,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _addToCart,
                        child: Text(l10n.addToCart),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _BottomActionButton(
                      isLight: isLight,
                      active: _favorite,
                      icon: _favorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      onTap: () => setState(() => _favorite = !_favorite),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final bool isLight;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    required this.isLight,
    this.active = false,
  });


  String _categoryLabel(BuildContext context, ProductCategory category) {
    final l10n = context.l10n;
    switch (category) {
      case ProductCategory.women:
        return l10n.women;
      case ProductCategory.kids:
        return l10n.kids;
      case ProductCategory.men:
      default:
        return l10n.men;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: isLight
              ? CavoColors.glassLight.withValues(alpha: 0.55)
              : Colors.black.withValues(alpha: 0.20),
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(
                  color: active
                      ? CavoColors.gold.withValues(alpha: 0.35)
                      : (isLight
                          ? CavoColors.lightBorder.withValues(alpha: 0.70)
                          : CavoColors.glassStrokeDark),
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                color: active
                    ? CavoColors.gold
                    : (isLight
                        ? CavoColors.lightTextPrimary
                        : CavoColors.textPrimary),
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  final bool isLight;
  final bool highlighted;

  const _TagChip({
    required this.text,
    required this.isLight,
    this.highlighted = false,
  });


  String _categoryLabel(BuildContext context, ProductCategory category) {
    final l10n = context.l10n;
    switch (category) {
      case ProductCategory.women:
        return l10n.women;
      case ProductCategory.kids:
        return l10n.kids;
      case ProductCategory.men:
      default:
        return l10n.men;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = highlighted
        ? CavoColors.gold.withValues(alpha: 0.12)
        : (isLight
            ? CavoColors.lightSurfaceSoft.withValues(alpha: 0.95)
            : CavoColors.surface.withValues(alpha: 0.92));
    final textColor = highlighted
        ? CavoColors.gold
        : (isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary);
    final border = highlighted
        ? CavoColors.gold.withValues(alpha: 0.18)
        : (isLight ? CavoColors.lightBorder : CavoColors.border);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _GlassChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isLight;
  final VoidCallback onTap;

  const _GlassChoiceChip({
    required this.label,
    required this.selected,
    required this.isLight,
    required this.onTap,
  });


  String _categoryLabel(BuildContext context, ProductCategory category) {
    final l10n = context.l10n;
    switch (category) {
      case ProductCategory.women:
        return l10n.women;
      case ProductCategory.kids:
        return l10n.kids;
      case ProductCategory.men:
      default:
        return l10n.men;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? (isLight
            ? CavoColors.selectedChipLight
            : CavoColors.selectedChipDark)
        : (isLight
            ? CavoColors.glassLight.withValues(alpha: 0.48)
            : CavoColors.glassDark.withValues(alpha: 0.58));

    final border = selected
        ? CavoColors.gold.withValues(alpha: 0.30)
        : (isLight
            ? CavoColors.lightBorder.withValues(alpha: 0.75)
            : CavoColors.glassStrokeDark);

    final textColor = selected
        ? (isLight
            ? CavoColors.lightTextPrimary
            : CavoColors.textPrimary)
        : (isLight
            ? CavoColors.lightTextSecondary
            : CavoColors.textSecondary);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Material(
          color: color,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: border),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final bool isLight;
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _QuantityStepper({
    required this.isLight,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });


  String _categoryLabel(BuildContext context, ProductCategory category) {
    final l10n = context.l10n;
    switch (category) {
      case ProductCategory.women:
        return l10n.women;
      case ProductCategory.kids:
        return l10n.kids;
      case ProductCategory.men:
      default:
        return l10n.men;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = isLight
        ? CavoColors.quantityLight.withValues(alpha: 0.95)
        : CavoColors.quantityDark.withValues(alpha: 0.95);
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final textColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove_rounded,
            onTap: onMinus,
            isLight: isLight,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '$quantity',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            onTap: onPlus,
            isLight: isLight,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isLight;

  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.isLight,
  });


  String _categoryLabel(BuildContext context, ProductCategory category) {
    final l10n = context.l10n;
    switch (category) {
      case ProductCategory.women:
        return l10n.women;
      case ProductCategory.kids:
        return l10n.kids;
      case ProductCategory.men:
      default:
        return l10n.men;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: CavoColors.gold.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: CavoColors.gold,
          size: 18,
        ),
      ),
    );
  }
}

class _BottomActionButton extends StatelessWidget {
  final bool isLight;
  final bool active;
  final IconData icon;
  final VoidCallback onTap;

  const _BottomActionButton({
    required this.isLight,
    required this.active,
    required this.icon,
    required this.onTap,
  });


  String _categoryLabel(BuildContext context, ProductCategory category) {
    final l10n = context.l10n;
    switch (category) {
      case ProductCategory.women:
        return l10n.women;
      case ProductCategory.kids:
        return l10n.kids;
      case ProductCategory.men:
      default:
        return l10n.men;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = isLight
        ? CavoColors.glassLight.withValues(alpha: 0.72)
        : CavoColors.glassDark.withValues(alpha: 0.72);
    final border = active
        ? CavoColors.gold.withValues(alpha: 0.35)
        : (isLight ? CavoColors.lightBorder : CavoColors.border);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Material(
          color: bg,
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border),
              ),
              child: Icon(
                icon,
                color: active
                    ? CavoColors.gold
                    : (isLight
                        ? CavoColors.lightTextPrimary
                        : CavoColors.textPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}