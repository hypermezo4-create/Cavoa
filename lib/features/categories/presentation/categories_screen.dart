import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/cavo_catalog.dart';
import '../../../data/models/product.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
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
    final l10n = context.l10n;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final brands = ['All', ...CavoCatalog.brandsFor(_selectedCategory)];

    if (!brands.contains(_selectedBrand)) {
      _selectedBrand = 'All';
    }

    final products = CavoCatalog.filtered(
      category: _selectedCategory,
      brand: _selectedBrand,
    );

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
            children: [
              Row(
                children: [
                  CavoCircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    isLight: isLight,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.browseCollection,
                          style: TextStyle(
                            color: primary,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.mirrorOriginalPremiumFootwear,
                          style: TextStyle(
                            color: secondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              CavoGlassCard(
                isLight: isLight,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: secondary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.searchProductsBrands,
                        style: TextStyle(
                          color: secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.tune_rounded, color: CavoColors.gold),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _CategoryChip(
                      label: l10n.men,
                      selected: _selectedCategory == ProductCategory.men,
                      isLight: isLight,
                      onTap: () => setState(() {
                        _selectedCategory = ProductCategory.men;
                        _selectedBrand = 'All';
                      }),
                    ),
                    const SizedBox(width: 10),
                    _CategoryChip(
                      label: l10n.women,
                      selected: _selectedCategory == ProductCategory.women,
                      isLight: isLight,
                      onTap: () => setState(() {
                        _selectedCategory = ProductCategory.women;
                        _selectedBrand = 'All';
                      }),
                    ),
                    const SizedBox(width: 10),
                    _CategoryChip(
                      label: l10n.kids,
                      selected: _selectedCategory == ProductCategory.kids,
                      isLight: isLight,
                      onTap: () => setState(() {
                        _selectedCategory = ProductCategory.kids;
                        _selectedBrand = 'All';
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: brands.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedBrand = brand),
                      child: CavoPillTag(
                        label: brand,
                        isLight: isLight,
                        selected: _selectedBrand == brand,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Row(
                  children: [
                    Expanded(
                      child: _InfoStat(
                        label: 'Products',
                        value: '${products.length}',
                        isLight: isLight,
                      ),
                    ),
                    Expanded(
                      child: _InfoStat(
                        label: 'Brands',
                        value: '${brands.length - 1}',
                        isLight: isLight,
                      ),
                    ),
                    Expanded(
                      child: _InfoStat(
                        label: 'Category',
                        value: _selectedCategory.localizedLabel(context),
                        isLight: isLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CavoSectionHeader(
                title: '${products.length} ${l10n.itemsCountLabel}',
                subtitle: _selectedBrand == 'All'
                    ? 'Showing all premium pieces in ${_selectedCategory.localizedLabel(context)}'
                    : 'Showing ${_selectedCategory.localizedLabel(context)} • $_selectedBrand',
                isLight: isLight,
              ),
              const SizedBox(height: 14),
              if (products.isEmpty)
                CavoGlassCard(
                  isLight: isLight,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  child: Column(
                    children: [
                      const Icon(Icons.inventory_2_outlined, color: CavoColors.gold, size: 42),
                      const SizedBox(height: 12),
                      Text(
                        l10n.newProductsPreparing,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _BrowseProductCard(
                      product: product,
                      isLight: isLight,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsScreen(product: product, heroTagBase: 'browse-${product.id}'),
                          ),
                        );
                      },
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

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isLight;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? CavoColors.gold.withValues(alpha: 0.18)
              : (isLight ? Colors.white : CavoColors.surface).withValues(alpha: 0.86),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? CavoColors.gold.withValues(alpha: 0.34)
                : (isLight ? CavoColors.lightBorder : CavoColors.border),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? (isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary)
                : (isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _InfoStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isLight;

  const _InfoStat({
    required this.label,
    required this.value,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: primary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: secondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _BrowseProductCard extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;
  final VoidCallback onTap;

  const _BrowseProductCard({
    required this.product,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final soft = isLight ? const Color(0xFFF7F3E9) : const Color(0xFF161616);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: CavoGlassCard(
        isLight: isLight,
        padding: const EdgeInsets.all(10),
        borderRadius: const BorderRadius.all(Radius.circular(26)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 126,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: soft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Hero(
                tag: 'browse-${product.id}',
                child: CavoNetworkImage(
                  imageUrl: product.thumbnailUrl ?? product.coverUrl,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.brand,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CavoColors.gold,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: primary,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                height: 1.12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.shortDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: secondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${product.price} EGP',
                    style: const TextStyle(
                      color: CavoColors.gold,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded, color: CavoColors.gold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
