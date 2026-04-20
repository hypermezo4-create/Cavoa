import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/cavo_catalog.dart';
import '../../../data/models/product.dart';
import '../../../shared/widgets/cavo_language_picker.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../../categories/presentation/categories_screen.dart';
import '../../notifications/data/notification_center_controller.dart';
import '../../notifications/presentation/notifications_screen.dart';
import '../../product_details/presentation/product_details_screen.dart';
import '../../search/presentation/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _heroController;
  int _heroPage = 0;

  @override
  void initState() {
    super.initState();
    _heroController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  CavoProduct _productForCategory(ProductCategory category) {
    return CavoCatalog.products.firstWhere(
      (p) => p.category == category,
      orElse: () => CavoCatalog.products.first,
    );
  }

  CavoProduct _productForBrand(String brand) {
    return CavoCatalog.products.firstWhere(
      (p) => p.brand == brand,
      orElse: () => CavoCatalog.products.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final muted = isLight ? CavoColors.lightTextMuted : CavoColors.textMuted;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    final spotlight = CavoCatalog.homeShowcase().take(5).toList();
    if (spotlight.isEmpty) spotlight.add(CavoCatalog.products.first);
    final heroProduct = spotlight[_heroPage % spotlight.length];

    final featured = CavoCatalog.featured().take(6).toList();
    final brands = CavoCatalog.products.map((e) => e.brand).toSet().take(8).toList();

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 26),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _HomeTopBar(isLight: isLight),
                    const SizedBox(height: 18),
                    _PremiumIntroHero(
                      isLight: isLight,
                      primary: primary,
                      muted: muted,
                      onBrowseCollection: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CategoriesScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _QuickAccessRow(
                      isLight: isLight,
                      onSearch: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        );
                      },
                      onCategories: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CategoriesScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 26),
                    _SectionLabel(
                      isLight: isLight,
                      title: l10n.newCollection,
                      subtitle: l10n.homePremiumSpotlightSubtitle,
                      action: l10n.curated,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 360,
                      child: PageView.builder(
                        controller: _heroController,
                        itemCount: spotlight.length,
                        onPageChanged: (index) => setState(() => _heroPage = index),
                        itemBuilder: (context, index) {
                          final product = spotlight[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _EditorialHeroCard(
                              product: product,
                              isLight: isLight,
                              onOpen: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailsScreen(
                                      product: product,
                                      heroTagBase: 'home-hero-${product.id}',
                                    ),
                                  ),
                                );
                              },
                              onBrowseCategory: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CategoriesScreen(initialCategory: product.category),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    _HeroPager(count: spotlight.length, current: _heroPage),
                    const SizedBox(height: 28),
                    _SectionLabel(
                      isLight: isLight,
                      title: l10n.shopByCategory,
                      subtitle: l10n.mirrorOriginalPremiumFootwear,
                      action: l10n.viewAll,
                      onTapAction: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CategoriesScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 186,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _CategoryEditorialCard(
                            isLight: isLight,
                            product: _productForCategory(ProductCategory.men),
                            title: l10n.men,
                            subtitle: l10n.homeCategoryMenSubtitle,
                            icon: Icons.man_rounded,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CategoriesScreen(initialCategory: ProductCategory.men),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _CategoryEditorialCard(
                            isLight: isLight,
                            product: _productForCategory(ProductCategory.women),
                            title: l10n.women,
                            subtitle: l10n.homeCategoryWomenSubtitle,
                            icon: Icons.woman_rounded,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CategoriesScreen(initialCategory: ProductCategory.women),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _CategoryEditorialCard(
                            isLight: isLight,
                            product: _productForCategory(ProductCategory.kids),
                            title: l10n.kids,
                            subtitle: l10n.homeCategoryKidsSubtitle,
                            icon: Icons.child_care_rounded,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CategoriesScreen(initialCategory: ProductCategory.kids),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _SectionLabel(
                      isLight: isLight,
                      title: l10n.topBrands,
                      subtitle: l10n.homeTopBrandsSubtitle,
                      action: l10n.premium,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: brands.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final brand = brands[index];
                          return _BrandEditorialCard(
                            brand: brand,
                            product: _productForBrand(brand),
                            isLight: isLight,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    _SectionLabel(
                      isLight: isLight,
                      title: l10n.featuredCollection,
                      subtitle: heroProduct.localizedShortDescription(context),
                      action: l10n.shopNow,
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
                        childAspectRatio: 0.67,
                      ),
                      itemBuilder: (context, index) {
                        final product = featured[index];
                        return _FeaturedProductEditorialCard(
                          product: product,
                          isLight: isLight,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProductDetailsScreen(
                                  product: product,
                                  heroTagBase: 'home-list-${product.id}',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    Text(
                      l10n.homeFooterLine,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  final bool isLight;

  const _HomeTopBar({required this.isLight});

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: CavoColors.gold.withValues(alpha: isLight ? 0.14 : 0.2),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset('assets/branding/cavo_logo_circle.png', fit: BoxFit.cover),
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
                  color: primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
              Text(
                context.l10n.mirrorOriginal,
                style: TextStyle(
                  color: secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        CavoLanguagePicker(isLight: isLight),
        const SizedBox(width: 8),
        ValueListenableBuilder<List<CavoNotificationItem>>(
          valueListenable: NotificationCenterController.instance,
          builder: (context, notifications, _) {
            final unread = NotificationCenterController.instance.unreadCount;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                CavoCircleIconButton(
                  icon: Icons.notifications_none_rounded,
                  isLight: isLight,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                    );
                  },
                ),
                if (unread > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: CavoColors.gold,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        unread > 9 ? '9+' : '$unread',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PremiumIntroHero extends StatelessWidget {
  final bool isLight;
  final Color primary;
  final Color muted;
  final VoidCallback onBrowseCollection;

  const _PremiumIntroHero({
    required this.isLight,
    required this.primary,
    required this.muted,
    required this.onBrowseCollection,
  });

  @override
  Widget build(BuildContext context) {
    final introProduct = CavoCatalog.homeShowcase().isNotEmpty
        ? CavoCatalog.homeShowcase().first
        : CavoCatalog.products.first;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: isLight
            ? const LinearGradient(
                colors: [Color(0xFFFDF7EA), Color(0xFFF9F1E0), Color(0xFFFFFFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF0A0A0A), Color(0xFF141414), Color(0xFF1D1810)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        border: Border.all(
          color: isLight
              ? CavoColors.lightBorder.withValues(alpha: 0.85)
              : CavoColors.gold.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: isLight
                ? Colors.black.withValues(alpha: 0.07)
                : CavoColors.gold.withValues(alpha: 0.12),
            blurRadius: 34,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned(
              right: -44,
              top: -44,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      CavoColors.gold.withValues(alpha: isLight ? 0.2 : 0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 18, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CavoPillTag(
                          label: context.l10n.curated,
                          isLight: isLight,
                          selected: true,
                          icon: Icons.workspace_premium_rounded,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.l10n.homePremiumSpotlightTitle,
                          style: TextStyle(
                            color: primary,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.homePremiumSpotlightSubtitle,
                          style: TextStyle(
                            color: muted,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: onBrowseCollection,
                          child: Text(context.l10n.browseCollection),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 94,
                    height: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: CavoNetworkImage(
                        imageUrl: introProduct.coverUrl,
                        fit: BoxFit.cover,
                      ),
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

class _QuickAccessRow extends StatelessWidget {
  final bool isLight;
  final VoidCallback onSearch;
  final VoidCallback onCategories;

  const _QuickAccessRow({
    required this.isLight,
    required this.onSearch,
    required this.onCategories,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    Widget tile({
      required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: CavoGlassCard(
            isLight: isLight,
            padding: const EdgeInsets.all(14),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: CavoColors.gold, size: 19),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tile(
          icon: Icons.search_rounded,
          title: context.l10n.curated,
          subtitle: context.l10n.searchProductsBrands,
          onTap: onSearch,
        ),
        const SizedBox(width: 10),
        tile(
          icon: Icons.grid_view_rounded,
          title: context.l10n.viewAll,
          subtitle: context.l10n.shopByCategory,
          onTap: onCategories,
        ),
        const SizedBox(width: 10),
        tile(
          icon: Icons.auto_awesome_rounded,
          title: context.l10n.premium,
          subtitle: context.l10n.featuredCollection,
          onTap: onCategories,
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final bool isLight;
  final String title;
  final String subtitle;
  final String action;
  final VoidCallback? onTapAction;

  const _SectionLabel({
    required this.isLight,
    required this.title,
    required this.subtitle,
    required this.action,
    this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: primary,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTapAction,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: (isLight ? Colors.white : CavoColors.surface).withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: (isLight ? CavoColors.lightBorder : CavoColors.gold)
                    .withValues(alpha: isLight ? 0.7 : 0.23),
              ),
            ),
            child: Text(
              action,
              style: TextStyle(
                color: isLight ? primary : CavoColors.gold,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EditorialHeroCard extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;
  final VoidCallback onOpen;
  final VoidCallback onBrowseCategory;

  const _EditorialHeroCard({
    required this.product,
    required this.isLight,
    required this.onOpen,
    required this.onBrowseCategory,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(34),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          gradient: isLight
              ? const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFF9F4EA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFF0E0E0E), Color(0xFF1A1A1A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          border: Border.all(
            color: isLight
                ? CavoColors.lightBorder.withValues(alpha: 0.75)
                : CavoColors.gold.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: isLight
                  ? Colors.black.withValues(alpha: 0.08)
                  : CavoColors.gold.withValues(alpha: 0.11),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'home-hero-${product.id}',
                        child: CavoNetworkImage(
                          imageUrl: product.coverUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.05),
                              Colors.black.withValues(alpha: 0.62),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        right: 14,
                        bottom: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product.localizedShortDescription(context),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.92),
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
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${product.price} EGP',
                      style: TextStyle(
                        color: isLight ? primary : CavoColors.gold,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onBrowseCategory,
                    child: Text(context.l10n.shopNow),
                  ),
                  const SizedBox(width: 4),
                  CavoCircleIconButton(
                    icon: Icons.arrow_forward_rounded,
                    isLight: isLight,
                    iconColor: CavoColors.gold,
                    onTap: onOpen,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  product.brand,
                  style: TextStyle(
                    color: secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroPager extends StatelessWidget {
  final int count;
  final int current;

  const _HeroPager({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          width: current == index ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: current == index ? CavoColors.gold : CavoColors.gold.withValues(alpha: 0.24),
          ),
        ),
      ),
    );
  }
}

class _CategoryEditorialCard extends StatelessWidget {
  final bool isLight;
  final CavoProduct product;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryEditorialCard({
    required this.isLight,
    required this.product,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 196,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CavoNetworkImage(imageUrl: product.coverUrl, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.72),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.34),
                    border: Border.all(color: CavoColors.gold.withValues(alpha: 0.25)),
                  ),
                  child: Icon(icon, color: CavoColors.gold, size: 18),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
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

class _BrandEditorialCard extends StatelessWidget {
  final String brand;
  final CavoProduct product;
  final bool isLight;

  const _BrandEditorialCard({
    required this.brand,
    required this.product,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return SizedBox(
      width: 248,
      child: CavoGlassCard(
        isLight: isLight,
        borderRadius: const BorderRadius.all(Radius.circular(26)),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                width: 92,
                height: double.infinity,
                child: CavoNetworkImage(imageUrl: product.thumbnailUrl ?? product.coverUrl, fit: BoxFit.cover),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.category.localizedLabel(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${product.price} EGP',
                    style: const TextStyle(
                      color: CavoColors.gold,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
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

class _FeaturedProductEditorialCard extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;
  final VoidCallback onTap;

  const _FeaturedProductEditorialCard({
    required this.product,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: CavoGlassCard(
        isLight: isLight,
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 156,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isLight ? const Color(0xFFF6F3EC) : const Color(0xFF161616),
                border: Border.all(
                  color: (isLight ? CavoColors.lightBorder : CavoColors.gold)
                      .withValues(alpha: isLight ? 0.55 : 0.15),
                ),
              ),
              child: Hero(
                tag: 'home-list-${product.id}',
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CavoNetworkImage(
                    imageUrl: product.thumbnailUrl ?? product.coverUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: primary,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              product.localizedShortDescription(context),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
