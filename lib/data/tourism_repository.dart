import '../domain/models/tenant_lodge.dart';
import '../domain/models/conservation_project.dart';
import '../domain/models/carbon_offset_project.dart';
import '../domain/models/offset_purchase.dart';
import '../domain/models/geospatial_data.dart';
import '../domain/models/booking_contribution.dart';
import '../domain/models/impact_evidence.dart';
import 'mock_tourism_data.dart';

class TourismRepository {
  final List<TenantLodge> _lodges = List.from(MockTourismData.lodges);
  final List<ConservationProject> _projects = MockTourismData.getInitialProjects();
  final List<CarbonOffsetProject> _offsetProjects = MockTourismData.getInitialOffsetProjects();
  final List<OffsetPurchase> _purchases = MockTourismData.getInitialPurchases();
  final List<BookingContribution> _contributions = MockTourismData.getInitialContributions();
  final List<ImpactEvidence> _evidence = MockTourismData.getInitialEvidence();

  List<TenantLodge> getLodges() => _lodges;

  TenantLodge getLodgeById(String id) {
    return _lodges.firstWhere((l) => l.id == id, orElse: () => _lodges.first);
  }

  List<ConservationProject> getProjectsForLodge(String tenantId) {
    return _projects.where((p) => p.tenantId == tenantId).toList();
  }

  List<CarbonOffsetProject> getOffsetProjectsForLodge(String tenantId) {
    return _offsetProjects.where((p) => p.tenantId == tenantId).toList();
  }

  List<OffsetPurchase> getPurchases() => _purchases;

  List<BookingContribution> getContributions() => _contributions;

  List<ImpactEvidence> getImpactEvidence() => _evidence;

  void addContribution(BookingContribution contribution) {
    _contributions.insert(0, contribution);
  }

  void addMilestone({
    required String projectId,
    required String title,
    required String description,
    required double metricDelta,
    String? evidenceUrl,
    double? latitude,
    double? longitude,
    String? verifiedBy,
  }) {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      final project = _projects[index];
      final newMilestone = Milestone(
        id: 'm-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        metricDelta: metricDelta,
        evidenceUrl: evidenceUrl,
        latitude: latitude ?? project.latitude,
        longitude: longitude ?? project.longitude,
        verifiedBy: verifiedBy ?? 'Field Ranger Sibanda',
        createdAt: DateTime.now(),
      );

      project.milestones.insert(0, newMilestone);
      project.currentMetric += metricDelta;
    }
  }

  void addConservationProject(ConservationProject project) {
    _projects.insert(0, project);
  }

  OffsetPurchase purchaseOffset({
    required String offsetProjectId,
    required String touristName,
    required String touristEmail,
    required double tonnes,
    required String paymentMethod,
  }) {
    final offsetProj = _offsetProjects.firstWhere((p) => p.id == offsetProjectId);
    final amountPaid = tonnes * offsetProj.pricePerTonne;
    final campfireShare = amountPaid * (offsetProj.zimbabweCampfirePct / 100);
    final certCode = 'WI-ZW-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    offsetProj.remainingCapacity = (offsetProj.remainingCapacity - tonnes).clamp(0.0, offsetProj.totalCapacity);

    final purchase = OffsetPurchase(
      id: 'purch-${DateTime.now().millisecondsSinceEpoch}',
      offsetProjectId: offsetProj.id,
      projectName: offsetProj.name,
      touristName: touristName,
      touristEmail: touristEmail,
      tonnes: tonnes,
      amountPaid: amountPaid,
      campfireShare: campfireShare,
      certificateCode: certCode,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
    );

    _purchases.insert(0, purchase);
    return purchase;
  }

  List<RangerTelemetry> getRangerTelemetry() => MockTourismData.getRangerTelemetry();
  List<WildlifeSighting> getWildlifeSightings() => MockTourismData.getWildlifeSightings();
  SatelliteHealthLayer getSatelliteHealth() => MockTourismData.satelliteNdvi;
}
