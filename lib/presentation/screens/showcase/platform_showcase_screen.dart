import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../providers/tourism_providers.dart';

class PlatformShowcaseScreen extends ConsumerWidget {
  final Function(int)? onNavigateTab;

  const PlatformShowcaseScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width >= 1000;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner
          _buildHeroHeader(context, ref),
          const SizedBox(height: 24),

          // 4 Top Core Pillars
          _buildFourPillarsRow(context),
          const SizedBox(height: 28),

          // Middle Section: Mission & How It Works & Where Impact Goes
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Mission & How It Works Flow
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _buildMissionCard(),
                      const SizedBox(height: 20),
                      _buildHowItWorksCard(),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                // Right Column: Where Impact Goes & Beneficiaries
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      _buildWhereImpactGoesCard(),
                      const SizedBox(height: 20),
                      _buildBeneficiariesCard(),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            _buildMissionCard(),
            const SizedBox(height: 20),
            _buildHowItWorksCard(),
            const SizedBox(height: 20),
            _buildWhereImpactGoesCard(),
            const SizedBox(height: 20),
            _buildBeneficiariesCard(),
          ],
          const SizedBox(height: 28),

          // Bottom Tri-Card Matrix: Key Features, Tech Stack & Value Proposition
          _buildBottomMatrix(context),
          const SizedBox(height: 24),

          // Footer Banner
          _buildFooterBar(),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF0F261D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: EcoColors.cardBorder),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=1600&q=80'),
          fit: BoxFit.cover,
          opacity: 0.18,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 14,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: EcoColors.emeraldPrimary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.eco_rounded, color: EcoColors.mintAccent, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Eco-Impact B2B',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: EcoColors.textPrimaryLight,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Tourism Platform',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: EcoColors.mintAccent,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  SafariGlowButton(
                    text: 'Launch Dashboard',
                    icon: Icons.dashboard_rounded,
                    onPressed: () {
                      ref.read(activeRoleProvider.notifier).state = UserRole.operator;
                      onNavigateTab?.call(0);
                    },
                  ),
                  SafariGlowButton(
                    text: 'Open Guest App',
                    icon: Icons.smartphone_rounded,
                    isSecondary: true,
                    onPressed: () {
                      ref.read(activeRoleProvider.notifier).state = UserRole.guest;
                      onNavigateTab?.call(0);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Empowering Safari Operators. Funding Conservation. Impacting Communities.\nTrack. Fund. Protect.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: EcoColors.savannaGold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'A multi-tenant SaaS platform that helps tour operators track eco-impact, fund conservation, and showcase real results to conscious travelers.',
            style: TextStyle(fontSize: 13.5, color: EcoColors.textSecondaryLight, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildFourPillarsRow(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth < 650 ? 1 : constraints.maxWidth < 1100 ? 2 : 4;
        return GridView.count(
          crossAxisCount: crossCount,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: crossCount == 1 ? 2.8 : crossCount == 2 ? 2.4 : 1.9,
          children: [
            _buildPillarBadge(Icons.energy_savings_leaf_rounded, 'Real-time Impact Tracking', 'GNSS telemetry & sensors'),
            _buildPillarBadge(Icons.shield_rounded, 'Wildlife & Habitat Conservation', 'Anti-poaching & biodiversity'),
            _buildPillarBadge(Icons.groups_rounded, 'Community Empowerment', 'CAMPFIRE & clean water'),
            _buildPillarBadge(Icons.cloud_done_rounded, 'Carbon Footprint & Offsets', 'Verified native teak reforestation'),
          ],
        );
      },
    );
  }

  Widget _buildPillarBadge(IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF11261E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EcoColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: EcoColors.emeraldPrimary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: EcoColors.mintAccent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: const TextStyle(fontSize: 10.5, color: EcoColors.textSecondaryLight),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.nature_rounded, color: EcoColors.mintAccent, size: 20),
              SizedBox(width: 8),
              Text(
                'Our Mission',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: EcoColors.textPrimaryLight),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF10251C),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=800&q=80',
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF10251C),
                  alignment: Alignment.center,
                  child: const Icon(Icons.nature_people_rounded, color: EcoColors.mintAccent, size: 36),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'To bridge tourism and conservation through transparency, technology and trust—creating a sustainable future for wildlife and communities across Africa.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: EcoColors.textPrimaryLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 600;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'HOW IT WORKS',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1.0, color: EcoColors.savannaGold),
              ),
              const SizedBox(height: 16),
              if (isSmall)
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.3,
                  children: [
                    _buildStepBox('1', Icons.luggage_rounded, 'Tourist Books\na Tour'),
                    _buildStepBox('2', Icons.eco_rounded, 'Pays Eco-Impact\nContribution'),
                    _buildStepBox('3', Icons.analytics_rounded, 'Impact Tracked\nin Real-time'),
                    _buildStepBox('4', Icons.public_rounded, 'Conservation &\nCommunities Benefit'),
                  ],
                )
              else
                Row(
                  children: [
                    _buildStepItem('1', Icons.luggage_rounded, 'Tourist Books\na Tour'),
                    _buildArrowConnector(),
                    _buildStepItem('2', Icons.eco_rounded, 'Pays Eco-Impact\nContribution'),
                    _buildArrowConnector(),
                    _buildStepItem('3', Icons.analytics_rounded, 'Impact Tracked\nin Real-time'),
                    _buildArrowConnector(),
                    _buildStepItem('4', Icons.public_rounded, 'Conservation &\nCommunities Benefit'),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepBox(String step, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: EcoColors.mintAccent, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String step, IconData icon, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF143024),
              shape: BoxShape.circle,
              border: Border.all(color: EcoColors.mintAccent.withValues(alpha: 0.6), width: 1.5),
            ),
            child: Icon(icon, color: EcoColors.mintAccent, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowConnector() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Icon(Icons.arrow_forward_rounded, color: EcoColors.mintAccent, size: 14),
    );
  }

  Widget _buildWhereImpactGoesCard() {
    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WHERE YOUR IMPACT GOES',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1.0, color: EcoColors.mintAccent),
          ),
          const SizedBox(height: 16),
          _buildImpactPillarItem(
            imageUrl: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=400&q=80',
            title: 'ANTI-POACHING',
            desc: 'Funding ranger patrols, equipment, night thermal scopes, and wildlife corridor protection.',
            icon: Icons.shield_rounded,
            iconColor: EcoColors.mintAccent,
          ),
          const SizedBox(height: 12),
          _buildImpactPillarItem(
            imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
            title: 'COMMUNITY PROJECTS',
            desc: 'Supporting solar clean water boreholes, education, health clinics, and sustainable livelihoods.',
            icon: Icons.groups_rounded,
            iconColor: EcoColors.savannaGold,
          ),
          const SizedBox(height: 12),
          _buildImpactPillarItem(
            imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=400&q=80',
            title: 'HABITAT RESTORATION',
            desc: 'Reforesting native Zambezi teak, invasive species control, and wildlife corridor rewilding.',
            icon: Icons.park_rounded,
            iconColor: EcoColors.emeraldPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildImpactPillarItem({
    required String imageUrl,
    required String title,
    required String desc,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF10251C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EcoColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 60,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F261D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: iconColor, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: iconColor, letterSpacing: 0.5),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficiariesCard() {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BENEFICIARIES',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: EcoColors.textPrimaryLight),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 600;
              if (isSmall) {
                return Column(
                  children: [
                    _buildBeneficiaryItem('🐘', 'WILDLIFE', 'Protected habitats & species survival'),
                    const SizedBox(height: 8),
                    _buildBeneficiaryItem('👥', 'COMMUNITIES', 'Better livelihoods & local development'),
                    const SizedBox(height: 8),
                    _buildBeneficiaryItem('🌍', 'PLANET', 'Lower emissions, healthier ecosystems'),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: _buildBeneficiaryItem('🐘', 'WILDLIFE', 'Protected habitats & species survival')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildBeneficiaryItem('👥', 'COMMUNITIES', 'Better livelihoods & local development')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildBeneficiaryItem('🌍', 'PLANET', 'Lower emissions, healthier ecosystems')),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficiaryItem(String emoji, String title, String sub) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: EcoColors.textPrimaryLight)),
          const SizedBox(height: 2),
          Text(sub, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9.5, color: EcoColors.textSecondaryLight, height: 1.2)),
        ],
      ),
    );
  }

  Widget _buildBottomMatrix(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        return isMobile
            ? Column(
                children: [
                  _buildKeyFeaturesCard(),
                  const SizedBox(height: 16),
                  _buildValuePropCard(),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildKeyFeaturesCard()),
                  const SizedBox(width: 20),
                  Expanded(child: _buildValuePropCard()),
                ],
              );
      },
    );
  }

  Widget _buildKeyFeaturesCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('KEY FEATURES', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: EcoColors.mintAccent)),
          const SizedBox(height: 14),
          _buildFeatureItem(Icons.analytics_rounded, 'Real-time Impact Dashboard'),
          _buildFeatureItem(Icons.camera_alt_rounded, 'Geo-tagged Impact Evidence'),
          _buildFeatureItem(Icons.shopping_cart_rounded, 'Carbon Offset Marketplace'),
          _buildFeatureItem(Icons.description_rounded, 'Automated ESG Reports'),
          _buildFeatureItem(Icons.apartment_rounded, 'Multi-tenant SaaS for Operators'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 17, color: EcoColors.mintAccent),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 12.5, color: EcoColors.textPrimaryLight, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildValuePropCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('VALUE PROPOSITION', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: EcoColors.emeraldPrimary)),
          const SizedBox(height: 14),
          _buildPropCheck('Differentiate your brand with provable impact'),
          _buildPropCheck('Meet ESG & sustainability requirements'),
          _buildPropCheck('Increase guest trust and loyalty'),
          _buildPropCheck('Monetize impact. Protect what matters.'),
        ],
      ),
    );
  }

  Widget _buildPropCheck(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, size: 17, color: EcoColors.mintAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, color: EcoColors.textPrimaryLight, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EcoColors.cardBorder),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: const [
          Text(
            'For Safari Operators. For Conservation. For Communities. For the Future.',
            style: TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight),
          ),
          Text(
            'Zimbabwe. Africa. The World.',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: EcoColors.savannaGold),
          ),
          Text(
            'Let\'s build a legacy that lasts.',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: EcoColors.mintAccent),
          ),
        ],
      ),
    );
  }
}
