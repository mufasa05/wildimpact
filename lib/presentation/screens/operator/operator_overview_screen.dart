import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/eco_stat_card.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../../core/widgets/interactive_impact_map.dart';
import '../../../domain/models/booking_contribution.dart';
import '../../../domain/models/impact_evidence.dart';
import '../../../domain/models/conservation_project.dart';
import '../../providers/tourism_providers.dart';
import 'add_milestone_dialog.dart';

class OperatorOverviewScreen extends ConsumerStatefulWidget {
  final Function(int)? onNavigateTab;

  const OperatorOverviewScreen({super.key, this.onNavigateTab});

  @override
  ConsumerState<OperatorOverviewScreen> createState() => _OperatorOverviewScreenState();
}

class _OperatorOverviewScreenState extends ConsumerState<OperatorOverviewScreen> {
  String _selectedDateRange = 'May 1 – May 31, 2026';
  int _touchedDonutIndex = -1;

  @override
  Widget build(BuildContext context) {
    final lodge = ref.watch(selectedLodgeProvider);
    final projects = ref.watch(conservationProjectsProvider);
    final contributions = ref.watch(contributionsProvider);
    final evidenceList = ref.watch(impactEvidenceProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 1050;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Platform Banner & Operator Header
          _buildHeaderBar(context, lodge, projects),
          const SizedBox(height: 20),

          // 4 Top KPI Stat Cards
          _buildKpiGrid(),
          const SizedBox(height: 20),

          // Middle Section: Impact Distribution Donut & Recent Contributions
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: _buildImpactDistributionCard()),
                const SizedBox(width: 20),
                Expanded(flex: 5, child: _buildRecentContributionsCard(contributions)),
              ],
            )
          else ...[
            _buildImpactDistributionCard(),
            const SizedBox(height: 20),
            _buildRecentContributionsCard(contributions),
          ],
          const SizedBox(height: 20),

          // Bottom Section: Live Impact Map & Impact Evidence Gallery
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: _buildLiveImpactMapCard()),
                const SizedBox(width: 20),
                Expanded(flex: 4, child: _buildImpactEvidenceCard(evidenceList)),
              ],
            )
          else ...[
            _buildLiveImpactMapCard(),
            const SizedBox(height: 20),
            _buildImpactEvidenceCard(evidenceList),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderBar(BuildContext context, dynamic lodge, List<ConservationProject> projects) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 14,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: EcoColors.emeraldPrimary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: EcoColors.mintAccent.withValues(alpha: 0.5)),
                          ),
                          child: const Text(
                            'OPERATOR DASHBOARD (Web)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: EcoColors.mintAccent,
                            ),
                          ),
                        ),
                        EcoBadge(text: lodge.country, icon: Icons.verified_rounded),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        const Text(
                          'Impact Overview',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: EcoColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          '• ${lodge.name}',
                          style: const TextStyle(fontSize: 13, color: EcoColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Date Picker & Quick Actions
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Date Range Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: EcoColors.cardBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDateRange,
                        icon: const Icon(Icons.arrow_drop_down_rounded, color: EcoColors.mintAccent),
                        dropdownColor: EcoColors.darkCardBg,
                        style: const TextStyle(
                          color: EcoColors.textPrimaryLight,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'May 1 – May 31, 2026', child: Text('May 1 – May 31, 2026')),
                          DropdownMenuItem(value: 'Apr 1 – Apr 30, 2026', child: Text('Apr 1 – Apr 30, 2026')),
                          DropdownMenuItem(value: 'Q2 2026 (Apr - Jun)', child: Text('Q2 2026 (Apr - Jun)')),
                          DropdownMenuItem(value: 'Year-to-Date 2026', child: Text('Year-to-Date 2026')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedDateRange = val);
                          }
                        },
                      ),
                    ),
                  ),

                  // Action button
                  SafariGlowButton(
                    text: 'Log Impact Milestone',
                    icon: Icons.add_rounded,
                    height: 38,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AddMilestoneDialog(projects: projects),
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKpiGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth < 600 ? 1 : constraints.maxWidth < 1100 ? 2 : 4;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 160,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return const EcoStatCard(
                  title: 'Total Bookings',
                  value: '248',
                  subtitle: '100% Eco-Levy Opt-in',
                  icon: Icons.luggage_rounded,
                  iconColor: EcoColors.mintAccent,
                  changePercent: '+12%',
                  isPositive: true,
                );
              case 1:
                return const EcoStatCard(
                  title: 'Conservation Funded',
                  value: '\$12,540',
                  subtitle: 'Distributed to 3 Pillars',
                  icon: Icons.shield_rounded,
                  iconColor: EcoColors.savannaGold,
                  changePercent: '+18%',
                  isPositive: true,
                );
              case 2:
                return const EcoStatCard(
                  title: 'CO₂ Offset',
                  value: '8.7 tCO₂e',
                  subtitle: 'Verified ZCR Native Teak',
                  icon: Icons.cloud_done_rounded,
                  iconColor: EcoColors.emeraldPrimary,
                  changePercent: '+15%',
                  isPositive: true,
                );
              case 3:
              default:
                return const EcoStatCard(
                  title: 'Communities Impacted',
                  value: '5',
                  subtitle: 'CAMPFIRE Wards Supported',
                  icon: Icons.groups_rounded,
                  iconColor: EcoColors.terracotta,
                  changePercent: '+25%',
                  isPositive: true,
                );
            }
          },
        );
      },
    );
  }

  Widget _buildImpactDistributionCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Impact Distribution',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: EcoColors.textPrimaryLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              EcoBadge(text: 'May 2026 Audit', fontSize: 10.5),
            ],
          ),
          const SizedBox(height: 20),

          // Donut Chart & Legend
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            runSpacing: 16,
            children: [
              // Pie Chart
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                _touchedDonutIndex = -1;
                                return;
                              }
                              _touchedDonutIndex =
                                  pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 3,
                        centerSpaceRadius: 38,
                        sections: [
                          PieChartSectionData(
                            color: const Color(0xFF10B981),
                            value: 45,
                            title: '45%',
                            radius: _touchedDonutIndex == 0 ? 26 : 20,
                            titleStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: const Color(0xFFD4A373),
                            value: 30,
                            title: '30%',
                            radius: _touchedDonutIndex == 1 ? 26 : 20,
                            titleStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          PieChartSectionData(
                            color: const Color(0xFF34D399),
                            value: 25,
                            title: '25%',
                            radius: _touchedDonutIndex == 2 ? 26 : 20,
                            titleStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('\$12.5k', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                        Text('Total', style: TextStyle(fontSize: 9, color: EcoColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),

              // Legend
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendRow(
                    color: const Color(0xFF10B981),
                    title: 'Anti-Poaching',
                    percent: '45%',
                    amount: '\$5,643',
                  ),
                  const SizedBox(height: 10),
                  _buildLegendRow(
                    color: const Color(0xFFD4A373),
                    title: 'Community Projects',
                    percent: '30%',
                    amount: '\$3,762',
                  ),
                  const SizedBox(height: 10),
                  _buildLegendRow(
                    color: const Color(0xFF34D399),
                    title: 'Habitat Restoration',
                    percent: '25%',
                    amount: '\$3,135',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(Icons.check_circle_outline_rounded, color: EcoColors.mintAccent, size: 14),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '100% of eco-contributions verified via smart contracts & CAMPFIRE ledger.',
                    style: TextStyle(fontSize: 10.5, color: EcoColors.textSecondaryLight),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow({
    required Color color,
    required String title,
    required String percent,
    required String amount,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: EcoColors.textPrimaryLight),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            percent,
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
          ),
          const SizedBox(width: 4),
          Text(
            '($amount)',
            style: const TextStyle(fontSize: 10.5, color: EcoColors.textSecondaryLight),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentContributionsCard(List<BookingContribution> contributions) {
    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Recent Contributions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: EcoColors.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text('Direct guest eco-impact payments', style: TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.open_in_new_rounded, size: 18, color: EcoColors.mintAccent),
                tooltip: 'Open Full Contributions Ledger',
                onPressed: () => widget.onNavigateTab?.call(3), // Go to Contributions tab
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Table / List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: contributions.take(4).length,
            separatorBuilder: (context, index) => const Divider(color: EcoColors.cardBorder, height: 14),
            itemBuilder: (context, idx) {
              final item = contributions[idx];
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: EcoColors.emeraldPrimary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      item.allocationCategory == 'Anti-Poaching'
                          ? Icons.shield_rounded
                          : item.allocationCategory == 'Community Projects'
                              ? Icons.water_drop_rounded
                              : Icons.park_rounded,
                      color: item.allocationCategory == 'Anti-Poaching'
                          ? EcoColors.mintAccent
                          : item.allocationCategory == 'Community Projects'
                              ? EcoColors.savannaGold
                              : EcoColors.emeraldPrimary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.tourName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: EcoColors.textPrimaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.guestName} • ${item.allocationCategory}',
                          style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${item.amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: EcoColors.mintAccent,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.date,
                        style: const TextStyle(fontSize: 10.5, color: EcoColors.textMuted),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLiveImpactMapCard() {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Impact Map',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: EcoColors.textPrimaryLight,
                ),
              ),
              TextButton.icon(
                onPressed: () => widget.onNavigateTab?.call(2), // go to Radar
                icon: const Icon(Icons.radar_rounded, size: 16, color: EcoColors.mintAccent),
                label: const Text('Open Radar', style: TextStyle(color: EcoColors.mintAccent, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const InteractiveImpactMap(height: 260),
        ],
      ),
    );
  }

  Widget _buildImpactEvidenceCard(List<ImpactEvidence> evidenceList) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Impact Evidence',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: EcoColors.textPrimaryLight,
                ),
              ),
              EcoBadge(text: 'Geo-Tagged', icon: Icons.camera_alt_rounded, fontSize: 10.5),
            ],
          ),
          const SizedBox(height: 12),

          // Photo Gallery Thumbnails
          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = constraints.maxWidth < 450 ? 1 : 3;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: crossCount == 1 ? 165 : 155,
                ),
                itemCount: evidenceList.take(3).length,
                itemBuilder: (context, index) {
                  final ev = evidenceList[index];
                  return _buildEvidenceItem(context, ev);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceItem(BuildContext context, ImpactEvidence ev) {
    return InkWell(
      onTap: () => _showEvidenceModal(context, ev),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: EcoColors.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    ev.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: EcoColors.darkCardBg,
                      child: const Icon(Icons.nature_people_rounded, color: EcoColors.mintAccent),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ev.category.split(' ').first,
                        style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: EcoColors.mintAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ev.date,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    ev.title,
                    style: const TextStyle(fontSize: 9, color: EcoColors.textSecondaryLight),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEvidenceModal(BuildContext context, ImpactEvidence ev) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F241D),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: EcoColors.emeraldPrimary.withValues(alpha: 0.5), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.8),
                  blurRadius: 28,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo Header
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Stack(
                    children: [
                      Image.network(
                        ev.imageUrl,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white),
                          style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.6)),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.gps_fixed_rounded, color: EcoColors.mintAccent, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                '${ev.latitude.toStringAsFixed(4)}°, ${ev.longitude.toStringAsFixed(4)}°',
                                style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Details
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          EcoBadge(text: ev.category, icon: Icons.verified_user_rounded),
                          Text(ev.date, style: const TextStyle(color: EcoColors.savannaGold, fontWeight: FontWeight.w700, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        ev.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: EcoColors.textPrimaryLight),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ev.description,
                        style: const TextStyle(fontSize: 13, color: EcoColors.textSecondaryLight, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: EcoColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified_rounded, color: EcoColors.mintAccent, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Verified by: ${ev.verifiedBy}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight)),
                                  Text('Registry Hash: ${ev.registryRef}', style: const TextStyle(fontSize: 10.5, color: EcoColors.textMuted)),
                                ],
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
          ),
        ),
      ),
    );
  }
}
