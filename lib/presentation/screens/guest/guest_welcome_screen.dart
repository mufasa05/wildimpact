import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../providers/tourism_providers.dart';
import 'offset_checkout_dialog.dart';

class GuestWelcomeScreen extends ConsumerWidget {
  final Function(int)? onNavigateGuestTab;

  const GuestWelcomeScreen({super.key, this.onNavigateGuestTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lodge = ref.watch(selectedLodgeProvider);
    final projects = ref.watch(conservationProjectsProvider);
    final isMobile = MediaQuery.of(context).size.width < 800;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Safari Impact Banner
          GlassCard(
            padding: const EdgeInsets.all(32),
            backgroundColor: EcoColors.darkCardBg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    EcoBadge.gold(text: 'Verified Eco-Safari Guest', icon: Icons.stars_rounded),
                    Text(
                      lodge.name,
                      style: const TextStyle(color: EcoColors.textSecondaryLight, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your Safari is Actively Protecting Hwange\'s Wilderness',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: EcoColors.textPrimaryLight,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'By visiting this lodge, your conservation levy has directly funded ranger patrol boots on the ground and provided clean drinking water to surrounding villages.',
                  style: TextStyle(fontSize: 14, color: EcoColors.textSecondaryLight, height: 1.4),
                ),
                const SizedBox(height: 24),

                // 3 Highlights Row
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmall = constraints.maxWidth < 650;
                    return isSmall
                        ? Column(
                            children: [
                              _buildImpactPill('🛡️ 3 Ranger Patrols', 'Funded this week in Sector 7'),
                              const SizedBox(height: 10),
                              _buildImpactPill('💧 500L Clean Water', 'Supplied to Dete Village'),
                              const SizedBox(height: 10),
                              _buildImpactPill('🌳 40 Teak Saplings', 'Planted in buffer corridor'),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: _buildImpactPill('🛡️ 3 Ranger Patrols', 'Funded this week in Sector 7')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildImpactPill('💧 500L Clean Water', 'Supplied to Dete Village')),
                              const SizedBox(width: 12),
                              Expanded(child: _buildImpactPill('🌳 40 Teak Saplings', 'Planted in buffer corridor')),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 28),

                // Quick Action Bar
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    SafariGlowButton(
                      text: 'Offset Safari (\$15)',
                      icon: Icons.flight_takeoff_rounded,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => OffsetCheckoutDialog(
                            defaultTonnes: 2.1,
                            onPurchaseSuccess: (_) => onNavigateGuestTab?.call(2),
                          ),
                        );
                      },
                    ),
                    SafariGlowButton(
                      text: 'Calculate Emissions',
                      isSecondary: true,
                      icon: Icons.calculate_rounded,
                      onPressed: () => onNavigateGuestTab?.call(2),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Hyper-local Community Stories
          const Text(
            'Conservation & Community Projects Your Stay Supports',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
          ),
          const SizedBox(height: 4),
          const Text(
            'Transparent, GPS-verified projects preventing human-wildlife conflict',
            style: TextStyle(fontSize: 12.5, color: EcoColors.textSecondaryLight),
          ),
          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = isMobile ? 1 : 3;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: isMobile ? 240 : 250,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final p = projects[index];
                  return _buildProjectStoryCard(context, p, onNavigateGuestTab);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImpactPill(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EcoColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: EcoColors.mintAccent)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight)),
        ],
      ),
    );
  }

  Widget _buildProjectStoryCard(BuildContext context, dynamic proj, Function(int)? onNavigate) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(proj.type.iconEmoji, style: const TextStyle(fontSize: 28)),
              EcoBadge(text: '${proj.currentMetric.toInt()} ${proj.unit} Achieved', fontSize: 10.5),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            proj.name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              proj.description,
              style: const TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight, height: 1.3),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          SafariGlowButton(
            text: 'Fund This Project',
            isSecondary: true,
            height: 36,
            width: double.infinity,
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => OffsetCheckoutDialog(
                  defaultTonnes: 1.5,
                  onPurchaseSuccess: (_) => onNavigate?.call(2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
