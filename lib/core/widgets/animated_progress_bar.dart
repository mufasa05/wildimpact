import 'package:flutter/material.dart';
import '../theme/eco_colors.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? progressColor;
  final Color? trackColor;
  final double height;
  final String? label;
  final String? trailingText;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.progressColor,
    this.trackColor,
    this.height = 8,
    this.label,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || trailingText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: EcoColors.textSecondaryLight,
                    ),
                  ),
                if (trailingText != null)
                  Text(
                    trailingText!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: EcoColors.mintAccent,
                    ),
                  ),
              ],
            ),
          ),
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: trackColor ?? Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * clamped,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: progressColor != null
                          ? null
                          : EcoColors.emeraldGradient,
                      color: progressColor,
                      borderRadius: BorderRadius.circular(height / 2),
                      boxShadow: [
                        BoxShadow(
                          color: (progressColor ?? EcoColors.emeraldPrimary).withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
