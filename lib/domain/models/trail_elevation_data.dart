enum MobilityProfile {
  powerWheelchair('Power Wheelchair', 14.0, true, 80.0),
  manualWheelchair('Manual Wheelchair', 8.0, false, 50.0),
  allTerrainTrekker('All-Terrain Trekker', 22.0, true, 95.0),
  stroller('Baby Stroller', 10.0, false, 60.0),
  elderWalkingCane('Walking Cane / Elder', 12.0, false, 70.0),
  visualAssistance('Visual Assistance / Blind', 18.0, false, 65.0);

  final String label;
  final double maxTolerableSlopePct;
  final bool requiresRampSurface;
  final double baseMobilityIndex;

  const MobilityProfile(
    this.label,
    this.maxTolerableSlopePct,
    this.requiresRampSurface,
    this.baseMobilityIndex,
  );
}

class TrailElevationPoint {
  final double distanceMeters;
  final double elevationMeters;
  final double slopePct;
  final String surfaceType; // 'Smooth Boardwalk', 'Compacted Gravel', 'Rocky Granite', 'Stone Steps'
  final bool isRestStop;
  final String? obstacleLabel;

  const TrailElevationPoint({
    required this.distanceMeters,
    required this.elevationMeters,
    required this.slopePct,
    required this.surfaceType,
    this.isRestStop = false,
    this.obstacleLabel,
  });
}

class TrailObstacleReport {
  final String id;
  final String trailId;
  final String obstacleType; // 'Fallen Tree', 'Eroded Ramp', 'High Incline', 'Loose Gravel'
  final String description;
  final double distanceMeters;
  final double latitude;
  final double longitude;
  final String reporterName;
  final DateTime reportedAt;
  final bool isResolved;

  const TrailObstacleReport({
    required this.id,
    required this.trailId,
    required this.obstacleType,
    required this.description,
    required this.distanceMeters,
    required this.latitude,
    required this.longitude,
    required this.reporterName,
    required this.reportedAt,
    this.isResolved = false,
  });
}

class TrailRouteAnalysis {
  final String trailId;
  final String trailName;
  final String location;
  final double totalDistanceMeters;
  final double minElevationMeters;
  final double maxElevationMeters;
  final List<TrailElevationPoint> elevationProfile;
  final List<TrailObstacleReport> activeObstacles;

  const TrailRouteAnalysis({
    required this.trailId,
    required this.trailName,
    required this.location,
    required this.totalDistanceMeters,
    required this.minElevationMeters,
    required this.maxElevationMeters,
    required this.elevationProfile,
    this.activeObstacles = const [],
  });

  double get elevationGainMeters => maxElevationMeters - minElevationMeters;

  double get maxSlopePct => elevationProfile.fold(
        0.0,
        (maxS, p) => p.slopePct > maxS ? p.slopePct : maxS,
      );

  double get averageSlopePct {
    if (elevationProfile.isEmpty) return 0.0;
    final sum = elevationProfile.fold(0.0, (s, p) => s + p.slopePct);
    return double.parse((sum / elevationProfile.length).toStringAsFixed(1));
  }

  /// Evaluates passability for a given mobility profile
  double calculatePassabilityScore(MobilityProfile profile) {
    double score = 100.0;

    for (var point in elevationProfile) {
      if (point.slopePct > profile.maxTolerableSlopePct) {
        final excess = point.slopePct - profile.maxTolerableSlopePct;
        score -= excess * 4.5;
      }
      if (profile.requiresRampSurface && point.surfaceType == 'Stone Steps') {
        score -= 25.0;
      }
      if (point.obstacleLabel != null) {
        score -= 10.0;
      }
    }

    // Active unresolved obstacle penalties
    score -= activeObstacles.where((o) => !o.isResolved).length * 8.0;

    return double.parse(score.clamp(0.0, 100.0).toStringAsFixed(0));
  }

  /// Computes estimated transit duration in minutes
  int estimateTransitMinutes(MobilityProfile profile) {
    final baseSpeedKmH = profile == MobilityProfile.powerWheelchair ? 4.5 : 2.5;
    final baseMinutes = (totalDistanceMeters / 1000.0) / baseSpeedKmH * 60.0;
    final slopePenaltyMinutes = (maxSlopePct / 3.0);
    final restStopsBonusMinutes = elevationProfile.where((p) => p.isRestStop).length * 4.0;
    return (baseMinutes + slopePenaltyMinutes + restStopsBonusMinutes).round();
  }

  static TrailRouteAnalysis getVicFallsRainforestTrail() {
    return TrailRouteAnalysis(
      trailId: 'vic-falls-rainforest',
      trailName: 'Victoria Falls Cataract & Rainforest Boardwalk',
      location: 'Victoria Falls National Park',
      totalDistanceMeters: 1450.0,
      minElevationMeters: 885.0,
      maxElevationMeters: 908.0,
      elevationProfile: const [
        TrailElevationPoint(distanceMeters: 0, elevationMeters: 885, slopePct: 1.2, surfaceType: 'Smooth Boardwalk', isRestStop: true),
        TrailElevationPoint(distanceMeters: 200, elevationMeters: 887, slopePct: 2.5, surfaceType: 'Smooth Boardwalk'),
        TrailElevationPoint(distanceMeters: 450, elevationMeters: 892, slopePct: 3.8, surfaceType: 'Smooth Boardwalk', isRestStop: true),
        TrailElevationPoint(distanceMeters: 750, elevationMeters: 898, slopePct: 6.2, surfaceType: 'Compacted Gravel', obstacleLabel: 'Slight spray dampness'),
        TrailElevationPoint(distanceMeters: 1050, elevationMeters: 905, slopePct: 4.5, surfaceType: 'Smooth Boardwalk', isRestStop: true),
        TrailElevationPoint(distanceMeters: 1250, elevationMeters: 908, slopePct: 2.0, surfaceType: 'Smooth Boardwalk'),
        TrailElevationPoint(distanceMeters: 1450, elevationMeters: 890, slopePct: 1.5, surfaceType: 'Smooth Boardwalk', isRestStop: true),
      ],
      activeObstacles: [
        TrailObstacleReport(
          id: 'obs-01',
          trailId: 'vic-falls-rainforest',
          obstacleType: 'Rainforest Spray Mist',
          description: 'High moisture at Viewpoint 7, non-slip ramp grip engaged.',
          distanceMeters: 750,
          latitude: -17.9244,
          longitude: 25.8560,
          reporterName: 'Ranger Ndlovu',
          reportedAt: DateTime(2026, 9, 1),
          isResolved: false,
        ),
      ],
    );
  }

  static TrailRouteAnalysis getGreatZimbabweHillEnclosureTrail() {
    return const TrailRouteAnalysis(
      trailId: 'great-zim-hill',
      trailName: 'Great Zimbabwe Ancient Dry-Stone Terraces',
      location: 'Masvingo Heritage Sanctuary',
      totalDistanceMeters: 1850.0,
      minElevationMeters: 1040.0,
      maxElevationMeters: 1125.0,
      elevationProfile: [
        TrailElevationPoint(distanceMeters: 0, elevationMeters: 1040, slopePct: 2.0, surfaceType: 'Tactile Stone Paver', isRestStop: true),
        TrailElevationPoint(distanceMeters: 300, elevationMeters: 1055, slopePct: 5.0, surfaceType: 'Tactile Stone Paver'),
        TrailElevationPoint(distanceMeters: 600, elevationMeters: 1075, slopePct: 8.5, surfaceType: 'Compacted Gravel', isRestStop: true),
        TrailElevationPoint(distanceMeters: 950, elevationMeters: 1098, slopePct: 14.2, surfaceType: 'Granite Path', obstacleLabel: 'Ancient staircase bypass ramp'),
        TrailElevationPoint(distanceMeters: 1350, elevationMeters: 1115, slopePct: 10.0, surfaceType: 'Tactile Stone Paver', isRestStop: true),
        TrailElevationPoint(distanceMeters: 1850, elevationMeters: 1125, slopePct: 3.5, surfaceType: 'Tactile Stone Paver', isRestStop: true),
      ],
    );
  }
}
