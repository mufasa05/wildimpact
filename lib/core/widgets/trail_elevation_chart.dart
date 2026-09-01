import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/eco_colors.dart';
import '../../domain/models/trail_elevation_data.dart';

class TrailElevationChart extends StatefulWidget {
  final TrailRouteAnalysis trailAnalysis;
  final Function(MobilityProfile)? onProfileChanged;

  const TrailElevationChart({
    super.key,
    required this.trailAnalysis,
    this.onProfileChanged,
  });

  @override
  State<TrailElevationChart> createState() => _TrailElevationChartState();
}

class _TrailElevationChartState extends State<TrailElevationChart> {
  MobilityProfile _selectedProfile = MobilityProfile.powerWheelchair;

  @override
  Widget build(BuildContext context) {
    final passability = widget.trailAnalysis.calculatePassabilityScore(_selectedProfile);
    final transitMins = widget.trailAnalysis.estimateTransitMinutes(_selectedProfile);
    final isAccessible = passability >= 70;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1E17).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAccessible ? EcoColors.mintAccent.withValues(alpha: 0.4) : EcoColors.sunsetGlow.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Passability Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.trailAnalysis.trailName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  Text(
                    '📍 ${widget.trailAnalysis.location} • ${(widget.trailAnalysis.totalDistanceMeters / 1000).toStringAsFixed(2)} km Total',
                    style: const TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isAccessible ? EcoColors.emeraldPrimary.withValues(alpha: 0.2) : EcoColors.sunsetGlow.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isAccessible ? EcoColors.mintAccent : EcoColors.sunsetGlow),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAccessible ? Icons.verified_rounded : Icons.warning_amber_rounded,
                      color: isAccessible ? EcoColors.mintAccent : EcoColors.sunsetGlow,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${passability.toStringAsFixed(0)}% Passable',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: isAccessible ? EcoColors.mintAccent : EcoColors.sunsetGlow,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mobility Profile Switcher
          const Text(
            'SELECT VISITOR MOBILITY PROFILE:',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: EcoColors.savannaGold),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MobilityProfile.values.map((profile) {
                final isSelected = _selectedProfile == profile;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(profile.label),
                    selected: isSelected,
                    selectedColor: EcoColors.mintAccent,
                    backgroundColor: Colors.black.withValues(alpha: 0.35),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.black : Colors.white70,
                    ),
                    onSelected: (val) {
                      setState(() => _selectedProfile = profile);
                      widget.onProfileChanged?.call(profile);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // Elevation Profile FlChart
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      getTitlesWidget: (val, meta) => Text(
                        '${val.toInt()}m',
                        style: const TextStyle(color: Colors.white38, fontSize: 9),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (val, meta) => Text(
                        '${val.toInt()}m',
                        style: const TextStyle(color: Colors.white38, fontSize: 9),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final point = widget.trailAnalysis.elevationProfile[spot.spotIndex.clamp(0, widget.trailAnalysis.elevationProfile.length - 1)];
                        return LineTooltipItem(
                          '${spot.x.toInt()}m: ${spot.y.toInt()}m Alt\nSlope: ${point.slopePct}%\n${point.surfaceType}',
                          const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: widget.trailAnalysis.elevationProfile.asMap().entries.map((e) {
                      return FlSpot(e.value.distanceMeters, e.value.elevationMeters);
                    }).toList(),
                    isCurved: true,
                    color: isAccessible ? EcoColors.mintAccent : EcoColors.savannaGold,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final point = widget.trailAnalysis.elevationProfile[index];
                        return FlDotCirclePainter(
                          radius: point.isRestStop ? 5 : 3,
                          color: point.isRestStop ? EcoColors.savannaGold : (point.slopePct > _selectedProfile.maxTolerableSlopePct ? Colors.redAccent : EcoColors.mintAccent),
                          strokeWidth: 1.5,
                          strokeColor: Colors.black,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          (isAccessible ? EcoColors.mintAccent : EcoColors.savannaGold).withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Computed Trail Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildStatBadge('Est. Transit', '$transitMins mins', Icons.timer_rounded, EcoColors.mintAccent),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatBadge('Max Incline', '${widget.trailAnalysis.maxSlopePct}%', Icons.trending_up_rounded, widget.trailAnalysis.maxSlopePct > _selectedProfile.maxTolerableSlopePct ? EcoColors.sunsetGlow : EcoColors.mintAccent),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatBadge('Rest Stops', '${widget.trailAnalysis.elevationProfile.where((p) => p.isRestStop).length}', Icons.chair_rounded, EcoColors.savannaGold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 13),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 2),
          Text(val, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}
