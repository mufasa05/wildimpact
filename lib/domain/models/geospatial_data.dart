class RangerTelemetry {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int batteryPct;
  final String status;
  final DateTime lastPing;

  const RangerTelemetry({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.batteryPct,
    required this.status,
    required this.lastPing,
  });
}

class WildlifeSighting {
  final String id;
  final String species;
  final int count;
  final double latitude;
  final double longitude;
  final String timeAgo;
  final bool isVerified;

  const WildlifeSighting({
    required this.id,
    required this.species,
    required this.count,
    required this.latitude,
    required this.longitude,
    required this.timeAgo,
    required this.isVerified,
  });
}

class SatelliteHealthLayer {
  final String sensor;
  final String acquisitionDate;
  final double cloudCoverPct;
  final double meanNdvi;
  final String vegetationStatus;
  final int deforestationAlerts;

  const SatelliteHealthLayer({
    required this.sensor,
    required this.acquisitionDate,
    required this.cloudCoverPct,
    required this.meanNdvi,
    required this.vegetationStatus,
    required this.deforestationAlerts,
  });
}
