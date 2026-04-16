import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CavoNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CavoNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(0);

    Widget child;
    if (imageUrl == null || imageUrl!.isEmpty) {
      child = const _ImageFallback();
    } else {
      child = Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => const _ImageFallback(),
        loadingBuilder: (context, widget, progress) {
          if (progress == null) return widget;
          return const _ImageFallback(loading: true);
        },
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: child,
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final bool loading;

  const _ImageFallback({this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CavoColors.surfaceSoft,
      child: Center(
        child: Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                CavoColors.gold.withValues(alpha: 0.24),
                CavoColors.surfaceSoft,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            loading ? Icons.hourglass_bottom_rounded : Icons.shopping_bag_rounded,
            color: CavoColors.gold,
            size: 28,
          ),
        ),
      ),
    );
  }
}