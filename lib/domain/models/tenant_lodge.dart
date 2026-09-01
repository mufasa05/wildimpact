class TenantLodge {
  final String id;
  final String name;
  final String slug;
  final String country;
  final String region;
  final String description;
  final String bannerUrl;
  final double campfireSharePct;
  final int totalPatrolHours;
  final int hectaresProtected;
  final double carbonOffsetFundedUsd;
  final int treesPlanted;
  final int waterLitersProvided;

  const TenantLodge({
    required this.id,
    required this.name,
    required this.slug,
    required this.country,
    required this.region,
    required this.description,
    required this.bannerUrl,
    required this.campfireSharePct,
    required this.totalPatrolHours,
    required this.hectaresProtected,
    required this.carbonOffsetFundedUsd,
    required this.treesPlanted,
    required this.waterLitersProvided,
  });
}
