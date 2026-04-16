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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Browse Collection',
                      style: TextStyle(
                        color: CavoColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: CavoColors.surface.withValues(alpha: 0.90),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: CavoColors.border),
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
              const SizedBox(height: 20),
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
                                : CavoColors.surface.withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: active
                                  ? CavoColors.gold.withValues(alpha: 0.35)
                                  : CavoColors.border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              category.label,
                              style: TextStyle(
                                color: active
                                    ? CavoColors.textPrimary
                                    : CavoColors.textSecondary,
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
              const SizedBox(height: 20),
              const Text(
                'Brands',
                style: TextStyle(
                  color: CavoColors.textPrimary,
                  fontSize: 18,
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
                              : CavoColors.surface.withValues(alpha: 0.90),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: active
                                ? CavoColors.gold.withValues(alpha: 0.35)
                                : CavoColors.border,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            brand,
                            style: TextStyle(
                              color: active
                                  ? CavoColors.textPrimary
                                  : CavoColors.textSecondary,
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
              const SizedBox(height: 22),
              if (products.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: CavoColors.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: CavoColors.border),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.auto_awesome_outlined,
                        color: CavoColors.gold,
                        size: 34,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'New products are being prepared for this section.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CavoColors.textSecondary,
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
                    childAspectRatio: 0.66,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _CatalogCard(product: product);
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

  const _CatalogCard({required this.product});

  @override
  Widget build(BuildContext context) {
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
          color: CavoColors.surface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: CavoColors.border),
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
                    color: CavoColors.surfaceSoft,
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
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
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
                style: const TextStyle(
                  color: CavoColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Text(
                '${product.price} EGP',
                style: const TextStyle(
                  color: CavoColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}