import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CavoNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Alignment alignment;

  const CavoNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final dpr = MediaQuery.maybeOf(context)?.devicePixelRatio ?? 1.0;
        final targetWidth = width ?? (constraints.maxWidth.isFinite ? constraints.maxWidth : null);
        final targetHeight = height ?? (constraints.maxHeight.isFinite ? constraints.maxHeight : null);
        final cacheWidth = targetWidth == null ? null : math.max(64, (targetWidth * dpr).round());
        final cacheHeight = targetHeight == null ? null : math.max(64, (targetHeight * dpr).round());

        Widget child;
        if (imageUrl == null || imageUrl!.isEmpty) {
          child = const _ImageFallback();
        } else {
          child = Image.network(
            imageUrl!,
            width: width,
            height: height,
            fit: fit,
            alignment: alignment,
            filterQuality: FilterQuality.low,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            gaplessPlayback: true,
            frameBuilder: (context, image, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return image;
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                child: image,
              );
            },
            errorBuilder: (_, __, ___) => const _ImageFallback(),
            loadingBuilder: (context, widget, progress) {
              if (progress == null) return widget;
              final total = progress.expectedTotalBytes;
              final loaded = progress.cumulativeBytesLoaded;
              final value = total == null || total == 0 ? null : loaded / total;
              return _ImageFallback(loading: true, progress: value);
            },
          );
        }

        return ClipRRect(
          borderRadius: radius,
          child: ColoredBox(
            color: CavoColors.black,
            child: RepaintBoundary(child: child),
          ),
        );
      },
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final bool loading;
  final double? progress;

  const _ImageFallback({
    this.loading = false,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CavoColors.surfaceSoft,
            CavoColors.surface,
            CavoColors.surfaceSoft,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    CavoColors.gold.withValues(alpha: 0.22),
                    CavoColors.surfaceSoft,
                  ],
                ),
                border: Border.all(
                  color: CavoColors.gold.withValues(alpha: 0.16),
                ),
              ),
              child: Icon(
                loading ? Icons.photo_size_select_large_rounded : Icons.shopping_bag_rounded,
                color: CavoColors.gold,
                size: 30,
              ),
            ),
            if (loading) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: 84,
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(999),
                  backgroundColor: CavoColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(CavoColors.gold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
