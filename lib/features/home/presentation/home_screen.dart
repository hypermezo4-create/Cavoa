import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: CavoColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      CavoColors.gold.withValues(alpha: 0.10),
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
                          _CircleIconButton(
                            icon: Icons.notifications_none_rounded,
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: CavoColors.surface.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
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
                      Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
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
                              'Premium Footwear\nDesigned to Stand Apart',
                              style: TextStyle(
                                color: CavoColors.textPrimary,
                                fontSize: 28,
                                height: 1.1,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
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
                                    onPressed: () {},
                                    child: const Text('Shop Now'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const _CircleIconButton(
                                  icon: Icons.arrow_forward_rounded,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const _SectionHeader(
                        title: 'Shop by Category',
                        action: 'View All',
                      ),
                      const SizedBox(height: 14),
                      const Row(
                        children: [
                          Expanded(
                            child: _CategoryCard(
                              title: 'Men',
                              icon: Icons.man_rounded,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _CategoryCard(
                              title: 'Women',
                              icon: Icons.woman_rounded,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _CategoryCard(
                              title: 'Kids',
                              icon: Icons.child_care_rounded,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const _SectionHeader(
                        title: 'Top Brands',
                        action: 'More',
                      ),
                      const SizedBox(height: 14),
                      const Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _BrandChip(label: 'Nike'),
                          _BrandChip(label: 'Adidas'),
                          _BrandChip(label: 'Puma'),
                          _BrandChip(label: 'New Balance'),
                          _BrandChip(label: 'McQueen'),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const _SectionHeader(
                        title: 'Featured Collection',
                        action: 'See All',
                      ),
                      const SizedBox(height: 14),
                      const _ProductCard(
                        title: 'CAVO Gold Signature',
                        subtitle: 'Premium Footwear',
                        price: '3,850 EGP',
                      ),
                      const SizedBox(height: 14),
                      const _ProductCard(
                        title: 'Mirror Black Edition',
                        subtitle: 'Luxury street silhouette',
                        price: '2,750 EGP',
                      ),
                      const SizedBox(height: 120),
                    ],
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
        width: 46,
        height: 46,
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

  const _SectionHeader({
    required this.title,
    required this.action,
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
        Text(
          action,
          style: const TextStyle(
            color: CavoColors.gold,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _CategoryCard({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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

class _ProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;

  const _ProductCard({
    required this.title,
    required this.subtitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CavoColors.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: CavoColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 88,
            height: 88,
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
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: CavoColors.gold,
              size: 34,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CavoColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: CavoColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  price,
                  style: const TextStyle(
                    color: CavoColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
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
    );
  }
}