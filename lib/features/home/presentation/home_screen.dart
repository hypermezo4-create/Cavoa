import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/cavo_catalog.dart';
import '../../../data/models/product.dart';
import '../../../shared/widgets/cavo_language_picker.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../../categories/presentation/categories_screen.dart';
import '../../product_details/presentation/product_details_screen.dart';
import '../../search/presentation/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  CavoProduct _productForCategory(ProductCategory category) {
    for (final product in CavoCatalog.products) {
      if (product.category == category) return product;
    }
    return CavoCatalog.products.first;
  }

  CavoProduct _productForBrand(String brand) {
    for (final product in CavoCatalog.products) {
      if (product.brand == brand) return product;
    }
    return CavoCatalog.products.first;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final muted = isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;

    final showcase = CavoCatalog.homeShowcase().take(5).toList();
    if (showcase.isEmpty) {
      showcase.add(CavoCatalog.products.first);
    }
    final heroProduct = showcase[_page % showcase.length];
    final featured = CavoCatalog.featured().take(6).toList();
    final brands = CavoCatalog.products.map((e) => e.brand).toSet().take(8).toList();

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
                  _BrandHeader(isLight: isLight),
                  const Spacer(),
                  const CavoLanguagePicker(isLight: false),
                  const SizedBox(width: 10),
                  CavoCircleIconButton(
                    icon: Icons.notifications_none_rounded,
                    isLight: isLight,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SearchBar(isLight: isLight),
              const SizedBox(height: 22),
              SizedBox(
                height: 422,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: showcase.length,
                  onPageChanged: (value) => setState(() => _page = value),
                  itemBuilder: (context, index) {
                    final product = showcase[index];
                    return _HeroShowcaseCard(
                      product: product,
                      isLight: isLight,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsScreen(product: product, heroTagBase: 'home-hero-${product.id}'),
                          ),
                        );
                      },
                      onBrowse: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CategoriesScreen(initialCategory: product.category),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  showcase.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: _page == index ? 26 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: _page == index
                          ? CavoColors.gold
                          : CavoColors.gold.withValues(alpha: 0.24),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  CavoMetricChip(
                    value: '${CavoCatalog.products.length}+',
                    label: l10n.itemsCountLabel,
                    icon: Icons.auto_awesome_rounded,
                    isLight: isLight,
                  ),
                  CavoMetricChip(
                    value: brands.length.toString(),
                    label: l10n.topBrands,
                    icon: Icons.workspace_premium_rounded,
                    isLight: isLight,
                  ),
                  CavoMetricChip(
                    value: '24/7',
                    label: l10n.links,
                    icon: Icons.support_agent_rounded,
                    isLight: isLight,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              CavoSectionHeader(
                title: l10n.shopByCategory,
                subtitle: l10n.mirrorOriginalPremiumFootwear,
                action: l10n.viewAll,
                isLight: isLight,
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CategoriesScreen()),
                  );
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 206,
                child: Row(
                  children: [
                    Expanded(
                      child: _CategoryShowcaseCard(
                        title: l10n.men,
                        subtitle: 'Premium style',
                        product: _productForCategory(ProductCategory.men),
                        icon: Icons.man_rounded,
                        isLight: isLight,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CategoriesScreen(initialCategory: ProductCategory.men),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: _CategoryShowcaseCard(
                              title: l10n.women,
                              subtitle: 'Elegant & bold',
                              product: _productForCategory(ProductCategory.women),
                              icon: Icons.woman_rounded,
                              isLight: isLight,
                              compact: true,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CategoriesScreen(initialCategory: ProductCategory.women),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: _CategoryShowcaseCard(
                              title: l10n.kids,
                              subtitle: 'Future icons',
                              product: _productForCategory(ProductCategory.kids),
                              icon: Icons.child_care_rounded,
                              isLight: isLight,
                              compact: true,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CategoriesScreen(initialCategory: ProductCategory.kids),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              CavoSectionHeader(
                title: l10n.topBrands,
                subtitle: 'Curated for your premium rotation',
                action: l10n.curated,
                isLight: isLight,
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 112,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: brands.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    final product = _productForBrand(brand);
                    return _BrandShowcaseCard(
                      brand: brand,
                      product: product,
                      isLight: isLight,
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              CavoSectionHeader(
                title: l10n.featuredCollection,
                subtitle: heroProduct.localizedShortDescription(context),
                action: l10n.premium,
                isLight: isLight,
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: featured.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (context, index) {
                  final product = featured[index];
                  return _FeaturedProductCard(
                    product: product,
                    isLight: isLight,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(product: product, heroTagBase: 'home-list-${product.id}'),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 18),
              Text(
                'Refined luxury, premium motion, and a product-first experience designed to feel like a real CAVO app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final bool isLight;

  const _BrandHeader({required this.isLight});


  CavoProduct _productForCategory(ProductCategory category) {
    for (final product in CavoCatalog.products) {
      if (product.category == category) return product;
    }
    return CavoCatalog.products.first;
  }

  CavoProduct _productForBrand(String brand) {
    for (final product in CavoCatalog.products) {
      if (product.brand == brand) return product;
    }
    return CavoCatalog.products.first;
  }

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: CavoColors.gold.withValues(alpha: 0.18),
                blurRadius: 26,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset('assets/branding/cavo_logo_circle.png', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CAVO',
              style: TextStyle(
                color: primary,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Mirror Original',
              style: TextStyle(
                color: secondary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  final bool isLight;

  const _SearchBar({required this.isLight});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glow;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _glow = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _focused = true);
    Future<void>.delayed(const Duration(milliseconds: 180), () {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SearchScreen()),
      );
      Future<void>.delayed(const Duration(milliseconds: 240), () {
        if (mounted) setState(() => _focused = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final secondary = widget.isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) {
        final glow = 0.06 + (_glow.value * (_focused ? 0.08 : 0.03));
        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: CavoColors.gold.withValues(alpha: glow),
                blurRadius: _focused ? 28 : 16,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: _openSearch,
              child: CavoGlassCard(
                isLight: widget.isLight,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                borderRadius: const BorderRadius.all(Radius.circular(26)),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: secondary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        style: TextStyle(
                          color: _focused ? CavoColors.textPrimary : secondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        child: Text(context.l10n.searchProductsBrands),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _focused ? 0.08 : 0,
                      duration: const Duration(milliseconds: 260),
                      child: const Icon(Icons.tune_rounded, color: CavoColors.gold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroShowcaseCard extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;
  final VoidCallback onTap;
  final VoidCallback onBrowse;

  const _HeroShowcaseCard({
    required this.product,
    required this.isLight,
    required this.onTap,
    required this.onBrowse,
  });


  CavoProduct _productForCategory(ProductCategory category) {
    for (final product in CavoCatalog.products) {
      if (product.category == category) return product;
    }
    return CavoCatalog.products.first;
  }

  CavoProduct _productForBrand(String brand) {
    for (final product in CavoCatalog.products) {
      if (product.brand == brand) return product;
    }
    return CavoCatalog.products.first;
  }

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final title = context.l10n.premiumFootwearDesignedToStandApart.split('\n');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(34),
      child: CavoGlassCard(
        isLight: isLight,
        padding: const EdgeInsets.all(18),
        borderRadius: const BorderRadius.all(Radius.circular(34)),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              top: -16,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      CavoColors.gold.withValues(alpha: 0.24),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CavoPillTag(
                  label: 'NEW COLLECTION',
                  isLight: false,
                  icon: Icons.auto_awesome_rounded,
                  selected: true,
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TweenAnimationBuilder<Offset>(
                              tween: Tween(begin: const Offset(0.16, 0), end: Offset.zero),
                              duration: const Duration(milliseconds: 720),
                              curve: Curves.easeOutCubic,
                              builder: (context, offset, child) {
                                return Transform.translate(
                                  offset: Offset(offset.dx * 60, 0),
                                  child: child,
                                );
                              },
                              child: Cavo3DHeadline(
                                lineOne: title.isNotEmpty ? title.first : 'Premium Footwear',
                                lineTwo: title.length > 1 ? title[1] : 'Stand Apart',
                                isLight: isLight,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              product.localizedShortDescription(context),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: secondary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                height: 1.55,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: onBrowse,
                                    child: Text(context.l10n.shopNow),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                CavoCircleIconButton(
                                  icon: Icons.arrow_forward_rounded,
                                  isLight: isLight,
                                  onTap: onTap,
                                  iconColor: CavoColors.gold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Hero(
                          tag: 'home-hero-${product.id}',
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: CavoColors.gold.withValues(alpha: 0.18),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: CavoColors.gold.withValues(alpha: 0.12),
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                            child: CavoNetworkImage(
                              imageUrl: product.thumbnailUrl ?? product.coverUrl,
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryShowcaseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final CavoProduct product;
  final IconData icon;
  final bool isLight;
  final VoidCallback onTap;
  final bool compact;

  const _CategoryShowcaseCard({
    required this.title,
    required this.subtitle,
    required this.product,
    required this.icon,
    required this.isLight,
    required this.onTap,
    this.compact = false,
  });


  CavoProduct _productForCategory(ProductCategory category) {
    for (final product in CavoCatalog.products) {
      if (product.category == category) return product;
    }
    return CavoCatalog.products.first;
  }

  CavoProduct _productForBrand(String brand) {
    for (final product in CavoCatalog.products) {
      if (product.brand == brand) return product;
    }
    return CavoCatalog.products.first;
  }

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: CavoGlassCard(
        isLight: isLight,
        padding: const EdgeInsets.all(12),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.28,
                child: CavoNetworkImage(
                  imageUrl: product.coverUrl,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.64),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.74),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.42),
                      border: Border.all(
                        color: CavoColors.gold.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Icon(icon, color: CavoColors.gold),
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    color: primary,
                    fontSize: compact ? 22 : 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.brand,
                        style: const TextStyle(
                          color: CavoColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded, color: CavoColors.gold),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandShowcaseCard extends StatelessWidget {
  final String brand;
  final CavoProduct product;
  final bool isLight;

  const _BrandShowcaseCard({
    required this.brand,
    required this.product,
    required this.isLight,
  });


  CavoProduct _productForCategory(ProductCategory category) {
    for (final product in CavoCatalog.products) {
      if (product.category == category) return product;
    }
    return CavoCatalog.products.first;
  }

  CavoProduct _productForBrand(String brand) {
    for (final product in CavoCatalog.products) {
      if (product.brand == brand) return product;
    }
    return CavoCatalog.products.first;
  }

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return SizedBox(
      width: 170,
      child: CavoGlassCard(
        isLight: isLight,
        padding: const EdgeInsets.all(12),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: CavoColors.gold.withValues(alpha: 0.18),
                ),
              ),
              child: CavoNetworkImage(
                imageUrl: product.coverUrl,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    brand,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.category.localizedLabel(context),
                    style: TextStyle(
                      color: secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedProductCard extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;
  final VoidCallback onTap;

  const _FeaturedProductCard({
    required this.product,
    required this.isLight,
    required this.onTap,
  });


  CavoProduct _productForCategory(ProductCategory category) {
    for (final product in CavoCatalog.products) {
      if (product.category == category) return product;
    }
    return CavoCatalog.products.first;
  }

  CavoProduct _productForBrand(String brand) {
    for (final product in CavoCatalog.products) {
      if (product.brand == brand) return product;
    }
    return CavoCatalog.products.first;
  }

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: CavoGlassCard(
        isLight: isLight,
        padding: const EdgeInsets.all(12),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 168,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: isLight ? const Color(0xFFF7F3E9) : const Color(0xFF161616),
              ),
              child: Hero(
                tag: 'home-list-${product.id}',
                child: CavoNetworkImage(
                  imageUrl: product.thumbnailUrl ?? product.coverUrl,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: primary,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                height: 1.15,
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
                height: 1.35,
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
