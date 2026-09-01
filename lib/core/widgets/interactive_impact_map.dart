import 'package:flutter/material.dart';
import '../theme/eco_colors.dart';
import 'eco_badge.dart';

class MapPinData {
  final String id;
  final String title;
  final String category;
  final String region;
  final Offset relativePos; // (0.0 to 1.0) on map canvas
  final IconData icon;
  final Color color;
  final String metric;
  final String verifiedBy;
  final String coordinates;
  final String imageUrl;

  const MapPinData({
    required this.id,
    required this.title,
    required this.category,
    required this.region,
    required this.relativePos,
    required this.icon,
    required this.color,
    required this.metric,
    required this.verifiedBy,
    required this.coordinates,
    required this.imageUrl,
  });
}

class InteractiveImpactMap extends StatefulWidget {
  final double height;
  final bool compact;

  const InteractiveImpactMap({
    super.key,
    this.height = 320,
    this.compact = false,
  });

  @override
  State<InteractiveImpactMap> createState() => _InteractiveImpactMapState();
}

class _InteractiveImpactMapState extends State<InteractiveImpactMap> {
  MapPinData? _selectedPin;
  String _activeFilter = 'All';

  final List<MapPinData> _pins = const [
    MapPinData(
      id: 'pin-1',
      title: 'Hwange Main Ranger Command',
      category: 'Anti-Poaching',
      region: 'Hwange National Park',
      relativePos: Offset(0.28, 0.42),
      icon: Icons.shield_rounded,
      color: EcoColors.mintAccent,
      metric: '18 Active Scouts • 1,420 Patrol Hours',
      verifiedBy: 'Chief Ranger Sibanda',
      coordinates: '18.7322° S, 26.9535° E',
      imageUrl: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=600&q=80',
    ),
    MapPinData(
      id: 'pin-2',
      title: 'Nyaminyami Solar Borehole',
      category: 'Community Projects',
      region: 'Zambezi Buffer Ward 3',
      relativePos: Offset(0.55, 0.28),
      icon: Icons.water_drop_rounded,
      color: EcoColors.savannaGold,
      metric: '4,200 L/hr Clean Water • 400 Households',
      verifiedBy: 'Eng. Ndlovu (CAMPFIRE)',
      coordinates: '18.6189° S, 26.8654° E',
      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=600&q=80',
    ),
    MapPinData(
      id: 'pin-3',
      title: 'Gwayi Teak Reforestation Corridor',
      category: 'Habitat Restoration',
      region: 'Gwayi Forest Reserve',
      relativePos: Offset(0.38, 0.65),
      icon: Icons.park_rounded,
      color: EcoColors.emeraldPrimary,
      metric: '1,540 Native Saplings • 45 Hectares',
      verifiedBy: 'Forest Officer Dube',
      coordinates: '18.8920° S, 27.1240° E',
      imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=600&q=80',
    ),
    MapPinData(
      id: 'pin-4',
      title: 'Mana Pools Solar Microgrid',
      category: 'Carbon Offsets',
      region: 'Mana Pools UNESCO Site',
      relativePos: Offset(0.68, 0.18),
      icon: Icons.solar_power_rounded,
      color: EcoColors.mintAccent,
      metric: '40 kW Clean Solar Array • Zero Diesel',
      verifiedBy: 'ZTA Energy Auditor',
      coordinates: '15.7500° S, 29.3333° E',
      imageUrl: 'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=600&q=80',
    ),
    MapPinData(
      id: 'pin-5',
      title: 'Gonarezhou Elephant Sanctuary',
      category: 'Anti-Poaching',
      region: 'Gonarezhou National Park',
      relativePos: Offset(0.82, 0.78),
      icon: Icons.pets_rounded,
      color: EcoColors.savannaGold,
      metric: 'GPS Collar Tracking • 28 Herds Monitored',
      verifiedBy: 'Dr. van der Merwe',
      coordinates: '21.6667° S, 31.8333° E',
      imageUrl: 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=600&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPins = _activeFilter == 'All'
        ? _pins
        : _pins.where((p) => p.category == _activeFilter).toList();

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xFF0C1914),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EcoColors.cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            if (w <= 0 || h <= 0) return const SizedBox.shrink();

            final showFilters = w > 480;

            return Stack(
              children: [
                // Styled African Topography Canvas
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapCanvasPainter(),
                  ),
                ),

                // Top Bar Controls: Title & Category Filter Pills
                Positioned(
                  top: 10,
                  left: 12,
                  right: 12,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: EcoColors.emeraldPrimary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.satellite_rounded, color: EcoColors.mintAccent, size: 14),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Live Impact Map',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: EcoColors.textPrimaryLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showFilters && !widget.compact)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: ['All', 'Anti-Poaching', 'Community', 'Habitat'].map((f) {
                              final mapCategory = f == 'Community'
                                  ? 'Community Projects'
                                  : f == 'Habitat'
                                      ? 'Habitat Restoration'
                                      : f;
                              final isSel = _activeFilter == mapCategory;
                              return Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: InkWell(
                                  onTap: () => setState(() => _activeFilter = mapCategory),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isSel ? EcoColors.emeraldPrimary : Colors.black.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSel ? EcoColors.mintAccent : EcoColors.cardBorder,
                                      ),
                                    ),
                                    child: Text(
                                      f,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                        color: isSel ? Colors.black : EcoColors.textSecondaryLight,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),

                // Interactive Pins positioned directly in Stack
                ...filteredPins.map((pin) {
                  final maxL = (w - 36) < 0.0 ? 0.0 : (w - 36);
                  final maxT = (h - 40) < 32.0 ? 32.0 : (h - 40);
                  final pinLeft = (w * pin.relativePos.dx - 18).clamp(0.0, maxL);
                  final pinTop = (h * pin.relativePos.dy - 18).clamp(32.0, maxT);

                  return Positioned(
                    left: pinLeft,
                    top: pinTop,
                    child: _buildMapPin(pin),
                  );
                }),

                // Selected Pin Info Card Overlay
                if (_selectedPin != null)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: _buildPinDetailCard(_selectedPin!),
                  ),

                // Bottom Right Map Scale & Status
                Positioned(
                  bottom: 8,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.gps_fixed_rounded, color: EcoColors.mintAccent, size: 10),
                        SizedBox(width: 4),
                        Text(
                          'GNSS Telemetry Synced • 5 Active Zones',
                          style: TextStyle(fontSize: 9.5, color: EcoColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMapPin(MapPinData pin) {
    final isSelected = _selectedPin?.id == pin.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPin = isSelected ? null : pin;
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? 34 : 26,
              height: isSelected ? 34 : 26,
              decoration: BoxDecoration(
                color: pin.color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: pin.color.withValues(alpha: 0.6),
                    blurRadius: isSelected ? 14 : 6,
                    spreadRadius: isSelected ? 2 : 1,
                  ),
                ],
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(pin.icon, color: Colors.black, size: isSelected ? 16 : 13),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: pin.color.withValues(alpha: 0.5)),
              ),
              child: Text(
                pin.title.split(' ').take(2).join(' '),
                style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDetailCard(MapPinData pin) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F251E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: pin.color.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              pin.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                width: 50,
                height: 50,
                color: EcoColors.darkCardBg,
                child: Icon(pin.icon, color: pin.color),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        pin.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: EcoColors.textPrimaryLight,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    EcoBadge(text: pin.category, fontSize: 8.5),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${pin.region} • ${pin.coordinates}',
                  style: const TextStyle(fontSize: 10, color: EcoColors.textSecondaryLight),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  pin.metric,
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: pin.color),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 16, color: EcoColors.textMuted),
            onPressed: () => setState(() => _selectedPin = null),
          ),
        ],
      ),
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0D2119);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Subtle topo grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Zambezi River line
    final riverPaint = Paint()
      ..color = const Color(0xFF1E5B74).withValues(alpha: 0.6)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final riverPath = Path();
    riverPath.moveTo(0, size.height * 0.25);
    riverPath.cubicTo(
      size.width * 0.3,
      size.height * 0.15,
      size.width * 0.6,
      size.height * 0.10,
      size.width,
      size.height * 0.12,
    );
    canvas.drawPath(riverPath, riverPaint);

    // Safari Conservation Buffer Zones (Hwange & Gonarezhou & Mana Pools)
    final zonePaint = Paint()
      ..color = const Color(0xFF1B4D36).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    // Hwange buffer
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.32, size.height * 0.52),
          width: size.width * 0.28,
          height: size.height * 0.45,
        ),
        const Radius.circular(30),
      ),
      zonePaint,
    );

    // Gonarezhou buffer
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.80, size.height * 0.72),
          width: size.width * 0.24,
          height: size.height * 0.35,
        ),
        const Radius.circular(24),
      ),
      zonePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
