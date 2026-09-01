class CarbonOffsetProject {
  final String id;
  final String tenantId;
  final String name;
  final String description;
  final double pricePerTonne;
  final double totalCapacity;
  double remainingCapacity;
  final String registryId;
  final double zimbabweCampfirePct;
  final String impactNarrative;
  final String imageUrl;
  final String location;

  CarbonOffsetProject({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.description,
    required this.pricePerTonne,
    required this.totalCapacity,
    required this.remainingCapacity,
    required this.registryId,
    required this.zimbabweCampfirePct,
    required this.impactNarrative,
    required this.imageUrl,
    required this.location,
  });

  double get percentFunded => ((totalCapacity - remainingCapacity) / (totalCapacity > 0 ? totalCapacity : 1.0)).clamp(0.0, 1.0);
}
