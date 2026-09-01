class EconomicLeakageMetric {
  final String region;
  final double averageDailyTouristSpendUsd;
  final double localResidentRetentionUsd;
  final double foreignOtaLeakageUsd;
  final double campfireCommunityShareUsd;
  final double directInformalSmeSpendUsd;
  final String keyBottleneck;
  final String interventionStrategy;

  const EconomicLeakageMetric({
    required this.region,
    required this.averageDailyTouristSpendUsd,
    required this.localResidentRetentionUsd,
    required this.foreignOtaLeakageUsd,
    required this.campfireCommunityShareUsd,
    required this.directInformalSmeSpendUsd,
    required this.keyBottleneck,
    required this.interventionStrategy,
  });

  double get retentionPercentage =>
      (localResidentRetentionUsd / (averageDailyTouristSpendUsd > 0 ? averageDailyTouristSpendUsd : 1.0)) * 100;

  double get leakagePercentage =>
      (foreignOtaLeakageUsd / (averageDailyTouristSpendUsd > 0 ? averageDailyTouristSpendUsd : 1.0)) * 100;
}
