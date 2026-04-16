import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/cavo_catalog.dart';
import '../../../data/models/product.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../../product_details/presentation/product_details_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final ProductCategory initialCategory;

  const CategoriesScreen({
    super.key,
    this.initialCategory = ProductCategory.men,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late ProductCategory _selectedCategory;
  late String _selectedBrand;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _selectedBrand = 'All';
  }

  @override
  Widget build(BuildContext context) {
    final brands = CavoCatalog.brandsFor(_selectedCategory);
    if (!brands.contains(_selectedBrand)) {
      _selectedBrand = 'All';
    }

    final products = CavoCatalog.filtered(
      category: _selectedCategory,
      brand: _selectedBrand,
    );

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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Browse Collection',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Mirror Original • Premium Footwear',
                          style: TextStyle(
                            color: mutedText,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: surface.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: border),
                      boxShadow: [
                        if (isLight)
                          BoxShadow(
                            color: CavoColors.lightShadow.withValues(alpha: 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                      ],
                    ),
                    child: Text(
                      '${products.length} items',
                      style: const TextStyle(
                        color: CavoColors.gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: ProductCategory.values.map((category) {
                  final active = _selectedCategory == category;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: category == ProductCategory.kids ? 0 : 10,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                            _selectedBrand = 'All';
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: active
                                ? CavoColors.gold.withValues(alpha: 0.14)
                                : surface.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: active
                                  ? CavoColors.gold.withValues(alpha: 0.35)
                                  : border,
                            ),
                            boxShadow: [
                              if (isLight && active)
                                BoxShadow(
                                  color: CavoColors.lightShadow.withValues(alpha: 0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              category.label,
                              style: TextStyle(
                                color: active ? primaryText : secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: surface.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: border),
                  boxShadow: [
                    if (isLight)
                      BoxShadow(
                        color: CavoColors.lightShadow.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brands',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: brands.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final brand = brands[index];
                          final active = brand == _selectedBrand;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedBrand = brand),
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
                                    : surfaceSoft.withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: active
                                      ? CavoColors.gold.withValues(alpha: 0.35)
                                      : border,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  brand,
                                  style: TextStyle(
                                    color: active ? primaryText : secondaryText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              if (products.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surface.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.auto_awesome_outlined,
                        color: CavoColors.gold,
                        size: 34,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'New products are being prepared for this section.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                GridView.builder(
                  itemCount: products.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.64,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _CatalogCard(
                      product: product,
                      isLight: isLight,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;

  const _CatalogCard({
    required this.product,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final surfaceSoft =
        isLight ? CavoColors.lightSurfaceSoft : CavoColors.surfaceSoft;
    final primaryText =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondaryText =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: surface.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border),
          boxShadow: [
            if (isLight)
              BoxShadow(
                color: CavoColors.lightShadow.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product-${product.id}',
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: surfaceSoft,
                  ),
                  child: CavoNetworkImage(
                    imageUrl: product.coverUrl,
                    borderRadius: BorderRadius.circular(20),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
              child: Text(
                product.brand,
                style: const TextStyle(
                  color: CavoColors.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Text(
                product.shortDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
