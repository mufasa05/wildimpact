import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../../domain/models/geospatial_data.dart';
import '../../providers/tourism_providers.dart';

// ─── Map Style Enum ──────────────────────────────────────────────────────────

enum _MapStyle { dark, satellite, terrain }

extension _MapStyleExt on _MapStyle {
  String get label =>
      this == _MapStyle.dark ? 'Dark' : this == _MapStyle.satellite ? 'Satellite' : 'Terrain';

  IconData get icon =>
      this == _MapStyle.dark
          ? Icons.nightlight_round
          : this == _MapStyle.satellite
              ? Icons.satellite_alt_rounded
              : Icons.terrain_rounded;

  String get tileUrl {
    switch (this) {
      case _MapStyle.satellite:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case _MapStyle.terrain:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}';
      case _MapStyle.dark:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Dark_Gray_Base/MapServer/tile/{z}/{y}/{x}';
    }
  }

  List<String>? get subdomains => null;
}

// ─── Geospatial Radar Screen ─────────────────────────────────────────────────

class GeospatialRadarScreen extends ConsumerStatefulWidget {
  const GeospatialRadarScreen({super.key});

  @override
  ConsumerState<GeospatialRadarScreen> createState() => _GeospatialRadarScreenState();
}

class _GeospatialRadarScreenState extends ConsumerState<GeospatialRadarScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  // Persist tile provider outside build() to avoid per-rebuild HTTP client recreation
  final _tileProvider = NetworkTileProvider();

  // Layer toggles
  bool _showRangers = true;
  bool _showWildlife = true;
  bool _showPatrolCorridor = true;
  bool _showBufferZone = true;
  bool _showNdviZones = true;
  bool _showDeforestAlerts = true;

  // Map state
  _MapStyle _mapStyle = _MapStyle.dark;
  String? _selectedMarkerId;
  LatLng _mapCenter = const LatLng(-18.7322, 26.9535);
  double _mapZoom = 11.5;

  // Animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const LatLng _hwangeCenter = LatLng(-18.7322, 26.9535);

  // NDVI zone polygons — simulated vegetation health areas
  static final List<_NdviZone> _ndviZones = [
    _NdviZone(
      label: 'High NDVI (0.72)',
      color: const Color(0xFF00E676),
      points: [
        LatLng(-18.710, 26.920),
        LatLng(-18.710, 26.960),
        LatLng(-18.740, 26.965),
        LatLng(-18.745, 26.925),
      ],
    ),
    _NdviZone(
      label: 'Medium NDVI (0.51)',
      color: const Color(0xFFFFD600),
      points: [
        LatLng(-18.745, 26.925),
        LatLng(-18.745, 26.975),
        LatLng(-18.775, 26.980),
        LatLng(-18.770, 26.920),
      ],
    ),
    _NdviZone(
      label: 'Low NDVI (0.28)',
      color: const Color(0xFFFF6D00),
      points: [
        LatLng(-18.770, 26.900),
        LatLng(-18.770, 26.935),
        LatLng(-18.800, 26.940),
        LatLng(-18.795, 26.895),
      ],
    ),
    _NdviZone(
      label: 'Deforest Alert',
      color: const Color(0xFFD50000),
      points: [
        LatLng(-18.755, 26.985),
        LatLng(-18.755, 27.005),
        LatLng(-18.775, 27.005),
        LatLng(-18.775, 26.985),
      ],
    ),
  ];

  // Patrol corridor waypoints
  static const List<LatLng> _patrolCorridor = [
    LatLng(-18.7322, 26.9535),
    LatLng(-18.7380, 26.9590),
    LatLng(-18.7450, 26.9650),
    LatLng(-18.7520, 26.9700),
    LatLng(-18.7610, 26.9750),
    LatLng(-18.7680, 26.9800),
  ];

  // Simulated deforestation alert points
  static const List<LatLng> _deforestAlerts = [
    LatLng(-18.763, 26.995),
    LatLng(-18.766, 26.998),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.35).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rangers = ref.watch(rangerTelemetryProvider);
    final sightings = ref.watch(wildlifeSightingsProvider);
    final satellite = ref.watch(satelliteHealthProvider);
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ───────────────────────────────────────────────────
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Geospatial Intelligence Centre',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: EcoColors.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Live GNSS telemetry • Sentinel-2 NDVI • Satellite Imagery',
                    style: TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStatusDot(EcoColors.mintAccent, '${rangers.length} Rangers'),
                  const SizedBox(width: 12),
                  _buildStatusDot(EcoColors.savannaGold, '${sightings.length} Sightings'),
                  const SizedBox(width: 12),
                  EcoBadge(text: 'GNSS Live', icon: Icons.radar_rounded),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ─── Main Body ────────────────────────────────────────────────
          Expanded(
            child: isMobile
                ? Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildMapWidget(rangers, sightings),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        flex: 2,
                        child: _buildTelemetrySidebar(rangers, sightings, satellite),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildMapWidget(rangers, sightings),
                      ),
                      const SizedBox(width: 18),
                      SizedBox(
                        width: 360,
                        child: _buildTelemetrySidebar(rangers, sightings, satellite),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // ─── Map Widget ────────────────────────────────────────────────────────────

  Widget _buildMapWidget(List<RangerTelemetry> rangers, List<WildlifeSighting> sightings) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _hwangeCenter,
                initialZoom: _mapZoom,
                minZoom: 7.0,
                maxZoom: 18.0,
                onPositionChanged: (pos, _) {
                  setState(() {
                    _mapCenter = pos.center;
                    _mapZoom = pos.zoom;
                  });
                },
              ),
              children: [
                // ── Base Tile Layer ──
                TileLayer(
                  urlTemplate: _mapStyle.tileUrl,
                  subdomains: _mapStyle.subdomains ?? const ['a'],
                  userAgentPackageName: 'com.wildimpact.app',
                  tileProvider: _tileProvider,
                  errorTileCallback: (tile, error, stackTrace) {},
                ),

                // ── NDVI Polygon Heatmap ──
                if (_showNdviZones)
                  PolygonLayer(
                    polygons: _ndviZones
                        .where((z) => _showDeforestAlerts || z.label != 'Deforest Alert')
                        .map(
                          (z) => Polygon(
                            points: z.points,
                            color: z.color.withValues(alpha: 0.22),
                            borderColor: z.color.withValues(alpha: 0.75),
                            borderStrokeWidth: 1.5,
                          ),
                        )
                        .toList(),
                  ),

                // ── Deforestation Alert Markers ──
                if (_showDeforestAlerts)
                  MarkerLayer(
                    markers: _deforestAlerts.map((pt) {
                      return Marker(
                        point: pt,
                        width: 32,
                        height: 32,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFD50000).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD50000), width: 1.5),
                          ),
                          child: const Icon(Icons.warning_amber_rounded,
                              color: Color(0xFFD50000), size: 16),
                        ),
                      );
                    }).toList(),
                  ),

                // ── Protected Buffer Zone Circle ──
                if (_showBufferZone)
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: _hwangeCenter,
                        radius: 2500,
                        useRadiusInMeter: true,
                        color: EcoColors.emeraldPrimary.withValues(alpha: 0.08),
                        borderColor: EcoColors.mintAccent.withValues(alpha: 0.55),
                        borderStrokeWidth: 2.0,
                      ),
                      CircleMarker(
                        point: _hwangeCenter,
                        radius: 4800,
                        useRadiusInMeter: true,
                        color: Colors.transparent,
                        borderColor: EcoColors.emeraldPrimary.withValues(alpha: 0.25),
                        borderStrokeWidth: 1.0,
                      ),
                    ],
                  ),

                // ── Patrol Corridor Polyline ──
                if (_showPatrolCorridor)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _patrolCorridor,
                        strokeWidth: 3.0,
                        color: EcoColors.emeraldPrimary,
                        borderStrokeWidth: 1.5,
                        borderColor: Colors.black.withValues(alpha: 0.6),
                      ),
                      // Waypoint dots
                      Polyline(
                        points: _patrolCorridor,
                        strokeWidth: 6.0,
                        color: Colors.transparent,
                      ),
                    ],
                  ),

                // ── Animated Ranger Markers ──
                if (_showRangers)
                  MarkerLayer(
                    markers: rangers.map((r) {
                      final isSelected = _selectedMarkerId == r.id;
                      return Marker(
                        point: LatLng(r.latitude, r.longitude),
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedMarkerId = r.id);
                            _mapController.move(
                              LatLng(r.latitude, r.longitude),
                              14.0,
                            );
                            _showRangerSheet(r);
                          },
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer pulse ring
                                  Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: EcoColors.mintAccent.withValues(
                                              alpha: (1.35 - _pulseAnimation.value) * 0.9),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Inner beacon
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? EcoColors.mintAccent
                                          : EcoColors.emeraldPrimary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black, width: 1.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: EcoColors.mintAccent.withValues(alpha: 0.5),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.shield_rounded,
                                        color: Colors.black, size: 16),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                // ── Wildlife Sighting Markers ──
                if (_showWildlife)
                  MarkerLayer(
                    markers: sightings.map((w) {
                      final isSelected = _selectedMarkerId == w.id;
                      final speciesColor = _speciesColor(w.species);
                      return Marker(
                        point: LatLng(w.latitude, w.longitude),
                        width: 70,
                        height: 70,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedMarkerId = w.id);
                            _mapController.move(LatLng(w.latitude, w.longitude), 14.0);
                            _showWildlifeSheet(w);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: speciesColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.white : Colors.black,
                                    width: isSelected ? 2 : 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: speciesColor.withValues(alpha: 0.5),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _speciesIcon(w.species),
                                  color: Colors.black,
                                  size: 14,
                                ),
                              ),
                              // Count badge
                              if (w.count > 1)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: speciesColor, width: 1),
                                    ),
                                    child: Text(
                                      '${w.count}',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: speciesColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),

            // ─── Map Style Switcher (Top Centre) ──────────────────────
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: EcoColors.darkCardBg.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: EcoColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _MapStyle.values.map((style) {
                      final isActive = _mapStyle == style;
                      return GestureDetector(
                        onTap: () => setState(() => _mapStyle = style),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isActive
                                ? EcoColors.emeraldPrimary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                style.icon,
                                size: 12,
                                color: isActive
                                    ? Colors.black
                                    : EcoColors.textSecondaryLight,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                style.label,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: isActive
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isActive
                                      ? Colors.black
                                      : EcoColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // ─── Layer Toggles (Top Left) ──────────────────────────────
            Positioned(
              top: 54,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLayerToggle(Icons.shield_rounded, 'Rangers',
                      EcoColors.mintAccent, _showRangers,
                      (v) => setState(() => _showRangers = v)),
                  const SizedBox(height: 4),
                  _buildLayerToggle(Icons.pets_rounded, 'Wildlife',
                      EcoColors.savannaGold, _showWildlife,
                      (v) => setState(() => _showWildlife = v)),
                  const SizedBox(height: 4),
                  _buildLayerToggle(Icons.route_rounded, 'Patrol',
                      EcoColors.emeraldPrimary, _showPatrolCorridor,
                      (v) => setState(() => _showPatrolCorridor = v)),
                  const SizedBox(height: 4),
                  _buildLayerToggle(Icons.grain_rounded, 'NDVI Zones',
                      const Color(0xFF00E676), _showNdviZones,
                      (v) => setState(() => _showNdviZones = v)),
                  const SizedBox(height: 4),
                  _buildLayerToggle(Icons.warning_amber_rounded, 'Deforest',
                      const Color(0xFFD50000), _showDeforestAlerts,
                      (v) => setState(() => _showDeforestAlerts = v)),
                  const SizedBox(height: 4),
                  _buildLayerToggle(Icons.radio_button_unchecked, 'Buffer Zone',
                      EcoColors.mintAccent, _showBufferZone,
                      (v) => setState(() => _showBufferZone = v)),
                ],
              ),
            ),

            // ─── Zoom Controls (Right) ─────────────────────────────────
            Positioned(
              right: 12,
              bottom: 60,
              child: Column(
                children: [
                  _buildMapButton(Icons.add, () {
                    _mapController.move(_mapCenter, math.min(_mapZoom + 1, 18));
                  }),
                  const SizedBox(height: 4),
                  _buildMapButton(Icons.remove, () {
                    _mapController.move(_mapCenter, math.max(_mapZoom - 1, 7));
                  }),
                  const SizedBox(height: 8),
                  _buildMapButton(Icons.my_location_rounded, () {
                    _mapController.move(_hwangeCenter, 11.5);
                  }),
                ],
              ),
            ),

            // ─── GPS Coordinate Readout (Bottom) ──────────────────────
            Positioned(
              bottom: 10,
              left: 12,
              right: 70,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: EcoColors.cardBorder.withValues(alpha: 0.6)),
                    ),
                    child: Text(
                      '${_mapCenter.latitude.toStringAsFixed(5)}° S, '
                      '${_mapCenter.longitude.toStringAsFixed(5)}° E  '
                      '  Z${_mapZoom.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 9.5,
                        color: EcoColors.mintAccent,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '© ESRI / CartoDB / OpenStreetMap',
                      style: TextStyle(fontSize: 7.5, color: EcoColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Layer Toggle Chip ─────────────────────────────────────────────────────

  Widget _buildLayerToggle(
      IconData icon, String label, Color color, bool active, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!active),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: active
              ? color.withValues(alpha: 0.18)
              : Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: active ? color.withValues(alpha: 0.7) : EcoColors.cardBorder,
            width: active ? 1.0 : 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: active ? color : EcoColors.textMuted),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active ? EcoColors.textPrimaryLight : EcoColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Zoom Button ───────────────────────────────────────────────────────────

  Widget _buildMapButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: EcoColors.darkCardBg.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: EcoColors.cardBorder),
        ),
        child: Icon(icon, size: 18, color: EcoColors.textPrimaryLight),
      ),
    );
  }

  // ─── Status Dot ────────────────────────────────────────────────────────────

  Widget _buildStatusDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight)),
      ],
    );
  }

  // ─── Ranger Detail Bottom Sheet ────────────────────────────────────────────

  void _showRangerSheet(RangerTelemetry r) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: EcoColors.darkCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EcoColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: EcoColors.emeraldPrimary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield_rounded, color: EcoColors.mintAccent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: EcoColors.textPrimaryLight)),
                      Text(r.status,
                          style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight)),
                    ],
                  ),
                ),
                EcoBadge(text: 'LIVE', icon: Icons.circle),
              ],
            ),
            const SizedBox(height: 16),
            _buildSheetRow(Icons.location_on_rounded, 'GPS Position',
                '${r.latitude.toStringAsFixed(4)}°S, ${r.longitude.toStringAsFixed(4)}°E',
                EcoColors.mintAccent),
            const Divider(color: EcoColors.cardBorder, height: 16),
            _buildSheetRow(Icons.battery_charging_full_rounded, 'Device Battery', '${r.batteryPct}%',
                r.batteryPct > 50 ? EcoColors.mintAccent : EcoColors.savannaGold),
            const Divider(color: EcoColors.cardBorder, height: 16),
            _buildSheetRow(Icons.access_time_rounded, 'Last GNSS Ping',
                _timeAgo(r.lastPing), EcoColors.textSecondaryLight),
          ],
        ),
      ),
    );
  }

  // ─── Wildlife Detail Bottom Sheet ──────────────────────────────────────────

  void _showWildlifeSheet(WildlifeSighting w) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: EcoColors.darkCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: EcoColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _speciesColor(w.species).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_speciesIcon(w.species),
                      color: _speciesColor(w.species), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(w.species,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: EcoColors.textPrimaryLight)),
                      Text('${w.count} individual${w.count > 1 ? 's' : ''} observed',
                          style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight)),
                    ],
                  ),
                ),
                if (w.isVerified)
                  EcoBadge(text: 'Verified', icon: Icons.verified_rounded),
              ],
            ),
            const SizedBox(height: 16),
            _buildSheetRow(Icons.location_on_rounded, 'GPS Position',
                '${w.latitude.toStringAsFixed(4)}°S, ${w.longitude.toStringAsFixed(4)}°E',
                EcoColors.savannaGold),
            const Divider(color: EcoColors.cardBorder, height: 16),
            _buildSheetRow(Icons.access_time_rounded, 'Sighted', w.timeAgo, EcoColors.textSecondaryLight),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetRow(IconData icon, String label, String value, Color valueColor) {
    return Row(
      children: [
        Icon(icon, size: 14, color: EcoColors.textMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 10.5, color: EcoColors.textSecondaryLight)),
              Text(value,
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: valueColor),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Telemetry Sidebar ─────────────────────────────────────────────────────

  Widget _buildTelemetrySidebar(
      List<RangerTelemetry> rangers, List<WildlifeSighting> sightings, SatelliteHealthLayer satellite) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // NDVI Sentinel Card
          _buildSatelliteCard(satellite),
          const SizedBox(height: 14),
          // Ranger Scouts Card
          _buildRangerCard(rangers),
          const SizedBox(height: 14),
          // Wildlife Sightings Card
          _buildWildlifeCard(sightings),
        ],
      ),
    );
  }

  Widget _buildSatelliteCard(SatelliteHealthLayer satellite) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.satellite_alt_rounded, color: EcoColors.mintAccent, size: 16),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Sentinel-2 NDVI Analysis',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                    overflow: TextOverflow.ellipsis),
              ),
              EcoBadge(text: '${(satellite.meanNdvi * 100).toInt()}% NDVI', fontSize: 9.5),
            ],
          ),
          const SizedBox(height: 14),

          // NDVI Gradient Legend Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Vegetation Health Index',
                  style: TextStyle(fontSize: 10.5, color: EcoColors.textSecondaryLight)),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 12,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFD50000),
                        Color(0xFFFF6D00),
                        Color(0xFFFFD600),
                        Color(0xFF76FF03),
                        Color(0xFF00E676),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0.0 (Barren)', style: TextStyle(fontSize: 9, color: EcoColors.textMuted)),
                  Text('1.0 (Dense)', style: TextStyle(fontSize: 9, color: EcoColors.textMuted)),
                ],
              ),
              const SizedBox(height: 10),

              // NDVI marker position
              LayoutBuilder(builder: (ctx, c) {
                final pct = satellite.meanNdvi.clamp(0.0, 1.0);
                return SizedBox(
                  height: 14,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: EcoColors.cardBorder,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      Positioned(
                        left: (c.maxWidth * pct - 6).clamp(0.0, c.maxWidth - 12),
                        top: 1,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: EcoColors.mintAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Canopy Status', satellite.vegetationStatus),
          const Divider(color: EcoColors.cardBorder, height: 12),
          _buildDetailRow('Sensor / Pass', '${satellite.sensor} • ${satellite.acquisitionDate}'),
          const Divider(color: EcoColors.cardBorder, height: 12),
          _buildDetailRow('Cloud Cover', '${satellite.cloudCoverPct.toStringAsFixed(1)}%'),
          const Divider(color: EcoColors.cardBorder, height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Deforestation Alerts',
                  style: TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: satellite.deforestationAlerts > 0
                      ? const Color(0xFFD50000).withValues(alpha: 0.2)
                      : EcoColors.emeraldPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${satellite.deforestationAlerts} Alert${satellite.deforestationAlerts != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: satellite.deforestationAlerts > 0
                        ? const Color(0xFFD50000)
                        : EcoColors.mintAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRangerCard(List<RangerTelemetry> rangers) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_rounded, color: EcoColors.mintAccent, size: 16),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Active Ranger Scouts',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                    overflow: TextOverflow.ellipsis),
              ),
              Text('${rangers.length} LIVE',
                  style: const TextStyle(
                      fontSize: 10.5, color: EcoColors.mintAccent, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rangers.length,
            separatorBuilder: (context2, i2) => const Divider(color: EcoColors.cardBorder, height: 12),
            itemBuilder: (ctx, i) {
              final r = rangers[i];
              final battColor = r.batteryPct > 60
                  ? EcoColors.mintAccent
                  : r.batteryPct > 30
                      ? EcoColors.savannaGold
                      : const Color(0xFFD50000);
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedMarkerId = r.id);
                  _mapController.move(LatLng(r.latitude, r.longitude), 14.5);
                },
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: EcoColors.mintAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.name,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                              overflow: TextOverflow.ellipsis),
                          Text(r.status,
                              style: const TextStyle(
                                  fontSize: 10, color: EcoColors.textSecondaryLight),
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Battery bar
                        Container(
                          width: 36,
                          height: 5,
                          decoration: BoxDecoration(
                            color: EcoColors.cardBorder,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: r.batteryPct / 100,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: battColor,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text('${r.batteryPct}%',
                            style: TextStyle(
                                fontSize: 9.5, fontWeight: FontWeight.w700, color: battColor)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWildlifeCard(List<WildlifeSighting> sightings) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.pets_rounded, color: EcoColors.savannaGold, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text('Wildlife Sightings',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                    overflow: TextOverflow.ellipsis),
              ),
              EcoBadge(text: 'GPS Verified', fontSize: 9),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sightings.length,
            separatorBuilder: (context2, i2) => const Divider(color: EcoColors.cardBorder, height: 12),
            itemBuilder: (ctx, i) {
              final w = sightings[i];
              final speciesColor = _speciesColor(w.species);
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedMarkerId = w.id);
                  _mapController.move(LatLng(w.latitude, w.longitude), 14.5);
                  _showWildlifeSheet(w);
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: speciesColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_speciesIcon(w.species), size: 12, color: speciesColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(w.species,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600, color: EcoColors.textPrimaryLight),
                              overflow: TextOverflow.ellipsis),
                          Text('${w.count} individual${w.count > 1 ? 's' : ''}',
                              style: const TextStyle(
                                  fontSize: 9.5, color: EcoColors.textSecondaryLight)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(w.timeAgo,
                            style: const TextStyle(fontSize: 10, color: EcoColors.textMuted)),
                        if (w.isVerified)
                          const Icon(Icons.verified_rounded,
                              size: 12, color: EcoColors.mintAccent),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Detail Row ────────────────────────────────────────────────────────────

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label,
              style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight)),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: EcoColors.mintAccent),
              overflow: TextOverflow.ellipsis,
              maxLines: 2),
        ),
      ],
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Color _speciesColor(String species) {
    final s = species.toLowerCase();
    if (s.contains('elephant')) return const Color(0xFF80CBC4);
    if (s.contains('lion')) return const Color(0xFFEF5350);
    if (s.contains('rhino')) return const Color(0xFFFF7043);
    if (s.contains('leopard')) return const Color(0xFFFFCA28);
    if (s.contains('buffalo')) return const Color(0xFF8D6E63);
    if (s.contains('wild dog')) return const Color(0xFFCE93D8);
    return EcoColors.savannaGold;
  }

  IconData _speciesIcon(String species) {
    final s = species.toLowerCase();
    if (s.contains('elephant')) return Icons.pets_rounded;
    if (s.contains('lion')) return Icons.pest_control_rounded;
    if (s.contains('rhino')) return Icons.filter_vintage_rounded;
    return Icons.cruelty_free_rounded;
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ─── NDVI Zone Data Model ─────────────────────────────────────────────────────

class _NdviZone {
  final String label;
  final Color color;
  final List<LatLng> points;
  const _NdviZone({required this.label, required this.color, required this.points});
}
