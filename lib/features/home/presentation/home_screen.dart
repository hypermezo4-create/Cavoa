import 'package:flutter/material.dart';
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
    final videos = CavoCatalog.videos;
    final brands = CavoCatalog.products
        .map((e) => e.brand)
        .toSet()
        .take(8)
        .toList();

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
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CavoColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: CavoColors.gold.withValues(alpha: 0.10),
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CAVO',
                          style: TextStyle(
                            color: CavoColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Mirror Original',
                          style: TextStyle(
                            color: CavoColors.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const _CircleIconButton(
                    icon: Icons.notifications_none_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: CavoColors.surface.withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: CavoColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: CavoColors.textMuted,
                      size: 22,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search products, brands...',
                        style: TextStyle(
                          color: CavoColors.textMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.tune_rounded,
                      color: CavoColors.gold,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _HeroBanner(product: heroProduct),
              const SizedBox(height: 28),
              _SectionHeader(
                title: 'Shop by Category',
                action: 'View All',
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
                      title: 'Men',
                      icon: Icons.man_rounded,
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
                      title: 'Women',
                      icon: Icons.woman_rounded,
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
                      title: 'Kids',
                      icon: Icons.child_care_rounded,
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
              const _SectionHeader(
                title: 'Top Brands',
                action: 'Curated',
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: brands.map((brand) => _BrandChip(label: brand)).toList(),
              ),
              const SizedBox(height: 28),
              const _SectionHeader(
                title: 'Featured Collection',
                action: 'Premium',
              ),
              const SizedBox(height: 14),
              ...showcase.take(4).map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _FeaturedProductCard(product: product),
                ),
              ),
              const SizedBox(height: 28),
              const _SectionHeader(
                title: 'Offers',
                action: 'Selected',
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: offers.length.clamp(0, 8),
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return _OfferCard(product: offers[index]);
                  },
                ),
              ),
              const SizedBox(height: 28),
              const _SectionHeader(
                title: 'Videos',
                action: 'Motion',
              ),
              const SizedBox(height: 14),
              _VideoHighlightCard(video: CavoCatalog.homeVideo),
              const SizedBox(height: 14),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: videos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return _VideoMiniCard(video: videos[index]);
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

  const _HeroBanner({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: CavoColors.border),
        gradient: LinearGradient(
          colors: [
            CavoColors.surface.withValues(alpha: 0.95),
            const Color(0xFF1A1408),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
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
                    'NEW COLLECTION',
                    style: TextStyle(
                      color: CavoColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Premium Footwear\nDesigned to Stand\nApart',
                  style: TextStyle(
                    color: CavoColors.textPrimary,
                    fontSize: 26,
                    height: 1.08,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Mirror Original pieces with a refined dark luxury feel.',
                  style: TextStyle(
                    color: CavoColors.textSecondary,
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
                        child: const Text('Shop Now'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _CircleIconButton(
                      icon: Icons.arrow_forward_rounded,
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

  const _FeaturedProductCard({required this.product});

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
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: CavoColors.surface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: CavoColors.border),
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
                      CavoColors.gold.withValues(alpha: 0.22),
                      CavoColors.surfaceSoft,
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
                  Text(
                    product.brand,
                    style: const TextStyle(
                      color: CavoColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.title,
                    style: const TextStyle(
                      color: CavoColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.shortDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CavoColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.favorite_border_rounded,
              color: CavoColors.textMuted,
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

  const _OfferCard({required this.product});

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
        width: 190,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CavoColors.surface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: CavoColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CavoColors.surfaceSoft,
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
              product.brand,
              style: const TextStyle(
                color: CavoColors.gold,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CavoColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Offer selected for premium showcase',
              style: TextStyle(
                color: CavoColors.textSecondary,
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

class _VideoHighlightCard extends StatelessWidget {
  final CavoPromoVideo video;

  const _VideoHighlightCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: CavoColors.border),
        gradient: LinearGradient(
          colors: [
            CavoColors.surface.withValues(alpha: 0.95),
            const Color(0xFF15100A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CavoColors.gold.withValues(alpha: 0.12),
              border: Border.all(
                color: CavoColors.gold.withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: CavoColors.gold,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.brand,
                  style: const TextStyle(
                    color: CavoColors.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  video.title,
                  style: const TextStyle(
                    color: CavoColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  video.videoUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CavoColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoMiniCard extends StatelessWidget {
  final CavoPromoVideo video;

  const _VideoMiniCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CavoColors.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: CavoColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: CavoColors.gold.withValues(alpha: 0.10),
            ),
            child: const Center(
              child: Icon(
                Icons.play_circle_fill_rounded,
                color: CavoColors.gold,
                size: 28,
              ),
            ),
          ),
          const Spacer(),
          Text(
            video.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CavoColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            video.brand,
            style: const TextStyle(
              color: CavoColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleIconButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: CavoColors.surface.withValues(alpha: 0.90),
          shape: BoxShape.circle,
          border: Border.all(color: CavoColors.border),
        ),
        child: Icon(icon, color: CavoColors.textPrimary, size: 22),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback? onTap;

  const _SectionHeader({
    required this.title,
    required this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: CavoColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
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
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: CavoColors.surface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: CavoColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: CavoColors.gold, size: 26),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: CavoColors.textPrimary,
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

  const _BrandChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CavoColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CavoColors.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: CavoColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
