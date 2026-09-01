import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/immersive_background_scaffold.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../providers/tourism_providers.dart';

class NationalIntelligenceScreen extends ConsumerWidget {
  const NationalIntelligenceScreen({super.key});

  static const String backgroundUrl =
      'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=1600&q=80';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leakageMetrics = ref.watch(economicLeakageMetricsProvider);

    return ImmersiveBackgroundScaffold(
      imageUrl: backgroundUrl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header & ZTA Banner
            _buildZtaHeader(context),
            const SizedBox(height: 20),

            // Empirical Economic Leakage Index (Nyanga $187 vs $24)
            _buildEconomicLeakageSection(context, leakageMetrics),
            const SizedBox(height: 24),

            // "ZimPulse" AI Predictive Visitor Dispersal & Eco-Perks
            _buildZimPulseDispersalCard(context),
            const SizedBox(height: 24),

            // Provincial Visitor Flow & Capacity Breakdown
            _buildProvincialFlowGrid(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildZtaHeader(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      border: BorderSide(color: EcoColors.savannaGold.withValues(alpha: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: EcoColors.savannaGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.analytics_rounded, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ZIMBABWE TOURISM AUTHORITY (ZTA)',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: EcoColors.savannaGold,
                      ),
                    ),
                    Text(
                      'National Tourism Intelligence & Spatial Flow Layer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: EcoColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              SafariGlowButton(
                text: 'Export National Report',
                icon: Icons.download_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ZTA Q3 National Intelligence Brief downloaded (PDF/CSV)'),
                      backgroundColor: EcoColors.forestDeep,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Live aggregated intelligence synthesizing visitor GPS telemetry, accommodation capacity utilization, and community economic retention across all 10 provinces.',
            style: TextStyle(fontSize: 12.5, color: EcoColors.textSecondaryLight, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildEconomicLeakageSection(BuildContext context, List<dynamic> metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.currency_exchange_rounded, color: EcoColors.mintAccent, size: 18),
            SizedBox(width: 8),
            Text(
              'SYSTEMIC ECONOMIC LEAKAGE & LOCAL RETENTION INDEX',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 3 : 1,
                mainAxisExtent: 260,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: metrics.length,
              itemBuilder: (context, index) {
                final m = metrics[index];
                final retentionPct = m.retentionPercentage.toStringAsFixed(1);
                final isSevere = m.region.contains('Nyanga');

                return GlassCard(
                  border: BorderSide(
                    color: isSevere ? EcoColors.sunsetGlow.withValues(alpha: 0.5) : EcoColors.cardBorder,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              m.region,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isSevere ? EcoColors.sunsetGlow.withValues(alpha: 0.2) : EcoColors.emeraldPrimary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '$retentionPct% Retained',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isSevere ? EcoColors.sunsetGlow : EcoColors.mintAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Metric Numbers
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              'Avg Tourist Spend',
                              'US\$${m.averageDailyTouristSpendUsd.toStringAsFixed(0)}/day',
                              EcoColors.textPrimaryLight,
                            ),
                          ),
                          Expanded(
                            child: _buildMetricTile(
                              'Local Retention',
                              'US\$${m.localResidentRetentionUsd.toStringAsFixed(0)}/day',
                              isSevere ? EcoColors.sunsetGlow : EcoColors.mintAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Leakage Mini Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Row(
                          children: [
                            Flexible(
                              flex: m.localResidentRetentionUsd.toInt(),
                              child: Container(height: 8, color: EcoColors.mintAccent),
                            ),
                            Flexible(
                              flex: m.foreignOtaLeakageUsd.toInt(),
                              child: Container(height: 8, color: Colors.redAccent.withValues(alpha: 0.7)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        'Bottleneck: ${m.keyBottleneck}',
                        style: const TextStyle(fontSize: 11, color: EcoColors.textMuted, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        '💡 Strategy: ${m.interventionStrategy}',
                        style: const TextStyle(fontSize: 11, color: EcoColors.savannaGold, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMetricTile(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10.5, color: EcoColors.textSecondaryLight)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: valueColor)),
      ],
    );
  }

  Widget _buildZimPulseDispersalCard(BuildContext context) {
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
                  color: EcoColors.emeraldPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bolt_rounded, color: EcoColors.mintAccent, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ZIMPULSE PREDICTIVE VISITOR DISPERSAL ENGINE',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: EcoColors.mintAccent),
                    ),
                    Text(
                      'Active Eco-Perks routing tourists away from congested corridors to high-impact rural gems',
                      style: TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildPerkChip('Nyanga Mountain Circuit', '20% Off CAMPFIRE Levy', Icons.eco_rounded, EcoColors.mintAccent),
              _buildPerkChip('Gonarezhou Chilojo Cliffs', 'Free Elder Story Pass', Icons.headset_mic_rounded, EcoColors.savannaGold),
              _buildPerkChip('Matobo Hills Shrines', 'Bonus +200 Carbon Offsets', Icons.verified_rounded, EcoColors.mintAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerkChip(String title, String perk, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Colors.white)),
              Text(perk, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProvincialFlowGrid(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROVINCIAL VISITOR DENSITY & ACCOMMODATION CAPACITY',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: Colors.white),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        const titles = ['Vic Falls', 'Hwange', 'Masvingo', 'Nyanga', 'Matobo', 'Mana Pools'];
                        if (val.toInt() >= 0 && val.toInt() < titles.length) {
                          return Text(titles[val.toInt()], style: const TextStyle(fontSize: 10, color: Colors.white70));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (val, meta) => Text('${val.toInt()}%', style: const TextStyle(fontSize: 9, color: Colors.white38)),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeBar(0, 92, EcoColors.sunsetGlow), // Vic Falls congested
                  _makeBar(1, 74, EcoColors.savannaGold),
                  _makeBar(2, 48, EcoColors.mintAccent),
                  _makeBar(3, 22, EcoColors.emeraldPrimary), // Nyanga under-utilized
                  _makeBar(4, 38, EcoColors.mintAccent),
                  _makeBar(5, 65, EcoColors.savannaGold),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 18,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }
}
