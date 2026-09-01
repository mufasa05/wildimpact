import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/immersive_background_scaffold.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../../domain/models/accessibility_feature.dart';
import '../../../domain/models/sme_provider.dart';
import '../../providers/tourism_providers.dart';

class UniversalAccessibilityScreen extends ConsumerStatefulWidget {
  const UniversalAccessibilityScreen({super.key});

  static const String backgroundUrl =
      'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=1600&q=80';

  @override
  ConsumerState<UniversalAccessibilityScreen> createState() => _UniversalAccessibilityScreenState();
}

class _UniversalAccessibilityScreenState extends ConsumerState<UniversalAccessibilityScreen> {
  AccessibilityGrade? _selectedGradeFilter;

  @override
  Widget build(BuildContext context) {
    final features = ref.watch(accessibilityFeaturesProvider);
    final smes = ref.watch(smeProvidersProvider);

    final filteredFeatures = _selectedGradeFilter == null
        ? features
        : features.where((f) => f.grade == _selectedGradeFilter).toList();

    return ImmersiveBackgroundScaffold(
      imageUrl: UniversalAccessibilityScreen.backgroundUrl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header
            _buildAccessibilityHeader(context),
            const SizedBox(height: 20),

            // Grade Filters
            _buildGradeFilters(),
            const SizedBox(height: 16),

            // Accessible Route Cards
            const Text(
              'ACCESSIBLE ROUTES, RAMPS & SENSORY TRAILS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: Colors.white),
            ),
            const SizedBox(height: 10),
            ...filteredFeatures.map((f) => _buildAccessibilityCard(context, f)),
            const SizedBox(height: 28),

            // Informal Community SME Marketplace Header
            _buildMarketplaceHeader(context),
            const SizedBox(height: 14),

            // SME Cards
            ...smes.map((sme) => _buildSmeCard(context, sme)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityHeader(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      border: BorderSide(color: EcoColors.mintAccent.withValues(alpha: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: EcoColors.emeraldGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.accessible_rounded, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UNIVERSAL ACCESSIBILITY & DISCOVERY LAYER',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: EcoColors.mintAccent,
                      ),
                    ),
                    Text(
                      'Inclusive Mobility & Community Enterprise Hub',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: EcoColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Eliminating physical accessibility blindspots for travelers with mobility needs through slope-rated GIS tracks, tactile pathing, and linking visitors directly with verified rural artisans and guides.',
            style: TextStyle(fontSize: 12.5, color: EcoColors.textSecondaryLight, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('All Accessibility Grades'),
            selected: _selectedGradeFilter == null,
            selectedColor: EcoColors.mintAccent,
            labelStyle: TextStyle(
              fontSize: 11.5,
              fontWeight: _selectedGradeFilter == null ? FontWeight.w800 : FontWeight.w600,
              color: _selectedGradeFilter == null ? Colors.black : Colors.white70,
            ),
            backgroundColor: Colors.black.withValues(alpha: 0.3),
            onSelected: (val) => setState(() => _selectedGradeFilter = null),
          ),
          const SizedBox(width: 8),
          ...AccessibilityGrade.values.map((grade) {
            final isSelected = _selectedGradeFilter == grade;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(grade.label.split(':')[0]),
                selected: isSelected,
                selectedColor: EcoColors.mintAccent,
                labelStyle: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? Colors.black : Colors.white70,
                ),
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                onSelected: (val) => setState(() => _selectedGradeFilter = val ? grade : null),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAccessibilityCard(BuildContext context, AccessibilityFeature f) {
    final isGrade1 = f.grade == AccessibilityGrade.grade1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        border: BorderSide(
          color: isGrade1 ? EcoColors.emeraldPrimary.withValues(alpha: 0.4) : EcoColors.cardBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    f.name,
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isGrade1 ? EcoColors.emeraldPrimary.withValues(alpha: 0.2) : EcoColors.savannaGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    f.grade.label.split(':')[0],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: isGrade1 ? EcoColors.mintAccent : EcoColors.savannaGold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '📍 ${f.destinationName} • ${f.location}',
              style: const TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight),
            ),
            const SizedBox(height: 10),

            // Incline & Feature Badges
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildAttrBadge('Slope: ${f.slopeInclinePct}%', Icons.trending_up_rounded, EcoColors.mintAccent),
                _buildAttrBadge('Steps: ${f.stepCount}', Icons.stairs_rounded, f.stepCount == 0 ? EcoColors.mintAccent : EcoColors.savannaGold),
                if (f.hasTactilePaving) _buildAttrBadge('Tactile Paved', Icons.touch_app_rounded, EcoColors.mintAccent),
                if (f.hasAccessibleAblution) _buildAttrBadge('Accessible Restroom', Icons.wc_rounded, EcoColors.mintAccent),
                if (f.hasMountingPlatform) _buildAttrBadge('Safari Vehicle Ramp', Icons.directions_bus_rounded, EcoColors.savannaGold),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              f.notes,
              style: const TextStyle(fontSize: 11.5, color: EcoColors.textMuted, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttrBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _buildMarketplaceHeader(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      border: BorderSide(color: EcoColors.savannaGold.withValues(alpha: 0.3)),
      child: const Row(
        children: [
          Icon(Icons.storefront_rounded, color: EcoColors.savannaGold, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INFORMAL COMMUNITY ENTERPRISE & ARTISAN MARKETPLACE',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: EcoColors.savannaGold),
                ),
                Text(
                  'Direct 0%-commission WhatsApp booking connecting tourists directly to rural craftspeople & village homestays.',
                  style: TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmeCard(BuildContext context, SmeProvider sme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        sme.businessName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      if (sme.isEcoCertified)
                        const Icon(Icons.verified_rounded, color: EcoColors.mintAccent, size: 16),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '👤 ${sme.ownerName} • 📍 ${sme.location}',
                    style: const TextStyle(fontSize: 11.5, color: EcoColors.savannaGold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sme.description,
                    style: const TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'From US\$${sme.startingPriceUsd.toStringAsFixed(0)} ${sme.priceUnit}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: EcoColors.mintAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SafariGlowButton(
              text: 'WhatsApp',
              icon: Icons.chat_bubble_outline_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening direct WhatsApp inquiry to ${sme.ownerName} (${sme.whatsappNumber}) - 0% fee'),
                    backgroundColor: EcoColors.forestDeep,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
