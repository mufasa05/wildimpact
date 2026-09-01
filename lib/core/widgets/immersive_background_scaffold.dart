import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/eco_colors.dart';

class ImmersiveBackgroundScaffold extends StatelessWidget {
  final String imageUrl;
  final Widget child;
  final double overlayOpacity;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;

  const ImmersiveBackgroundScaffold({
    super.key,
    required this.imageUrl,
    required this.child,
    this.overlayOpacity = 0.88,
    this.floatingActionButton,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoColors.obsidianBg,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Cached Image
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 300),
            placeholder: (context, url) => Container(
              color: EcoColors.obsidianBg,
            ),
            errorWidget: (context, url, error) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF06140E), Color(0xFF0B2117)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Dark Luxury Glass Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  EcoColors.obsidianBg.withValues(alpha: overlayOpacity),
                  EcoColors.darkCardBg.withValues(alpha: overlayOpacity + 0.05),
                  EcoColors.obsidianBg.withValues(alpha: overlayOpacity + 0.08),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content Layer
          SafeArea(
            bottom: false,
            child: child,
          ),
        ],
      ),
    );
  }
}
