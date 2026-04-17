import 'package:flutter/widgets.dart';

import '../../core/localization/l10n_ext.dart';

enum ProductCategory { men, women, kids }

extension ProductCategoryX on ProductCategory {
  String get label {
    switch (this) {
      case ProductCategory.men:
        return 'Men';
      case ProductCategory.women:
        return 'Women';
      case ProductCategory.kids:
        return 'Kids';
    }
  }

  String get slug {
    switch (this) {
      case ProductCategory.men:
        return 'men';
      case ProductCategory.women:
        return 'women';
      case ProductCategory.kids:
        return 'kids';
    }
  }

  String localizedLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case ProductCategory.men:
        return l10n.men;
      case ProductCategory.women:
        return l10n.women;
      case ProductCategory.kids:
        return l10n.kids;
    }
  }
}

class CavoProduct {
  final String id;
  final String title;
  final String brand;
  final ProductCategory category;
  final int price;
  final int? originalPrice;
  final String coverUrl;
  final String? thumbnailUrl;
  final List<String> gallery;
  final List<String> sizes;
  final String shortDescription;
  final String description;
  final bool featured;

  const CavoProduct({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.coverUrl,
    this.thumbnailUrl,
    required this.gallery,
    required this.sizes,
    required this.shortDescription,
    required this.description,
    this.featured = false,
  });

  String localizedBrand(BuildContext context) => brand;
  String localizedTitle(BuildContext context) => title;
  String localizedShortDescription(BuildContext context) => shortDescription;
  String localizedDescription(BuildContext context) => description;
}
