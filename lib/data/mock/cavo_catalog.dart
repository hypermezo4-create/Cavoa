import '../models/product.dart';

class CavoCatalog {
  static const String _base = 'https://ik.imagekit.io/luivuvevia/cavo';

  static const List<String> menSizes = ['41', '42', '43', '44', '45', '46'];
  static const List<String> womenSizes = ['36', '37', '38', '39', '40', '41'];
  static const List<String> kidsSizes = ['22', '24', '26', '28', '30', '32', '34'];

  static final List<CavoProduct> products = [
    CavoProduct(
      id: 'air-force-beige-brown',
      title: 'Air Force Beige Brown',
      brand: 'Nike',
      category: ProductCategory.men,
      price: 2850,
      originalPrice: 3100,
      coverUrl: '$_base/products/men/air-force/air-force-beige-brown/cover.webp',
      thumbnailUrl: '$_base/products/men/air-force/air-force-beige-brown/thumb.webp',
      gallery: [
        '$_base/products/men/air-force/air-force-beige-brown/cover.webp',
        '$_base/products/men/air-force/air-force-beige-brown/1.webp',
        '$_base/products/men/air-force/air-force-beige-brown/2.webp',
      ],
      sizes: menSizes,
      shortDescription: 'Mirror original men’s statement pair.',
      description:
          'A premium men’s silhouette with a refined beige-brown finish, built for elevated everyday styling and a strong luxury street presence.',
      featured: true,
    ),
    CavoProduct(
      id: 'samba-red',
      title: 'Samba Red',
      brand: 'Adidas',
      category: ProductCategory.women,
      price: 2650,
      originalPrice: 2990,
      coverUrl: '$_base/products/women/samba/samba-red/cover.webp',
      thumbnailUrl: '$_base/products/women/samba/samba-red/thumb.webp',
      gallery: [
        '$_base/products/women/samba/samba-red/cover.webp',
        '$_base/products/women/samba/samba-red/1.webp',
        '$_base/products/women/samba/samba-red/2.webp',
      ],
      sizes: womenSizes,
      shortDescription: 'Premium Samba colorway with bold character.',
      description:
          'A polished women’s Samba edition with a confident red finish, mirror original detailing, and an elegant premium feel.',
      featured: true,
    ),
    CavoProduct(
      id: 'samba-white',
      title: 'Samba White',
      brand: 'Adidas',
      category: ProductCategory.women,
      price: 2750,
      originalPrice: 3000,
      coverUrl: '$_base/products/women/samba/samba-white/cover.webp',
      thumbnailUrl: '$_base/products/women/samba/samba-white/thumb.webp',
      gallery: [
        '$_base/products/women/samba/samba-white/cover.webp',
        '$_base/products/women/samba/samba-white/1.webp',
        '$_base/products/women/samba/samba-white/2.webp',
        '$_base/products/women/samba/samba-white/3.webp',
        '$_base/products/women/samba/samba-white/4.webp',
        '$_base/products/women/samba/samba-white/5.webp',
      ],
      sizes: womenSizes,
      shortDescription: 'Clean luxury finish with premium balance.',
      description:
          'A bright premium women’s pair designed for a clean standout look, featuring a refined upper and elevated mirror original presence.',
      featured: true,
    ),
    CavoProduct(
      id: 'kids-premium-starter',
      title: 'Kids Premium Starter',
      brand: 'CAVO',
      category: ProductCategory.kids,
      price: 2150,
      originalPrice: 2400,
      coverUrl: '$_base/products/kids/premium-starter/cover.webp',
      thumbnailUrl: '$_base/products/kids/premium-starter/thumb.webp',
      gallery: [
        '$_base/products/kids/premium-starter/cover.webp',
      ],
      sizes: kidsSizes,
      shortDescription: 'Kids premium pair with soft everyday styling.',
      description:
          'A starter premium kids selection prepared for the next catalog batch. If the uploaded image is not ready yet, the UI will gracefully fall back.',
      featured: false,
    ),
  ];

  static List<CavoProduct> featured() =>
      products.where((e) => e.featured).toList();

  static List<CavoProduct> byCategory(ProductCategory category) =>
      products.where((e) => e.category == category).toList();

  static List<String> brandsFor(ProductCategory category) {
    final brands = byCategory(category).map((e) => e.brand).toSet().toList();
    brands.sort();
    return ['All', ...brands];
  }

  static List<CavoProduct> filtered({
    required ProductCategory category,
    required String brand,
  }) {
    final base = byCategory(category);
    if (brand == 'All') return base;
    return base.where((e) => e.brand == brand).toList();
  }
}