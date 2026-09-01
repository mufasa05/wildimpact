import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/eco_stat_card.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../providers/tourism_providers.dart';

class ContributionsLedgerScreen extends ConsumerWidget {
  const ContributionsLedgerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contributions = ref.watch(contributionsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14,
            runSpacing: 10,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Contributions & Fund Allocations',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: EcoColors.textPrimaryLight),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Transparent Smart-Contract Split: 45% Anti-Poaching • 30% CAMPFIRE Community • 25% Habitat Restoration',
                    style: TextStyle(fontSize: 13, color: EcoColors.textSecondaryLight),
                  ),
                ],
              ),
              SafariGlowButton(
                text: 'Export Audit Ledger',
                icon: Icons.download_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: EcoColors.forestDeep,
                      content: Text(
                          'ZTA/CAMPFIRE Audit Ledger exported as CSV & PDF. Check your downloads.'),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3 Fund Allocation Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = constraints.maxWidth < 700 ? 1 : 3;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 160,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const EcoStatCard(
                        title: 'Anti-Poaching (45%)',
                        value: '\$5,643',
                        subtitle: 'Ranger Salaries, K9, Thermal Gear',
                        icon: Icons.shield_rounded,
                        iconColor: EcoColors.mintAccent,
                        changePercent: '18 Active Scouts',
                        isPositive: true,
                      );
                    case 1:
                      return const EcoStatCard(
                        title: 'Community Projects (30%)',
                        value: '\$3,762',
                        subtitle: 'Solar Boreholes, Clinics, Education',
                        icon: Icons.water_drop_rounded,
                        iconColor: EcoColors.savannaGold,
                        changePercent: '5 Wards Funded',
                        isPositive: true,
                      );
                    case 2:
                    default:
                      return const EcoStatCard(
                        title: 'Habitat Restoration (25%)',
                        value: '\$3,135',
                        subtitle: 'Hardwood Teak & Corridor Rewilding',
                        icon: Icons.park_rounded,
                        iconColor: EcoColors.emeraldPrimary,
                        changePercent: '1,540 Trees',
                        isPositive: true,
                      );
                  }
                },
              );
            },
          ),
          const SizedBox(height: 24),

          // Full Verification Table
          GlassCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text(
                        'Live Contributions Ledger',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: EcoColors.textPrimaryLight),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    EcoBadge(
                        text: 'On-Chain Verified',
                        icon: Icons.lock_outline_rounded),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contributions.length,
                  separatorBuilder: (ctx, i) =>
                      const Divider(color: EcoColors.cardBorder, height: 16),
                  itemBuilder: (ctx, index) {
                    final item = contributions[index];
                    return InkWell(
                      onTap: () => _showContributionDetail(context, item),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: EcoColors.emeraldPrimary
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.receipt_long_rounded,
                                  color: EcoColors.mintAccent, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.tourName,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: EcoColors.textPrimaryLight),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.guestName} • ${item.allocationCategory} • ${item.date}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: EcoColors.textSecondaryLight),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '\$${item.amount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: EcoColors.mintAccent),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContributionDetail(BuildContext context, dynamic item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: EcoColors.darkCardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: EcoColors.mintAccent.withValues(alpha: 0.4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long_rounded,
                        color: EcoColors.mintAccent, size: 20),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text('Contribution Detail',
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
                _detailRow('Tour', item.tourName as String),
                _detailRow('Lead Guest', item.guestName as String),
                _detailRow('Fund Pillar', item.allocationCategory as String),
                _detailRow('Date', item.date as String),
                _detailRow('Amount', '\$${(item.amount as double).toStringAsFixed(2)}'),
                _detailRow('CO₂ Offset', '${(item.co2OffsetTonnes as double).toStringAsFixed(2)} tCO₂e'),
                _detailRow('Verification', 'On-Chain • ZCR Registry'),
                const SizedBox(height: 16),
                SafariGlowButton(
                  text: 'Download Receipt',
                  icon: Icons.download_rounded,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: EcoColors.forestDeep,
                        content: Text(
                            'Receipt for ${item.tourName} downloaded!'),
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
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
