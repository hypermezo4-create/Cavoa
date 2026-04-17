import 'package:flutter/material.dart';
import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/cavo_catalog.dart';
import '../../../data/models/product.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../../categories/presentation/categories_screen.dart';
import '../../product_details/presentation/product_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final heroProduct = CavoCatalog.featured().isNotEmpty
        ? CavoCatalog.featured().first
        : CavoCatalog.products.first;
    final showcase = CavoCatalog.homeShowcase();
    final offers = CavoCatalog.offers();
    final brands =
        CavoCatalog.products.map((e) => e.brand).toSet().take(8).toList();

    final l10n = context.l10n;

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
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: surface,
                      border: Border.all(color: border),
                      boxShadow: [
                        BoxShadow(
                          color: isLight
                              ? CavoColors.lightShadow.withValues(alpha: 0.10)
                              : CavoColors.gold.withValues(alpha: 0.10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/branding/cavo_logo_circle.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CAVO',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.mirrorOriginal,
                          style: TextStyle(
                            color: mutedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _CircleIconButton(
                    icon: Icons.notifications_none_rounded,
                    isLight: isLight,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: surface.withValues(alpha: isLight ? 0.96 : 0.90),
                  borderRadius: BorderRadius.circular(22),
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
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: mutedText,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.searchProductsBrands,
                        style: TextStyle(
                          color: mutedText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.tune_rounded,
                      color: CavoColors.gold,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _HeroBanner(
                product: heroProduct,
                isLight: isLight,
              ),
              const SizedBox(height: 28),
              _SectionHeader(
                title: l10n.shopByCategory,
                action: l10n.viewAll,
                isLight: isLight,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CategoriesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _CategoryCard(
                      title: l10n.men,
                      icon: Icons.man_rounded,
                      isLight: isLight,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CategoriesScreen(
                              initialCategory: ProductCategory.men,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CategoryCard(
                      title: l10n.women,
                      icon: Icons.woman_rounded,
                      isLight: isLight,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CategoriesScreen(
                              initialCategory: ProductCategory.women,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CategoryCard(
                      title: l10n.kids,
                      icon: Icons.child_care_rounded,
                      isLight: isLight,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CategoriesScreen(
                              initialCategory: ProductCategory.kids,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _SectionHeader(
                title: l10n.topBrands,
                action: l10n.curated,
                isLight: isLight,
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: brands
                    .map((brand) => _BrandChip(label: brand, isLight: isLight))
                    .toList(),
              ),
              const SizedBox(height: 28),
              _SectionHeader(
                title: l10n.featuredCollection,
                action: l10n.premium,
                isLight: isLight,
              ),
              const SizedBox(height: 14),
              ...showcase.take(4).map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _FeaturedProductCard(
                    product: product,
                    isLight: isLight,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _SectionHeader(
                title: l10n.offersTitle,
                action: l10n.selected,
                isLight: isLight,
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: offers.length.clamp(0, 8),
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return _OfferCard(
                      product: offers[index],
                      isLight: isLight,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;

  const _HeroBanner({
    required this.product,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final titleColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final bodyColor =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: border),
        gradient: LinearGradient(
          colors: isLight
              ? const [
                  Color(0xFFFFFFFF),
                  Color(0xFFF1ECE2),
                ]
              : [
                  CavoColors.surface.withValues(alpha: 0.95),
                  const Color(0xFF1A1408),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isLight
                ? CavoColors.lightShadow.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.28),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: CavoColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    l10n.newCollection.toUpperCase(),
                    style: TextStyle(
                      color: CavoColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.premiumFootwearDesignedToStandApart,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 26,
                    height: 1.08,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.mirrorOriginalPiecesRefined,
                  style: TextStyle(
                    color: bodyColor,
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        child: Text(l10n.shopNow),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _CircleIconButton(
                      icon: Icons.arrow_forward_rounded,
                      isLight: isLight,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsScreen(product: product),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 130,
            height: 220,
            child: Hero(
              tag: 'product-${product.id}',
              child: CavoNetworkImage(
                imageUrl: product.coverUrl,
                fit: BoxFit.contain,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedProductCard extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;

  const _FeaturedProductCard({
    required this.product,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final surfaceSoft =
        isLight ? CavoColors.lightSurfaceSoft : CavoColors.surfaceSoft;
    final titleColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final bodyColor =
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
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surface.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(28),
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
        child: Row(
          children: [
            Hero(
              tag: 'product-${product.id}',
              child: Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: [
                      CavoColors.gold.withValues(alpha: 0.18),
                      surfaceSoft,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CavoNetworkImage(
                  imageUrl: product.thumbnailUrl ?? product.coverUrl,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '',
                  ),
                  Text(
                    product.localizedBrand(context),
                    style: const TextStyle(
                      color: CavoColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.localizedTitle(context),
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.shortDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.favorite_border_rounded,
              color: isLight
                  ? CavoColors.lightTextMuted
                  : CavoColors.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;

  const _OfferCard({
    required this.product,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final titleColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final bodyColor =
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
        width: 190,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surface.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isLight
                      ? CavoColors.lightSurfaceSoft
                      : CavoColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CavoNetworkImage(
                  imageUrl: product.coverUrl,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.localizedBrand(context),
              style: const TextStyle(
                color: CavoColors.gold,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.localizedTitle(context),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: titleColor,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.offerSelectedForPremiumShowcase,
              style: TextStyle(
                color: bodyColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final bool isLight;
  final VoidCallback? onTap;

  const _CircleIconButton({
    required this.icon,
    required this.isLight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final iconColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: surface.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          border: Border.all(color: border),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final bool isLight;
  final VoidCallback? onTap;

  const _SectionHeader({
    required this.title,
    required this.action,
    required this.isLight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: TextStyle(
              color: CavoColors.gold,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}



class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isLight;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final surface = isLight ? CavoColors.lightSurface : CavoColors.surface;
    final textColor =
        isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: surface.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Icon(icon, color: CavoColors.gold, size: 26),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  final String label;
  final bool isLight;

  const _BrandChip({
    required this.label,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final border = isLight ? CavoColors.lightBorder : CavoColors.border;
    final bg = isLight
        ? CavoColors.lightSurfaceSoft.withValues(alpha: 0.95)
        : CavoColors.surface.withValues(alpha: 0.92);
    final textColor =
        isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
