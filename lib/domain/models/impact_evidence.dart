class ImpactEvidence {
  final String id;
  final String title;
  final String category; // 'Anti-Poaching' | 'Community Water' | 'Habitat Restoration' | 'Wildlife Monitoring'
  final String location;
  final String date;
  final String imageUrl;
  final String verifiedBy;
  final String description;
  final double latitude;
  final double longitude;
  final String registryRef;

  const ImpactEvidence({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.verifiedBy,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.registryRef,
  });
}
