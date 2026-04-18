import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/cavo_network_image.dart';
import '../../../shared/widgets/cavo_premium_ui.dart';

class ProductGalleryViewerScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String heroTag;
  final String title;

  const ProductGalleryViewerScreen({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.heroTag,
    required this.title,
  });

  @override
  State<ProductGalleryViewerScreen> createState() => _ProductGalleryViewerScreenState();
}

class _ProductGalleryViewerScreenState extends State<ProductGalleryViewerScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF000000), Color(0xFF070504), Color(0xFF000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    CavoColors.gold.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    children: [
                      CavoCircleIconButton(
                        icon: Icons.close_rounded,
                        isLight: false,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      CavoGlassCard(
                        isLight: false,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        borderRadius: const BorderRadius.all(Radius.circular(18)),
                        child: Text(
                          '${_currentIndex + 1}/${widget.images.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.images.length,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    itemBuilder: (context, index) {
                      final image = widget.images[index];
                      final isHero = index == widget.initialIndex;
                      return Center(
                        child: InteractiveViewer(
                          minScale: 1,
                          maxScale: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Hero(
                              tag: isHero ? widget.heroTag : '${widget.heroTag}-$index',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: CavoNetworkImage(
                                  imageUrl: image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 82,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.images.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final selected = index == _currentIndex;
                            return GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 260),
                                  curve: Curves.easeOutCubic,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                width: 78,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: selected
                                        ? CavoColors.gold
                                        : CavoColors.gold.withValues(alpha: 0.12),
                                  ),
                                  boxShadow: selected
                                      ? [
                                          BoxShadow(
                                            color: CavoColors.gold.withValues(alpha: 0.16),
                                            blurRadius: 18,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: CavoNetworkImage(
                                  imageUrl: widget.images[index],
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pinch to zoom • Swipe to explore • Tap close to return',
                        style: TextStyle(
                          color: Color(0xFFB8B1A3),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
