import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/cavo_catalog.dart';
import '../../../data/models/product.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../../favorites/data/favorites_controller.dart';
import '../../product_details/presentation/product_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return Scaffold(
      backgroundColor: isLight ? CavoColors.lightBackground : CavoColors.background,
      body: CavoPremiumBackground(
        isLight: isLight,
        child: SafeArea(
          child: ValueListenableBuilder<Set<String>>(
            valueListenable: FavoritesController.instance,
            builder: (context, favoriteIds, _) {
              final products = favoriteIds
                  .map(CavoCatalog.findById)
                  .whereType<CavoProduct>()
                  .toList(growable: false);
              return ListView(
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
                              context.l10n.favorites,
                              style: TextStyle(
                                color: primary,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${products.length} ${context.l10n.itemsCountLabel} ${context.l10n.savedForLater}',
                              style: TextStyle(
                                color: secondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (products.isNotEmpty)
                        TextButton(
                          onPressed: FavoritesController.instance.clear,
                          child: Text(context.l10n.clearAll),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (products.isEmpty)
                    CavoGlassCard(
                      isLight: isLight,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: Column(
                        children: [
                          const Icon(Icons.favorite_outline_rounded, color: CavoColors.gold, size: 44),
                          const SizedBox(height: 12),
                          Text(
                            context.l10n.favoritesEmptyTitle,
                            style: TextStyle(
                              color: primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.startAddingFavorites,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: secondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
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
                        return _FavoriteProductCard(product: product, isLight: isLight);
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FavoriteProductCard extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;

  const _FavoriteProductCard({
    required this.product,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(
              product: product,
              heroTagBase: 'favorite-${product.id}',
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(26),
      child: CavoGlassCard(
        isLight: isLight,
        padding: const EdgeInsets.all(10),
        borderRadius: const BorderRadius.all(Radius.circular(26)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 126,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isLight ? const Color(0xFFF7F3E9) : const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Hero(
                    tag: 'favorite-${product.id}',
                    child: CavoNetworkImage(
                      imageUrl: product.thumbnailUrl ?? product.coverUrl,
                      fit: BoxFit.contain,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => FavoritesController.instance.toggle(product.id),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.38),
                        border: Border.all(color: CavoColors.gold.withValues(alpha: 0.18)),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: CavoColors.gold,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
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
            Text(
              '${product.price} EGP',
              style: const TextStyle(
                color: CavoColors.gold,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
