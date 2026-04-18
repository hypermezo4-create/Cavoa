import 'package:flutter/material.dart';

import '../../../core/localization/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/cavo_catalog.dart';
import '../../../data/models/product.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';
import '../../favorites/data/favorites_controller.dart';
import '../../product_details/presentation/product_details_screen.dart';
import '../data/search_history_controller.dart';

enum ProductSortMode { recommended, priceLowHigh, priceHighLow, alphabetical }

class SearchScreen extends StatefulWidget {
  final ProductCategory? initialCategory;
  final String initialQuery;

  const SearchScreen({
    super.key,
    this.initialCategory,
    this.initialQuery = '',
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  ProductCategory? _selectedCategory;
  String _selectedBrand = 'All';
  String _selectedSize = 'All';
  ProductSortMode _sortMode = ProductSortMode.recommended;

  String get _query => _searchController.text.trim().toLowerCase();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery)
      ..addListener(() => setState(() {}));
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _brands {
    final brands = _selectedCategory == null
        ? CavoCatalog.allBrands()
        : CavoCatalog.brandsFor(_selectedCategory!).where((brand) => brand != 'All').toList();
    return ['All', ...brands];
  }

  List<String> get _sizes {
    final source = _selectedCategory == null
        ? CavoCatalog.products
        : CavoCatalog.byCategory(_selectedCategory!);
    final sizes = source.expand((product) => product.sizes).toSet().toList()..sort();
    return ['All', ...sizes];
  }

  List<CavoProduct> get _results {
    Iterable<CavoProduct> products = _selectedCategory == null
        ? CavoCatalog.products
        : CavoCatalog.byCategory(_selectedCategory!);

    if (_selectedBrand != 'All') {
      products = products.where((product) => product.brand == _selectedBrand);
    }
    if (_selectedSize != 'All') {
      products = products.where((product) => product.sizes.contains(_selectedSize));
    }
    if (_query.isNotEmpty) {
      products = products.where((product) {
        final haystack = [
          product.title,
          product.brand,
          product.shortDescription,
          product.description,
          product.category.label,
        ].join(' ').toLowerCase();
        return haystack.contains(_query);
      });
    }

    final items = products.toList(growable: false);
    switch (_sortMode) {
      case ProductSortMode.recommended:
        items.sort((a, b) {
          if (a.featured != b.featured) return a.featured ? -1 : 1;
          return a.price.compareTo(b.price);
        });
        break;
      case ProductSortMode.priceLowHigh:
        items.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortMode.priceHighLow:
        items.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortMode.alphabetical:
        items.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }
    return items;
  }

  Future<void> _saveSearchTerm() async {
    final term = _searchController.text.trim();
    if (term.isNotEmpty) {
      await SearchHistoryController.instance.addTerm(term);
    }
  }

  String _sortLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (_sortMode) {
      case ProductSortMode.recommended:
        return l10n.recommended;
      case ProductSortMode.priceLowHigh:
        return l10n.priceLowToHigh;
      case ProductSortMode.priceHighLow:
        return l10n.priceHighToLow;
      case ProductSortMode.alphabetical:
        return l10n.alphabetical;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;
    final results = _results;
    final l10n = context.l10n;

    if (!_brands.contains(_selectedBrand)) {
      _selectedBrand = 'All';
    }
    if (!_sizes.contains(_selectedSize)) {
      _selectedSize = 'All';
    }

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
                          l10n.search,
                          style: TextStyle(
                            color: primary,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.searchProductsBrands,
                          style: TextStyle(
                            color: secondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<ProductSortMode>(
                    initialValue: _sortMode,
                    onSelected: (value) => setState(() => _sortMode = value),
                    itemBuilder: (_) => [
                      PopupMenuItem(value: ProductSortMode.recommended, child: Text(l10n.recommended)),
                      PopupMenuItem(value: ProductSortMode.priceLowHigh, child: Text(l10n.priceLowToHigh)),
                      PopupMenuItem(value: ProductSortMode.priceHighLow, child: Text(l10n.priceHighToLow)),
                      PopupMenuItem(value: ProductSortMode.alphabetical, child: Text(l10n.alphabetical)),
                    ],
                    icon: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (isLight ? Colors.white : CavoColors.surface)
                            .withValues(alpha: isLight ? 0.84 : 0.90),
                        border: Border.all(
                          color: isLight
                              ? CavoColors.lightBorder
                              : CavoColors.gold.withValues(alpha: 0.16),
                        ),
                      ),
                      child: const Icon(Icons.swap_vert_rounded, color: CavoColors.gold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              CavoGlassCard(
                isLight: isLight,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                borderRadius: const BorderRadius.all(Radius.circular(26)),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: secondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _saveSearchTerm(),
                        style: TextStyle(color: primary, fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          hintText: l10n.searchProductsBrands,
                          hintStyle: TextStyle(color: secondary, fontWeight: FontWeight.w600),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: () => _searchController.clear(),
                        icon: const Icon(Icons.close_rounded, color: CavoColors.gold),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              CavoGlassCard(
                isLight: isLight,
                borderRadius: const BorderRadius.all(Radius.circular(28)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.filters,
                            style: TextStyle(
                              color: primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          '${results.length} ${l10n.itemsCountLabel}',
                          style: TextStyle(
                            color: CavoColors.gold,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _FilterSection(
                      label: l10n.category,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _SelectableChip(
                            label: l10n.allCategories,
                            selected: _selectedCategory == null,
                            isLight: isLight,
                            onTap: () => setState(() => _selectedCategory = null),
                          ),
                          for (final category in ProductCategory.values)
                            _SelectableChip(
                              label: category.localizedLabel(context),
                              selected: _selectedCategory == category,
                              isLight: isLight,
                              onTap: () => setState(() => _selectedCategory = category),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _FilterSection(
                      label: l10n.brandsTitle,
                      child: SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _brands.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final brand = _brands[index];
                            return _SelectableChip(
                              label: brand == 'All' ? l10n.allBrands : brand,
                              selected: _selectedBrand == brand,
                              isLight: isLight,
                              onTap: () => setState(() => _selectedBrand = brand),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _FilterSection(
                      label: l10n.size,
                      child: SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _sizes.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final size = _sizes[index];
                            return _SelectableChip(
                              label: size == 'All' ? l10n.allSizes : size,
                              selected: _selectedSize == size,
                              isLight: isLight,
                              onTap: () => setState(() => _selectedSize = size),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.sort_rounded, color: secondary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '${l10n.sortBy}: ${_sortLabel(context)}',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ValueListenableBuilder<List<String>>(
                valueListenable: SearchHistoryController.instance,
                builder: (context, history, _) {
                  if (history.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.recentSearches,
                              style: TextStyle(
                                color: primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => SearchHistoryController.instance.clear(),
                            child: Text(l10n.clearAll),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: history
                            .map(
                              (term) => InputChip(
                                label: Text(term),
                                onPressed: () {
                                  _searchController.text = term;
                                  _saveSearchTerm();
                                },
                                onDeleted: () => SearchHistoryController.instance.removeTerm(term),
                              ),
                            )
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 18),
                    ],
                  );
                },
              ),
              if (results.isEmpty)
                CavoGlassCard(
                  isLight: isLight,
                  borderRadius: const BorderRadius.all(Radius.circular(28)),
                  child: Column(
                    children: [
                      const Icon(Icons.search_off_rounded, color: CavoColors.gold, size: 44),
                      const SizedBox(height: 12),
                      Text(
                        l10n.noResultsFound,
                        style: TextStyle(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.tryDifferentKeyword,
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
                  itemCount: results.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    final product = results[index];
                    return _SearchProductCard(
                      product: product,
                      isLight: isLight,
                      onFavoriteChanged: _saveSearchTerm,
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

class _FilterSection extends StatelessWidget {
  final String label;
  final Widget child;

  const _FilterSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: primary,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isLight;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CavoPillTag(
        label: label,
        isLight: isLight,
        selected: selected,
      ),
    );
  }
}

class _SearchProductCard extends StatelessWidget {
  final CavoProduct product;
  final bool isLight;
  final Future<void> Function() onFavoriteChanged;

  const _SearchProductCard({
    required this.product,
    required this.isLight,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isLight ? CavoColors.lightTextPrimary : CavoColors.textPrimary;
    final secondary = isLight ? CavoColors.lightTextSecondary : CavoColors.textSecondary;

    return InkWell(
      onTap: () async {
        await SearchHistoryController.instance.addTerm(product.title);
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(
              product: product,
              heroTagBase: 'search-${product.id}',
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
                    tag: 'search-${product.id}',
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
                  child: ValueListenableBuilder<Set<String>>(
                    valueListenable: FavoritesController.instance,
                    builder: (context, favorites, _) {
                      final active = favorites.contains(product.id);
                      return GestureDetector(
                        onTap: () async {
                          await FavoritesController.instance.toggle(product.id);
                          await onFavoriteChanged();
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.38),
                            border: Border.all(color: CavoColors.gold.withValues(alpha: 0.18)),
                          ),
                          child: Icon(
                            active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: active ? CavoColors.gold : Colors.white,
                            size: 18,
                          ),
                        ),
                      );
                    },
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
