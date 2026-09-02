import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/immersive_background_scaffold.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../../domain/models/trip_itinerary.dart';

class TripPlannerScreen extends ConsumerStatefulWidget {
  const TripPlannerScreen({super.key});

  static const String backgroundUrl =
      'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=1600&q=80';

  @override
  ConsumerState<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends ConsumerState<TripPlannerScreen> {
  late TripItinerary _itinerary;

  @override
  void initState() {
    super.initState();
    _itinerary = TripItinerary.createDefault();
  }

  void _addNewLeg() {
    setState(() {
      final legCount = _itinerary.legs.length + 1;
      _itinerary.legs.add(
        ItineraryLeg(
          id: 'leg-$legCount',
          origin: _itinerary.legs.isNotEmpty ? _itinerary.legs.last.destination : 'Harare',
          destination: 'Victoria Falls Rainforest Sanctuary',
          distanceKm: 420.0,
          transportMode: TransportMode.solarEv,
          accommodation: AccommodationType.campfireCommunityLodge,
          nights: 2,
          includeCommunityGuide: true,
          includeElderStorytellingPass: true,
        ),
      );
    });
  }

  void _removeLeg(int index) {
    if (_itinerary.legs.length > 1) {
      setState(() {
        _itinerary.legs.removeAt(index);
      });
    }
  }

  void _optimizeItinerary() {
    setState(() {
      _itinerary.optimizeForZeroLeakageAndCarbon();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✨ Itinerary optimized! Replaced high-leakage OTAs with CAMPFIRE lodges and solar transport.'),
        backgroundColor: EcoColors.forestDeep,
      ),
    );
  }

  void _checkoutAndBook() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🎉 Trip itinerary confirmed! US\$${_itinerary.totalLocalRetentionUsd.toStringAsFixed(0)} allocated directly to rural conservancy trusts.',
        ),
        backgroundColor: EcoColors.forestDeep,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final retentionPct = _itinerary.overallRetentionPercentage.toStringAsFixed(1);
    final totalCost = _itinerary.totalCostUsd.toStringAsFixed(0);
    final localRetained = _itinerary.totalLocalRetentionUsd.toStringAsFixed(0);
    final foreignLeakage = _itinerary.totalForeignLeakageUsd.toStringAsFixed(0);
    final emissions = _itinerary.totalEmissionsTonnes.toStringAsFixed(2);

    return ImmersiveBackgroundScaffold(
      imageUrl: TripPlannerScreen.backgroundUrl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header & Optimizer Banner
            _buildHeader(context),
            const SizedBox(height: 20),

            // Real-Time Dynamic Impact & Leakage Dashboard
            _buildLiveMetricsDashboard(
              retentionPct: retentionPct,
              totalCost: totalCost,
              localRetained: localRetained,
              foreignLeakage: foreignLeakage,
              emissions: emissions,
            ),
            const SizedBox(height: 24),

            // Itinerary Legs Builder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CUSTOMIZE ITINERARY LEGS & CONSERVATION TIERS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: Colors.white),
                ),
                TextButton.icon(
                  onPressed: _addNewLeg,
                  icon: const Icon(Icons.add_location_alt_rounded, color: EcoColors.mintAccent, size: 16),
                  label: const Text('Add Route Leg', style: TextStyle(color: EcoColors.mintAccent, fontSize: 12, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ..._itinerary.legs.asMap().entries.map((entry) {
              final idx = entry.key;
              final leg = entry.value;
              return _buildLegCard(idx, leg);
            }),
            const SizedBox(height: 24),

            // Checkout & Carbon Offset Action Bar
            _buildCheckoutBar(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                child: const Icon(Icons.alt_route_rounded, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INTERACTIVE JOURNEY BUDGET & LEAKAGE OPTIMIZER',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: EcoColors.savannaGold,
                      ),
                    ),
                    Text(
                      'Zero-Leakage Zimbabwe Expedition Planner',
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
                text: '1-Click Zero Leakage Optimize',
                icon: Icons.auto_fix_high_rounded,
                onPressed: _optimizeItinerary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Configure your safari corridors, transport propulsion, and accommodation tier. The live physics engine calculates your carbon footprint while the empirical financial engine routes your dollars directly to rural host communities.',
            style: TextStyle(fontSize: 12.5, color: EcoColors.textSecondaryLight, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMetricsDashboard({
    required String retentionPct,
    required String totalCost,
    required String localRetained,
    required String foreignLeakage,
    required String emissions,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      border: BorderSide(color: EcoColors.mintAccent.withValues(alpha: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'LIVE FINANCIAL & EMISSION BUDGET',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: EcoColors.mintAccent),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: EcoColors.emeraldPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: EcoColors.mintAccent),
                ),
                child: Text(
                  '$retentionPct% Local Retention',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: EcoColors.mintAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile('Total Trip Budget', 'US\$$totalCost', Colors.white, Icons.attach_money_rounded),
              ),
              Expanded(
                child: _buildMetricTile('Local Community Funds', 'US\$$localRetained', EcoColors.mintAccent, Icons.volunteer_activism_rounded),
              ),
              Expanded(
                child: _buildMetricTile('Foreign OTA Leakage', 'US\$$foreignLeakage', EcoColors.sunsetGlow, Icons.money_off_rounded),
              ),
              Expanded(
                child: _buildMetricTile('Carbon Footprint', '$emissions tCO2e', EcoColors.savannaGold, Icons.cloud_outlined),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Visual Retention Ratio Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                Flexible(
                  flex: _itinerary.totalLocalRetentionUsd.toInt().clamp(1, 999999),
                  child: Container(
                    height: 10,
                    color: EcoColors.mintAccent,
                  ),
                ),
                Flexible(
                  flex: _itinerary.totalForeignLeakageUsd.toInt().clamp(1, 999999),
                  child: Container(
                    height: 10,
                    color: EcoColors.sunsetGlow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 10, color: EcoColors.textSecondaryLight)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildLegCard(int index, ItineraryLeg leg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leg Top Line
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: EcoColors.forestDeep, borderRadius: BorderRadius.circular(6)),
                      child: Text('LEG ${index + 1}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: EcoColors.mintAccent)),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${leg.origin}  ➔  ${leg.destination}',
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ],
                ),
                if (_itinerary.legs.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.white38, size: 18),
                    onPressed: () => _removeLeg(index),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            // Controls (Transport, Accommodation, Nights)
            Row(
              children: [
                // Transport Mode
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Transport Mode', style: TextStyle(fontSize: 10.5, color: Colors.white70, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<TransportMode>(
                            value: leg.transportMode,
                            dropdownColor: const Color(0xFF0C1B15),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            isExpanded: true,
                            items: TransportMode.values.map((t) {
                              return DropdownMenuItem(value: t, child: Text(t.label, overflow: TextOverflow.ellipsis));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => leg.transportMode = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Accommodation
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Accommodation Tier', style: TextStyle(fontSize: 10.5, color: Colors.white70, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<AccommodationType>(
                            value: leg.accommodation,
                            dropdownColor: const Color(0xFF0C1B15),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            isExpanded: true,
                            items: AccommodationType.values.map((a) {
                              return DropdownMenuItem(value: a, child: Text(a.label, overflow: TextOverflow.ellipsis));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => leg.accommodation = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Nights
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nights', style: TextStyle(fontSize: 10.5, color: Colors.white70, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.white54, size: 20),
                          onPressed: () {
                            if (leg.nights > 1) setState(() => leg.nights--);
                          },
                        ),
                        Text('${leg.nights}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: EcoColors.mintAccent, size: 20),
                          onPressed: () => setState(() => leg.nights++),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Community Inclusions Checkboxes
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    value: leg.includeCommunityGuide,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    activeColor: EcoColors.emeraldPrimary,
                    title: const Text('Local Community Guide (+US\$35/day)', style: TextStyle(fontSize: 11.5, color: Colors.white)),
                    onChanged: (v) => setState(() => leg.includeCommunityGuide = v ?? true),
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    value: leg.includeElderStorytellingPass,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    activeColor: EcoColors.emeraldPrimary,
                    title: const Text('Elder Oral Audio Pass (+US\$15)', style: TextStyle(fontSize: 11.5, color: Colors.white)),
                    onChanged: (v) => setState(() => leg.includeElderStorytellingPass = v ?? true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      border: BorderSide(color: EcoColors.mintAccent.withValues(alpha: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Carbon Offset Included: US\$${_itinerary.carbonOffsetCostUsd.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: EcoColors.savannaGold),
              ),
              const Text(
                'Includes verified Zimbabwe CAMPFIRE registry certificate',
                style: TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight),
              ),
            ],
          ),
          SafariGlowButton(
            text: 'Confirm & Lock Carbon Neutral Itinerary',
            icon: Icons.check_circle_rounded,
            onPressed: _checkoutAndBook,
          ),
        ],
      ),
    );
  }
}
