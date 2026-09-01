class Milestone {
  final String id;
  final String title;
  final String description;
  final double metricDelta;
  final String? evidenceUrl;
  final double? latitude;
  final double? longitude;
  final String? verifiedBy;
  final DateTime createdAt;

  Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.metricDelta,
    this.evidenceUrl,
    this.latitude,
    this.longitude,
    this.verifiedBy,
    required this.createdAt,
  });
}

enum ProjectType {
  antiPoaching,
  waterProject,
  reforestation,
  solarCommunity,
  wildlifeCorridor,
  humanWildlifeConflict;

  String get displayName {
    switch (this) {
      case ProjectType.antiPoaching:
        return 'Anti-Poaching & Snare Patrol';
      case ProjectType.waterProject:
        return 'Community Water Sanctuary';
      case ProjectType.reforestation:
        return 'Indigenous Forest Reforestation';
      case ProjectType.solarCommunity:
        return 'Solar Microgrid & Rural Power';
      case ProjectType.wildlifeCorridor:
        return 'Wildlife Migration Corridor';
      case ProjectType.humanWildlifeConflict:
        return 'Conflict Mitigation & Defense';
    }
  }

  String get iconEmoji {
    switch (this) {
      case ProjectType.antiPoaching:
        return '🛡️';
      case ProjectType.waterProject:
        return '💧';
      case ProjectType.reforestation:
        return '🌳';
      case ProjectType.solarCommunity:
        return '☀️';
      case ProjectType.wildlifeCorridor:
        return '🐾';
      case ProjectType.humanWildlifeConflict:
        return '🦁';
    }
  }
}

class ConservationProject {
  final String id;
  final String tenantId;
  final String name;
  final String description;
  final ProjectType type;
  final double targetMetric;
  double currentMetric;
  final String unit;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final List<Milestone> milestones;
  final DateTime createdAt;

  ConservationProject({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.description,
    required this.type,
    required this.targetMetric,
    required this.currentMetric,
    required this.unit,
    this.imageUrl,
    this.latitude,
    this.longitude,
    required this.milestones,
    required this.createdAt,
  });

  double get progressPercentage => (currentMetric / (targetMetric > 0 ? targetMetric : 1.0)).clamp(0.0, 1.0);
}
