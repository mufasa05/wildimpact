import 'package:flutter_test/flutter_test.dart';
import 'package:wildimpact/domain/models/trip_itinerary.dart';
import 'package:wildimpact/domain/models/policy_simulation.dart';
import 'package:wildimpact/domain/models/trail_elevation_data.dart';
import 'package:wildimpact/domain/models/artisan_order.dart';

void main() {
  group('Interactive Engine & Computation Tests', () {
    test('TripItinerary accurately calculates emissions, costs, and economic retention', () {
      final itinerary = TripItinerary.createDefault();

      expect(itinerary.legs.length, equals(3));
      expect(itinerary.totalDistanceKm, equals(1225.0));

      final initialCost = itinerary.totalCostUsd;
      final initialRetention = itinerary.totalLocalRetentionUsd;
      final initialLeakage = itinerary.totalForeignLeakageUsd;
      final initialEmissions = itinerary.totalEmissionsTonnes;

      expect(initialCost, greaterThan(0));
      expect(initialRetention + initialLeakage, closeTo(initialCost, 0.01));
      expect(initialEmissions, greaterThan(0));

      // Test 1-Click Zero Leakage Optimization
      itinerary.optimizeForZeroLeakageAndCarbon();

      expect(itinerary.totalLocalRetentionUsd, greaterThan(initialRetention));
      expect(itinerary.totalEmissionsTonnes, lessThan(initialEmissions));
      expect(itinerary.overallRetentionPercentage, greaterThan(65.0));
    });

    test('ZtaPolicySimulation dynamically computes 12-month community inflow projections', () {
      final sim = ZtaPolicySimulation(
        campfireLevyPct: 25.0,
        lodgeLocalProcurementQuotaPct: 40.0,
        otaCommissionCapPct: 15.0,
        dispersalTaxRebateUsd: 50.0,
      );

      final inflow = sim.projectedAnnualCommunityInflowMillions;
      expect(inflow, greaterThan(25.0)); // >$25M

      final jobs = sim.projectedDirectRuralJobs;
      expect(jobs, greaterThan(18500));

      final points = sim.generate12MonthProjection();
      expect(points.length, equals(12));
      expect(points.first.monthName, equals('Jan'));
      expect(points.last.monthName, equals('Dec'));
      expect(points[7].communityInflowUsd, greaterThan(points[0].communityInflowUsd)); // Safari dry season peak
    });

    test('TrailRouteAnalysis passability algorithm evaluates mobility profiles correctly', () {
      final vicFallsTrail = TrailRouteAnalysis.getVicFallsRainforestTrail();
      final greatZimTrail = TrailRouteAnalysis.getGreatZimbabweHillEnclosureTrail();

      final vicFallsPowerScore = vicFallsTrail.calculatePassabilityScore(MobilityProfile.powerWheelchair);
      expect(vicFallsPowerScore, greaterThanOrEqualTo(80.0));

      final greatZimPowerScore = greatZimTrail.calculatePassabilityScore(MobilityProfile.powerWheelchair);
      final greatZimManualScore = greatZimTrail.calculatePassabilityScore(MobilityProfile.manualWheelchair);

      expect(greatZimPowerScore, greaterThan(greatZimManualScore));

      final transitMins = vicFallsTrail.estimateTransitMinutes(MobilityProfile.powerWheelchair);
      expect(transitMins, greaterThan(15));
      expect(transitMins, lessThan(60));
    });

    test('ArtisanCommissionOrder calculates fair trade wages and generates valid provenance hash', () {
      final order = ArtisanCommissionOrder(
        id: 'ord-test-01',
        artisanName: 'Simba Chiweshe',
        artisanVillage: 'Tengenenge Sculpture Village',
        artisanWhatsApp: '+263771234567',
        selectedMaterial: CraftMaterial.verditeStone,
        selectedDimension: CraftDimension.mantelpiece,
      );

      expect(order.artisanLaborWageUsd, equals(66.0)); // 3 days * $22
      expect(order.totalOrderPriceUsd, greaterThan(150.0));
      expect(order.provenanceCertificateHash, startsWith('PROV-ZW-'));

      final waMessage = order.generateWhatsAppMessage();
      expect(waMessage, contains('Simba'));
      expect(waMessage, contains('Verdite'));
    });
  });
}
