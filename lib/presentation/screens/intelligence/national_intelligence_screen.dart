import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/immersive_background_scaffold.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../../domain/models/policy_simulation.dart';
import '../../providers/tourism_providers.dart';

class NationalIntelligenceScreen extends ConsumerStatefulWidget {
  const NationalIntelligenceScreen({super.key});

  static const String backgroundUrl =
      'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=1600&q=80';

  @override
  ConsumerState<NationalIntelligenceScreen> createState() => _NationalIntelligenceScreenState();
}

class _NationalIntelligenceScreenState extends ConsumerState<NationalIntelligenceScreen> {
  late ZtaPolicySimulation _policySim;

  @override
  void initState() {
    super.initState();
    _policySim = ZtaPolicySimulation();
  }

  @override
  Widget build(BuildContext context) {
    final leakageMetrics = ref.watch(economicLeakageMetricsProvider);
    final monthlyPoints = _policySim.generate12MonthProjection();

    return ImmersiveBackgroundScaffold(
      imageUrl: NationalIntelligenceScreen.backgroundUrl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header & ZTA Banner
            _buildZtaHeader(context),
            const SizedBox(height: 20),

            // Interactive ZTA Macro Policy Simulator Sandbox
            _buildPolicySimulatorSandbox(context, monthlyPoints),
            const SizedBox(height: 24),

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
                      'National Tourism Intelligence & Policy Simulation Sandbox',
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
                text: 'Export Simulation PDF',
                icon: Icons.download_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ZTA Macro Economic Policy Brief downloaded (PDF/CSV)'),
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

  Widget _buildPolicySimulatorSandbox(BuildContext context, List<MonthlyProjectionPoint> monthlyPoints) {
    return GlassCard(
      padding: const EdgeInsets.all(22),
      border: BorderSide(color: EcoColors.mintAccent.withValues(alpha: 0.5), width: 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.tune_rounded, color: EcoColors.mintAccent, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'ZTA MACROECONOMIC POLICY SIMULATOR & PREDICTIVE SANDBOX',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: EcoColors.mintAccent),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => setState(() => _policySim.resetToDefaults()),
                child: const Text('Reset Defaults', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Policy Sliders
          Row(
            children: [
              Expanded(
                child: _buildSliderTile(
                  label: 'CAMPFIRE Community Levy',
                  value: _policySim.campfireLevyPct,
                  min: 0,
                  max: 50,
                  unit: '%',
                  onChanged: (v) => setState(() => _policySim.campfireLevyPct = v),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildSliderTile(
                  label: 'Lodge Local Procurement Mandate',
                  value: _policySim.lodgeLocalProcurementQuotaPct,
                  min: 10,
                  max: 80,
                  unit: '%',
                  onChanged: (v) => setState(() => _policySim.lodgeLocalProcurementQuotaPct = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSliderTile(
                  label: 'Foreign OTA Commission Cap',
                  value: _policySim.otaCommissionCapPct,
                  min: 5,
                  max: 30,
                  unit: '%',
                  onChanged: (v) => setState(() => _policySim.otaCommissionCapPct = v),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildSliderTile(
                  label: 'Regional Dispersal Tax Incentive',
                  value: _policySim.dispersalTaxRebateUsd,
                  min: 0,
                  max: 100,
                  unit: 'US\$',
                  onChanged: (v) => setState(() => _policySim.dispersalTaxRebateUsd = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Simulated 12-Month Projections Banner
          Row(
            children: [
              Expanded(
                child: _buildSimResultCard(
                  'Community Inflow',
                  'US\$${_policySim.projectedAnnualCommunityInflowMillions}M',
                  '+${((_policySim.projectedAnnualCommunityInflowMillions / 14.2 - 1) * 100).toStringAsFixed(0)}% vs Base',
                  EcoColors.mintAccent,
                  Icons.payments_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSimResultCard(
                  'Direct Rural Jobs',
                  '${_policySim.projectedDirectRuralJobs.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  'Fair-Wage Employment',
                  EcoColors.savannaGold,
                  Icons.work_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSimResultCard(
                  'Gini Inequality Drop',
                  '-${_policySim.projectedGiniReductionPct}%',
                  'Wealth Retained Locally',
                  EcoColors.mintAccent,
                  Icons.balance_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSimResultCard(
                  'Visitor Dispersal',
                  '+${_policySim.projectedVisitorDispersalShiftPct}%',
                  'Shift to Rural Corridors',
                  Colors.cyanAccent,
                  Icons.explore_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 12-Month Trajectory LineChart
          const Text(
            'PROJECTED 12-MONTH RURAL INFLOW TRAJECTORY (US\$ THOUSANDS / MONTH):',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: Colors.white70),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (v, m) => Text('\$${v.toInt()}k', style: const TextStyle(color: Colors.white30, fontSize: 9)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (v, m) {
                        final idx = v.toInt() - 1;
                        if (idx >= 0 && idx < monthlyPoints.length) {
                          return Text(monthlyPoints[idx].monthName, style: const TextStyle(color: Colors.white54, fontSize: 9));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: monthlyPoints.map((p) => FlSpot(p.monthIndex.toDouble(), p.communityInflowUsd)).toList(),
                    isCurved: true,
                    color: EcoColors.mintAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [EcoColors.mintAccent.withValues(alpha: 0.3), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required Function(double) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w700)),
              Text(
                unit == 'US\$' ? '$unit${value.toInt()}' : '${value.toStringAsFixed(0)}$unit',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: EcoColors.savannaGold),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: EcoColors.emeraldPrimary,
              inactiveTrackColor: Colors.white12,
              thumbColor: EcoColors.mintAccent,
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimResultCard(String title, String mainVal, String subVal, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 10, color: EcoColors.textSecondaryLight), overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(mainVal, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 2),
          Text(subVal, style: const TextStyle(fontSize: 9.5, color: Colors.white38), overflow: TextOverflow.ellipsis),
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
                  _makeBar(0, 92, EcoColors.sunsetGlow),
                  _makeBar(1, 74, EcoColors.savannaGold),
                  _makeBar(2, 48, EcoColors.mintAccent),
                  _makeBar(3, 22, EcoColors.emeraldPrimary),
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
