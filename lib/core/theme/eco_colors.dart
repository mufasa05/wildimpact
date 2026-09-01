import 'package:flutter/material.dart';

/// Luxury African Savanna & Emerald Conservation Color Palette
class EcoColors {
  // Deep Backgrounds
  static const Color obsidianBg = Color(0xFF08130E);
  static const Color darkCardBg = Color(0xFF0E221B);
  static const Color darkCardBgHover = Color(0xFF143026);
  static const Color cardBorder = Color(0x3334D399);

  // Emerald & Forest Accents (Conservation & Vitality)
  static const Color emeraldPrimary = Color(0xFF10B981);
  static const Color mintAccent = Color(0xFF34D399);
  static const Color forestDeep = Color(0xFF064E3B);
  static const Color lightMint = Color(0xFFD1FAE5);

  // African Ochre & Savanna Gold (Warmth & Prestige)
  static const Color savannaGold = Color(0xFFE5A93C);
  static const Color amberWarm = Color(0xFFF59E0B);
  static const Color sunsetGlow = Color(0xFFF97316);

  // Earth & Wildlife Tones
  static const Color terracotta = Color(0xFFD97706);
  static const Color sandCream = Color(0xFFFBF8F2);
  static const Color sandMuted = Color(0xFFE2D9C8);
  static const Color darkSurface = Color(0xFF0D1C16);

  // Status & Utility
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF0284C7);
  static const Color warning = Color(0xFFEAB308);
  static const Color error = Color(0xFFEF4444);

  // Text colors
  static const Color textPrimaryLight = Color(0xFFF9FAFB);
  static const Color textSecondaryLight = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // Gradients
  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient savannaGradient = LinearGradient(
    colors: [Color(0xFFE5A93C), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF10271F), Color(0xFF091712)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassOverlayGradient = LinearGradient(
    colors: [Color(0x2210B981), Color(0x05000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
