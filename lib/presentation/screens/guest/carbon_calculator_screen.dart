import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../../core/widgets/safari_glow_button.dart';
import 'offset_checkout_dialog.dart';

class CarbonCalculatorScreen extends ConsumerStatefulWidget {
  final Function(int)? onNavigateGuestTab;

  const CarbonCalculatorScreen({super.key, this.onNavigateGuestTab});

  @override
  ConsumerState<CarbonCalculatorScreen> createState() => _CarbonCalculatorScreenState();
}

class _CarbonCalculatorScreenState extends ConsumerState<CarbonCalculatorScreen> {
  String _flightOrigin = 'Europe (London / Frankfurt)';
  double _flightTonnes = 1.95;
  int _safariNights = 4;
  String _transportType = '4x4 Game Drive Vehicle';
  double _transportTonnes = 0.25;

  final Map<String, double> _flightOptions = {
    'Europe (London / Frankfurt)': 1.95,
    'North America (New York / Atlanta)': 2.80,
    'Southern Africa (Johannesburg / Gaborone)': 0.35,
    'East Africa (Nairobi / Kigali)': 0.65,
    'Asia-Pacific (Singapore / Sydney)': 3.10,
  };

  final Map<String, double> _transportOptions = {
    '4x4 Game Drive Vehicle': 0.25,
    'Bush Bushplane / Light Aircraft': 0.55,
    'Eco-Hybrid Safari Cruiser': 0.12,
  };

  double get _totalEmissions =>
      _flightTonnes + _transportTonnes + (_safariNights * 0.04);

  double get _recommendedCost => _totalEmissions * 12.50; // $12.50 avg/tonne

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 850;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Safari Trip Carbon Footprint Calculator',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: EcoColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Calculate verified flight, safari cruiser, and lodge emissions based on IPCC & ICAO emission standards',
            style: TextStyle(fontSize: 13, color: EcoColors.textSecondaryLight),
          ),
          const SizedBox(height: 24),

          // Main Layout
          isMobile
              ? Column(
                  children: [
                    _buildCalculatorForm(),
                    const SizedBox(height: 20),
                    _buildResultCard(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildCalculatorForm()),
                    const SizedBox(width: 20),
                    Expanded(flex: 2, child: _buildResultCard()),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildCalculatorForm() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step 1: Flight Route
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.flight_rounded, color: EcoColors.mintAccent, size: 18),
                  SizedBox(width: 8),
                  Text('1. International Flight Route', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight)),
                ],
              ),
              EcoBadge(text: '${_flightTonnes.toStringAsFixed(2)} t CO₂'),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: EcoColors.cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _flightOrigin,
                isExpanded: true,
                dropdownColor: EcoColors.darkCardBg,
                style: const TextStyle(color: EcoColors.textPrimaryLight, fontSize: 13, fontWeight: FontWeight.w600),
                items: _flightOptions.keys.map((k) {
                  return DropdownMenuItem(
                    value: k,
                    child: Text('$k (~${_flightOptions[k]} t)'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _flightOrigin = val;
                      _flightTonnes = _flightOptions[val] ?? 1.95;
                    });
                  }
                },
              ),
            ),
          ),
          const Divider(color: EcoColors.cardBorder, height: 32),

          // Step 2: Ground & Bush Travel
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.directions_car_filled_rounded, color: EcoColors.savannaGold, size: 18),
                  SizedBox(width: 8),
                  Text('2. Safari Transfer & Drives', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight)),
                ],
              ),
              EcoBadge.gold(text: '${_transportTonnes.toStringAsFixed(2)} t CO₂'),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: EcoColors.cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _transportType,
                isExpanded: true,
                dropdownColor: EcoColors.darkCardBg,
                style: const TextStyle(color: EcoColors.textPrimaryLight, fontSize: 13, fontWeight: FontWeight.w600),
                items: _transportOptions.keys.map((k) {
                  return DropdownMenuItem(
                    value: k,
                    child: Text('$k (~${_transportOptions[k]} t)'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _transportType = val;
                      _transportTonnes = _transportOptions[val] ?? 0.25;
                    });
                  }
                },
              ),
            ),
          ),
          const Divider(color: EcoColors.cardBorder, height: 32),

          // Step 3: Nights at Lodge
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.bed_rounded, color: EcoColors.emeraldPrimary, size: 18),
                  SizedBox(width: 8),
                  Text('3. Safari Lodge Stay Duration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight)),
                ],
              ),
              Text(
                '$_safariNights Nights',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: EcoColors.mintAccent),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Slider(
            value: _safariNights.toDouble(),
            min: 1,
            max: 14,
            divisions: 13,
            activeColor: EcoColors.emeraldPrimary,
            inactiveColor: Colors.white.withValues(alpha: 0.1),
            onChanged: (v) => setState(() => _safariNights = v.round()),
          ),
          Text(
            'Lodge runs 85% on solar power. Footprint: ${(_safariNights * 0.04).toStringAsFixed(2)} t CO₂',
            style: const TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      backgroundColor: EcoColors.darkCardBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Trip Footprint Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight)),
              Icon(Icons.pie_chart_rounded, color: EcoColors.mintAccent, size: 20),
            ],
          ),
          const SizedBox(height: 18),

          // Total big callout
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: EcoColors.emeraldGradient.scale(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: EcoColors.emeraldPrimary.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                const Text('Total Estimated Carbon Footprint', style: TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight)),
                const SizedBox(height: 4),
                Text(
                  '${_totalEmissions.toStringAsFixed(2)} Tonnes CO₂',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: EcoColors.mintAccent),
                ),
                const SizedBox(height: 4),
                Text(
                  'Equivalent to: \$${_recommendedCost.toStringAsFixed(2)} in Verified Community Offsets',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: EcoColors.savannaGold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Breakdown lines
          _buildSummaryLine('✈️ Flights', '${_flightTonnes.toStringAsFixed(2)} t', '${((_flightTonnes / _totalEmissions) * 100).toInt()}%'),
          const Divider(color: EcoColors.cardBorder, height: 16),
          _buildSummaryLine('🚗 Safari Transfers', '${_transportTonnes.toStringAsFixed(2)} t', '${((_transportTonnes / _totalEmissions) * 100).toInt()}%'),
          const Divider(color: EcoColors.cardBorder, height: 16),
          _buildSummaryLine('🏨 Stay ($_safariNights nights)', '${(_safariNights * 0.04).toStringAsFixed(2)} t', '${(((_safariNights * 0.04) / _totalEmissions) * 100).toInt()}%'),
          const SizedBox(height: 24),

          SafariGlowButton(
            text: 'Offset Entire Trip (\$${_recommendedCost.toStringAsFixed(2)})',
            icon: Icons.check_circle_outline_rounded,
            width: double.infinity,
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => OffsetCheckoutDialog(
                  defaultTonnes: _totalEmissions,
                  onPurchaseSuccess: (_) => widget.onNavigateGuestTab?.call(2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryLine(String label, String tonnes, String pct) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            Text(tonnes, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight)),
            const SizedBox(width: 6),
            Text('($pct)', style: const TextStyle(fontSize: 10.5, color: EcoColors.textMuted)),
          ],
        ),
      ],
    );
  }
}
