import 'dart:math';

class MonthlyProjectionPoint {
  final int monthIndex; // 1 to 12
  final String monthName;
  final double communityInflowUsd; // in thousands
  final double jobsCreated;
  final double dispersalShiftPct;

  const MonthlyProjectionPoint({
    required this.monthIndex,
    required this.monthName,
    required this.communityInflowUsd,
    required this.jobsCreated,
    required this.dispersalShiftPct,
  });
}

class ZtaPolicySimulation {
  double campfireLevyPct; // 0% to 50%
  double otaCommissionCapPct; // 5% to 30%
  double lodgeLocalProcurementQuotaPct; // 10% to 80%
  double dispersalTaxRebateUsd; // $0 to $100

  // Baseline Constants (Zimbabwe National Tourism Annual Data)
  static const double baselineAnnualVisitors = 2200000.0; // 2.2 million visitors
  static const double baselineAvgSpendPerVisitorUsd = 680.0; // $680 total trip spend
  static const double baselineCommunityInflowUsd = 14200000.0; // $14.2M reaching communities
  static const double baselineRuralTourismJobs = 18500.0;

  ZtaPolicySimulation({
    this.campfireLevyPct = 20.0,
    this.otaCommissionCapPct = 22.0,
    this.lodgeLocalProcurementQuotaPct = 30.0,
    this.dispersalTaxRebateUsd = 25.0,
  });

  /// Total projected annual community inflow (in USD Millions)
  double get projectedAnnualCommunityInflowMillions {
    final campfireFactor = (campfireLevyPct / 20.0) * 12.0; // base $12M from levy
    final procurementFactor = (lodgeLocalProcurementQuotaPct / 30.0) * 18.5; // base $18.5M local food/services
    final otaSavingsMultiplier = ((25.0 - otaCommissionCapPct).clamp(0.0, 20.0) / 10.0) * 8.4;
    final total = (baselineCommunityInflowUsd / 1000000.0) +
        campfireFactor +
        procurementFactor +
        otaSavingsMultiplier;
    return double.parse(total.toStringAsFixed(2));
  }

  /// Total direct rural jobs created or sustained
  int get projectedDirectRuralJobs {
    final multiplier = (campfireLevyPct * 0.015) +
        (lodgeLocalProcurementQuotaPct * 0.025) +
        (dispersalTaxRebateUsd * 0.01);
    final jobs = baselineRuralTourismJobs * (1.0 + multiplier);
    return jobs.round();
  }

  /// Provincial Gini Inequality Reduction (%)
  double get projectedGiniReductionPct {
    final score = (campfireLevyPct * 0.4) +
        (lodgeLocalProcurementQuotaPct * 0.35) +
        (dispersalTaxRebateUsd * 0.25);
    return double.parse((score * 0.38).clamp(1.5, 28.5).toStringAsFixed(1));
  }

  /// Visitor dispersal shift to Eastern Highlands / Masvingo / Kariba (%)
  double get projectedVisitorDispersalShiftPct {
    final shift = (dispersalTaxRebateUsd * 0.42) + (campfireLevyPct * 0.18);
    return double.parse(shift.clamp(2.0, 48.0).toStringAsFixed(1));
  }

  /// Generates 12-month trajectory curves
  List<MonthlyProjectionPoint> generate12MonthProjection() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final annualInflowThousand = projectedAnnualCommunityInflowMillions * 1000.0;
    final baseMonthly = annualInflowThousand / 12.0;
    final totalJobs = projectedDirectRuralJobs;

    return List.generate(12, (index) {
      // Seasonal Safari Peak factor (July to October is peak dry safari season in Zimbabwe)
      final seasonalMultiplier = 1.0 + (0.35 * sin((index - 2) * pi / 6));
      final monthlyInflow = (baseMonthly * seasonalMultiplier) * (1.0 + (index * 0.03));
      final monthlyJobs = totalJobs * (0.85 + (0.15 * (index / 11.0)));
      final monthlyDispersal = projectedVisitorDispersalShiftPct * (0.7 + (0.3 * (index / 11.0)));

      return MonthlyProjectionPoint(
        monthIndex: index + 1,
        monthName: months[index],
        communityInflowUsd: double.parse(monthlyInflow.toStringAsFixed(1)),
        jobsCreated: double.parse(monthlyJobs.toStringAsFixed(0)),
        dispersalShiftPct: double.parse(monthlyDispersal.toStringAsFixed(1)),
      );
    });
  }

  void resetToDefaults() {
    campfireLevyPct = 20.0;
    otaCommissionCapPct = 22.0;
    lodgeLocalProcurementQuotaPct = 30.0;
    dispersalTaxRebateUsd = 25.0;
  }
}
