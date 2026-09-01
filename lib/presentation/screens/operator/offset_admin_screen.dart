import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../../core/widgets/animated_progress_bar.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../../domain/models/carbon_offset_project.dart';
import '../../../domain/models/offset_purchase.dart';
import '../../providers/tourism_providers.dart';
import '../guest/offset_checkout_dialog.dart';

class OffsetAdminScreen extends ConsumerStatefulWidget {
  const OffsetAdminScreen({super.key});

  @override
  ConsumerState<OffsetAdminScreen> createState() => _OffsetAdminScreenState();
}

class _OffsetAdminScreenState extends ConsumerState<OffsetAdminScreen> {
  @override
  Widget build(BuildContext context) {
    final offsetProjects = ref.watch(carbonOffsetProjectsProvider);
    final purchases = ref.watch(purchasesProvider);
    final totalTonnesRetired = purchases.fold<double>(0.0, (sum, p) => sum + p.tonnes);
    final totalRevenue = purchases.fold<double>(0.0, (sum, p) => sum + p.amountPaid);
    final totalCampfireDistributed = purchases.fold<double>(0.0, (sum, p) => sum + p.campfireShare);

    return SingleChildScrollView(

      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Carbon Marketplace Admin & ZCR Registry',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: EcoColors.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Direct tourist carbon offset catalog, pricing controls, and CAMPFIRE revenue sharing distribution',
                    style: TextStyle(fontSize: 13, color: EcoColors.textSecondaryLight),
                  ),
                ],
              ),
              EcoBadge(text: 'Zimbabwe Carbon Registry Linked', icon: Icons.verified_rounded),
            ],
          ),
          const SizedBox(height: 20),

          // Overview KPI Summary Banner
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 650;
              if (isSmall) {
                return GlassCard(
                  padding: const EdgeInsets.all(14),
                  backgroundColor: EcoColors.darkCardBg,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                    children: [
                      _buildSummaryStat('Total CO₂ Retired', '${totalTonnesRetired.toStringAsFixed(1)} t', EcoColors.mintAccent),
                      _buildSummaryStat('Gross Offset Sales', '\$${totalRevenue.toStringAsFixed(0)}', EcoColors.savannaGold),
                      _buildSummaryStat('CAMPFIRE Pool', '\$${totalCampfireDistributed.toStringAsFixed(0)}', EcoColors.terracotta),
                      _buildSummaryStat('Operator Margin', '\$${(totalRevenue * 0.15).toStringAsFixed(0)}', EcoColors.emeraldPrimary),
                    ],
                  ),
                );
              }
              return GlassCard(
                padding: const EdgeInsets.all(20),
                backgroundColor: EcoColors.darkCardBg,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: _buildSummaryStat('Total CO₂ Retired', '${totalTonnesRetired.toStringAsFixed(1)} t', EcoColors.mintAccent)),
                    Container(width: 1, height: 40, color: EcoColors.cardBorder),
                    Expanded(child: _buildSummaryStat('Gross Offset Sales', '\$${totalRevenue.toStringAsFixed(2)}', EcoColors.savannaGold)),
                    Container(width: 1, height: 40, color: EcoColors.cardBorder),
                    Expanded(child: _buildSummaryStat('CAMPFIRE Direct Pool', '\$${totalCampfireDistributed.toStringAsFixed(2)}', EcoColors.terracotta)),
                    Container(width: 1, height: 40, color: EcoColors.cardBorder),
                    Expanded(child: _buildSummaryStat('Operator 15% Margin', '\$${(totalRevenue * 0.15).toStringAsFixed(2)}', EcoColors.emeraldPrimary)),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Active Carbon Projects Catalog
          const Text(
            'Active Carbon & Community Offset Projects',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: offsetProjects.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final proj = offsetProjects[index];
              return _buildOffsetProjectCard(proj);
            },
          ),
          const SizedBox(height: 28),

          // Recent Tourist Purchases Ledger
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Tourist Offset Purchases & Certificates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
              ),
              Text('${purchases.length} Total Certificates Issued', style: const TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight)),
            ],
          ),
          const SizedBox(height: 12),
          GlassCard(
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: purchases.length,
              separatorBuilder: (context, index) => const Divider(color: EcoColors.cardBorder, height: 1),
              itemBuilder: (context, idx) {
                final p = purchases[idx];
                return _buildPurchaseRow(p);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildOffsetProjectCard(CarbonOffsetProject proj) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: EcoColors.savannaGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.solar_power_rounded, color: EcoColors.savannaGold, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          proj.name,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                        ),
                        EcoBadge(text: proj.registryId, fontSize: 9.5),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${proj.location} • ${proj.impactNarrative}',
                      style: const TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${proj.pricePerTonne.toStringAsFixed(0)}/t',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: EcoColors.mintAccent),
                  ),
                  Text(
                    '${proj.zimbabweCampfirePct.toInt()}% CAMPFIRE',
                    style: const TextStyle(fontSize: 10, color: EcoColors.savannaGold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                'Capacity: ${proj.remainingCapacity.toStringAsFixed(0)} / ${proj.totalCapacity.toStringAsFixed(0)} t',
                style: const TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight),
              ),
              Text(
                '${(proj.percentFunded * 100).toStringAsFixed(0)}% Claimed',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: EcoColors.mintAccent),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AnimatedProgressIndicator(progress: proj.percentFunded),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SafariGlowButton(
                  text: 'Purchase Offset',
                  icon: Icons.eco_rounded,
                  height: 38,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => OffsetCheckoutDialog(
                        defaultTonnes: 1.5,
                        onPurchaseSuccess: (purchase) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: EcoColors.forestDeep,
                              content: Text(
                                  'Offset purchased for ${proj.name}! Certificate issued.'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SafariGlowButton(
                  text: 'View Registry',
                  icon: Icons.open_in_new_rounded,
                  isSecondary: true,
                  height: 38,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: EcoColors.forestDeep,
                        content:
                            Text('Opening ZCR Registry for ${proj.registryId}...'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseRow(OffsetPurchase p) {
    return InkWell(
      onTap: () => _showCertDetail(p),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: EcoColors.emeraldPrimary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.receipt_long_rounded,
                  color: EcoColors.mintAccent, size: 16),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.touristName,
                      style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: EcoColors.textPrimaryLight)),
                  const SizedBox(height: 2),
                  Text('${p.projectName} • ${p.paymentMethod}',
                      style: const TextStyle(
                          fontSize: 11.5, color: EcoColors.textSecondaryLight)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${p.tonnes} t CO₂ • \$${p.amountPaid.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: EcoColors.mintAccent)),
                const SizedBox(height: 2),
                Text('Cert: ${p.certificateCode}',
                    style: const TextStyle(
                        fontSize: 11,
                        color: EcoColors.savannaGold,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCertDetail(OffsetPurchase p) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: EcoColors.darkCardBg,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: EcoColors.mintAccent.withValues(alpha: 0.4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.workspace_premium_rounded,
                        color: EcoColors.savannaGold, size: 22),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text('ZCR Carbon Certificate',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: EcoColors.textPrimaryLight)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          size: 18, color: EcoColors.textMuted),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(color: EcoColors.cardBorder, height: 20),
                _certRow('Tourist', p.touristName),
                _certRow('Email', p.touristEmail),
                _certRow('Project', p.projectName),
                _certRow('CO₂ Retired', '${p.tonnes} tCO₂e'),
                _certRow('Amount Paid', '\$${p.amountPaid.toStringAsFixed(2)}'),
                _certRow('Payment', p.paymentMethod),
                _certRow('Certificate ID', p.certificateCode),
                _certRow('CAMPFIRE Share', '\$${p.campfireShare.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                SafariGlowButton(
                  text: 'Download PDF Certificate',
                  icon: Icons.download_rounded,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: EcoColors.forestDeep,
                        content: Text(
                            'Certificate ${p.certificateCode} downloaded as PDF!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _certRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 11.5, color: EcoColors.textSecondaryLight)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: EcoColors.mintAccent),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}


class AnimatedProgressIndicator extends StatelessWidget {
  final double progress;
  const AnimatedProgressIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedProgressBar(progress: progress, height: 7);
  }
}
