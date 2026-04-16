import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/product.dart';
import '../../../shared/widgets/cavo_network_image.dart';

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

  void _showAdded() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CavoColors.surface,
        behavior: SnackBarBehavior.floating,
        content: Text(
          '${widget.product.title} added to cart.',
          style: const TextStyle(color: CavoColors.textPrimary),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: CavoColors.border),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final gallery = product.gallery.isEmpty ? [product.coverUrl] : product.gallery;

    return Scaffold(
      backgroundColor: CavoColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF050505),
              Color(0xFF080808),
              Color(0xFF0D0A06),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                child: Row(
                  children: [
                    _TopIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    _TopIconButton(
                      icon: _favorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      onTap: () => setState(() => _favorite = !_favorite),
                      active: _favorite,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
                  children: [
                    Container(
                      height: 360,
                      decoration: BoxDecoration(
                        color: CavoColors.surface.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: CavoColors.border),
                      ),
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'product-${product.id}',
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: gallery.length,
                              onPageChanged: (index) {
                                setState(() => _pageIndex = index);
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: CavoNetworkImage(
                                    imageUrl: gallery[index],
                                    fit: BoxFit.contain,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 18,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                gallery.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: _pageIndex == index ? 18 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _pageIndex == index
                                        ? CavoColors.gold
                                        : CavoColors.textMuted.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: CavoColors.gold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            product.brand,
                            style: const TextStyle(
                              color: CavoColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (product.originalPrice != null)
                          Text(
                            '${product.originalPrice} EGP',
                            style: const TextStyle(
                              color: CavoColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      product.title,
                      style: const TextStyle(
                        color: CavoColors.textPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.shortDescription,
                      style: const TextStyle(
                        color: CavoColors.textSecondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${product.price} EGP',
                      style: const TextStyle(
                        color: CavoColors.gold,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Available Sizes',
                      style: TextStyle(
                        color: CavoColors.textPrimary,
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
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSize = size),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? CavoColors.gold.withValues(alpha: 0.14)
                                  : CavoColors.surface.withValues(alpha: 0.90),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: active
                                    ? CavoColors.gold.withValues(alpha: 0.35)
                                    : CavoColors.border,
                              ),
                            ),
                            child: Text(
                              size,
                              style: TextStyle(
                                color: active
                                    ? CavoColors.textPrimary
                                    : CavoColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: CavoColors.surface.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: CavoColors.border),
                      ),
                      child: Text(
                        product.description,
                        style: const TextStyle(
                          color: CavoColors.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showAdded,
                            child: const Text('Add to Cart'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => setState(() => _favorite = !_favorite),
                          child: Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: CavoColors.surface.withValues(alpha: 0.90),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: CavoColors.border),
                            ),
                            child: Icon(
                              _favorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: _favorite
                                  ? CavoColors.gold
                                  : CavoColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
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

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _TopIconButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: CavoColors.surface.withValues(alpha: 0.90),
          shape: BoxShape.circle,
          border: Border.all(
            color: active
                ? CavoColors.gold.withValues(alpha: 0.40)
                : CavoColors.border,
          ),
        ),
        child: Icon(
          icon,
          color: active ? CavoColors.gold : CavoColors.textPrimary,
          size: 21,
        ),
      ),
    );
  }
}