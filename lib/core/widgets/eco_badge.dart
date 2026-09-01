import 'package:flutter/material.dart';
import '../theme/eco_colors.dart';

class EcoBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double fontSize;

  const EcoBadge({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor = const Color(0x2210B981),
    this.textColor = EcoColors.mintAccent,
    this.borderColor = const Color(0x4410B981),
    this.fontSize = 11.5,
  });

  factory EcoBadge.gold({required String text, IconData? icon}) {
    return EcoBadge(
      text: text,
      icon: icon,
      backgroundColor: const Color(0x22E5A93C),
      textColor: EcoColors.savannaGold,
      borderColor: const Color(0x44E5A93C),
    );
  }

  factory EcoBadge.danger({required String text, IconData? icon}) {
    return EcoBadge(
      text: text,
      icon: icon,
      backgroundColor: const Color(0x22EF4444),
      textColor: EcoColors.error,
      borderColor: const Color(0x44EF4444),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null ? Border.all(color: borderColor!, width: 1) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 1, color: textColor),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
