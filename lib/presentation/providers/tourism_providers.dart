import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/tourism_repository.dart';
import '../../domain/models/tenant_lodge.dart';
import '../../domain/models/conservation_project.dart';
import '../../domain/models/carbon_offset_project.dart';
import '../../domain/models/offset_purchase.dart';
import '../../domain/models/geospatial_data.dart';
import '../../domain/models/booking_contribution.dart';
import '../../domain/models/impact_evidence.dart';

enum UserRole {
  operator('Operator Command Hub', 'B2B Real-time Dashboard & Telemetry'),
  guest('Guest Mobile Experience', 'B2C Impact Stories & Offset Calculator'),
  platformShowcase('Platform Showcase & Deck', 'B2B Value Proposition & Architecture'),
  tourismBoard('ZTA ESG Auditor', 'National Compliance & CAMPFIRE');

  final String label;
  final String subtitle;
  const UserRole(this.label, this.subtitle);
}

final tourismRepositoryProvider = Provider<TourismRepository>((ref) {
  return TourismRepository();
});

final activeRoleProvider = StateProvider<UserRole>((ref) {
  return UserRole.operator;
});

final selectedLodgeIdProvider = StateProvider<String>((ref) {
  return 'hwange-safari-lodge';
});

final selectedLodgeProvider = Provider<TenantLodge>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  final lodgeId = ref.watch(selectedLodgeIdProvider);
  return repo.getLodgeById(lodgeId);
});

final allLodgesProvider = Provider<List<TenantLodge>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  return repo.getLodges();
});

class ContributionsNotifier extends StateNotifier<List<BookingContribution>> {
  final TourismRepository _repository;

  ContributionsNotifier(this._repository) : super(_repository.getContributions());

  void addContribution(BookingContribution contribution) {
    _repository.addContribution(contribution);
    state = List.from(_repository.getContributions());
  }

  void refresh() {
    state = List.from(_repository.getContributions());
  }
}

final contributionsProvider =
    StateNotifierProvider<ContributionsNotifier, List<BookingContribution>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  return ContributionsNotifier(repo);
});

final impactEvidenceProvider = Provider<List<ImpactEvidence>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  return repo.getImpactEvidence();
});

class ConservationProjectsNotifier extends StateNotifier<List<ConservationProject>> {
  final TourismRepository _repository;
  final String _lodgeId;

  ConservationProjectsNotifier(this._repository, this._lodgeId)
      : super(_repository.getProjectsForLodge(_lodgeId));

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
    _repository.addMilestone(
      projectId: projectId,
      title: title,
      description: description,
      metricDelta: metricDelta,
      evidenceUrl: evidenceUrl,
      latitude: latitude,
      longitude: longitude,
      verifiedBy: verifiedBy,
    );
    state = List.from(_repository.getProjectsForLodge(_lodgeId));
  }

  void addProject(ConservationProject project) {
    _repository.addConservationProject(project);
    state = List.from(_repository.getProjectsForLodge(_lodgeId));
  }

  void refresh() {
    state = List.from(_repository.getProjectsForLodge(_lodgeId));
  }
}

final conservationProjectsProvider =
    StateNotifierProvider<ConservationProjectsNotifier, List<ConservationProject>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  final lodgeId = ref.watch(selectedLodgeIdProvider);
  return ConservationProjectsNotifier(repo, lodgeId);
});

class CarbonOffsetProjectsNotifier extends StateNotifier<List<CarbonOffsetProject>> {
  final TourismRepository _repository;
  final String _lodgeId;

  CarbonOffsetProjectsNotifier(this._repository, this._lodgeId)
      : super(_repository.getOffsetProjectsForLodge(_lodgeId));

  void refresh() {
    state = List.from(_repository.getOffsetProjectsForLodge(_lodgeId));
  }
}

final carbonOffsetProjectsProvider =
    StateNotifierProvider<CarbonOffsetProjectsNotifier, List<CarbonOffsetProject>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  final lodgeId = ref.watch(selectedLodgeIdProvider);
  return CarbonOffsetProjectsNotifier(repo, lodgeId);
});

class PurchasesNotifier extends StateNotifier<List<OffsetPurchase>> {
  final TourismRepository _repository;

  PurchasesNotifier(this._repository) : super(_repository.getPurchases());

  OffsetPurchase purchaseOffset({
    required String offsetProjectId,
    required String touristName,
    required String touristEmail,
    required double tonnes,
    required String paymentMethod,
  }) {
    final purchase = _repository.purchaseOffset(
      offsetProjectId: offsetProjectId,
      touristName: touristName,
      touristEmail: touristEmail,
      tonnes: tonnes,
      paymentMethod: paymentMethod,
    );
    state = List.from(_repository.getPurchases());
    return purchase;
  }
}

final purchasesProvider =
    StateNotifierProvider<PurchasesNotifier, List<OffsetPurchase>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  return PurchasesNotifier(repo);
});

final latestCertificateProvider = StateProvider<OffsetPurchase?>((ref) {
  final purchases = ref.watch(purchasesProvider);
  return purchases.isNotEmpty ? purchases.first : null;
});

final rangerTelemetryProvider = Provider<List<RangerTelemetry>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  return repo.getRangerTelemetry();
});

final wildlifeSightingsProvider = Provider<List<WildlifeSighting>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  return repo.getWildlifeSightings();
});

final satelliteHealthProvider = Provider<SatelliteHealthLayer>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  return repo.getSatelliteHealth();
});
