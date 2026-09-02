import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/tourism_repository.dart';
import '../../data/supabase_tourism_repository.dart';
import '../../core/services/supabase_service.dart';
import '../../domain/models/tenant_lodge.dart';
import '../../domain/models/conservation_project.dart';
import '../../domain/models/carbon_offset_project.dart';
import '../../domain/models/offset_purchase.dart';
import '../../domain/models/geospatial_data.dart';
import '../../domain/models/booking_contribution.dart';
import '../../domain/models/impact_evidence.dart';
import '../../domain/models/cultural_narrative.dart';
import '../../domain/models/accessibility_feature.dart';
import '../../domain/models/economic_leakage_data.dart';
import '../../domain/models/sme_provider.dart';
import '../../domain/models/user_auth_profile.dart';

enum UserRole {
  tourist('Tourist & Eco-Traveler', 'Live Safari, AI Concierge, Offline Maps & Passport', Icons.explore_rounded),
  guest('Tourist & Eco-Traveler', 'Live Safari, AI Concierge, Offline Maps & Passport', Icons.explore_rounded),
  operator('Safari Lodge Host', 'Multi-tenant Operations, Telemetry & ESG Reports', Icons.cottage_rounded),
  ranger('Wildlife Ranger & Patrol', 'Anti-Poaching Radar, GPS Telemetry & Patrols', Icons.shield_rounded),
  nationalZta('National Tourism Board', 'Macro Footprints, Economic Leakage & Nationwide Analytics', Icons.analytics_rounded),
  providerPortal('Community SME & Artisan', '0% Fee Supplier Portal, Direct Orders & Payouts', Icons.handshake_rounded),
  culturalHeritage('Living Heritage Custodian', 'Oral Folklore Registry & Elder Royalties', Icons.record_voice_over_rounded),
  accessibility('Universal Accessibility', 'Wheelchair Routing & Inclusive Safaris', Icons.accessible_rounded);

  final String label;
  final String subtitle;
  final IconData icon;
  const UserRole(this.label, this.subtitle, this.icon);
}

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.dark;
});

final isAuthenticatedProvider = StateProvider<bool>((ref) {
  return false; // Launch at Auth screen first
});

final activeRoleProvider = StateProvider<UserRole>((ref) {
  return UserRole.tourist;
});

final tourismRepositoryProvider = Provider<TourismRepository>((ref) {
  return SupabaseTourismRepository();
});

class CurrentUserProfileNotifier extends StateNotifier<UserAuthProfile> {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final Ref _ref;

  CurrentUserProfileNotifier(this._ref)
      : super(const UserAuthProfile(
          id: 'user-demo-01',
          email: 'mufasa@wildimpact.org',
          fullName: 'Mufasa',
          persona: UserPersona.tourist,
          offsetPoints: 1250,
          royaltyBalanceUsd: 48.50,
        ));

  void signInAsRole(UserPersona persona, {String? fullName, String? email}) {
    String defaultName;
    String defaultEmail;
    UserRole targetRole;

    switch (persona) {
      case UserPersona.tourist:
        defaultName = fullName ?? 'Mufasa';
        defaultEmail = email ?? 'mufasa@wildimpact.org';
        targetRole = UserRole.tourist;
        break;
      case UserPersona.operator:
        defaultName = fullName ?? 'Tendai Chikwanda (General Manager)';
        defaultEmail = email ?? 'tendai.c@hwangewild.org';
        targetRole = UserRole.operator;
        break;
      case UserPersona.ranger:
        defaultName = fullName ?? 'Ranger Chief Dube';
        defaultEmail = email ?? 'dube.ranger@zimparks.org';
        targetRole = UserRole.ranger;
        break;
      case UserPersona.ztaAuditor:
        defaultName = fullName ?? 'Dr. Chipo Marufu (Auditor General)';
        defaultEmail = email ?? 'chipo.m@tourismzimbabwe.gov.zw';
        targetRole = UserRole.nationalZta;
        break;
      case UserPersona.smeProvider:
        defaultName = fullName ?? 'Farai Ndlovu (Artisan Guild Master)';
        defaultEmail = email ?? 'farai.crafts@masvingosme.org';
        targetRole = UserRole.providerPortal;
        break;
      case UserPersona.elderCustodian:
        defaultName = fullName ?? 'Sekuru Munyaradzi Mutapa';
        defaultEmail = email ?? 'elder.munyaradzi@heritagezim.org';
        targetRole = UserRole.culturalHeritage;
        break;
    }

    state = UserAuthProfile(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      email: defaultEmail,
      fullName: defaultName,
      persona: persona,
      tenantLodgeId: persona == UserPersona.operator ? 'hwange-safari-lodge' : null,
      royaltyBalanceUsd: persona == UserPersona.elderCustodian ? 185.00 : (persona == UserPersona.smeProvider ? 340.00 : 48.50),
      offsetPoints: persona == UserPersona.tourist ? 1250 : 400,
    );

    _ref.read(activeRoleProvider.notifier).state = targetRole;
    _ref.read(isAuthenticatedProvider.notifier).state = true;
  }

  void switchPersona(UserPersona persona) {
    signInAsRole(persona, fullName: state.fullName, email: state.email);
  }

  Future<void> signInWithSupabase({required String email, required String password, UserPersona persona = UserPersona.tourist}) async {
    final response = await _supabaseService.signIn(email: email, password: password);
    if (response?.user != null) {
      final userName = response!.user!.userMetadata?['full_name'] as String? ?? (email.split('@').first.isNotEmpty ? email.split('@').first : 'Explorer');
      signInAsRole(persona, fullName: userName, email: email);
    } else {
      // Fallback to local session
      signInAsRole(persona, email: email);
    }
  }

  Future<void> signUpWithSupabase({required String email, required String password, String? fullName, UserPersona persona = UserPersona.tourist}) async {
    await _supabaseService.signUp(email: email, password: password, fullName: fullName);
    signInAsRole(persona, fullName: fullName ?? 'Mufasa', email: email);
  }

  Future<void> signOut() async {
    await _supabaseService.signOut();
    state = const UserAuthProfile(
      id: 'guest-anon',
      email: 'mufasa@wildimpact.org',
      fullName: 'Mufasa',
      persona: UserPersona.tourist,
    );
    _ref.read(isAuthenticatedProvider.notifier).state = false;
  }
}

final currentUserProfileProvider = StateNotifierProvider<CurrentUserProfileNotifier, UserAuthProfile>((ref) {
  return CurrentUserProfileNotifier(ref);
});

final culturalNarrativesProvider = Provider<List<CulturalNarrative>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  return repo.getCulturalNarratives();
});

final accessibilityFeaturesProvider = Provider<List<AccessibilityFeature>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  return repo.getAccessibilityFeatures();
});

final economicLeakageMetricsProvider = Provider<List<EconomicLeakageMetric>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  return repo.getEconomicLeakageMetrics();
});

class SmeProvidersNotifier extends StateNotifier<List<SmeProvider>> {
  final TourismRepository _repo;

  SmeProvidersNotifier(this._repo) : super(_repo.getSmeProviders());

  void registerSme(SmeProvider provider) {
    _repo.addSmeProvider(provider);
    state = List.from(_repo.getSmeProviders());
  }
}

final smeProvidersProvider = StateNotifierProvider<SmeProvidersNotifier, List<SmeProvider>>((ref) {
  final repo = ref.watch(tourismRepositoryProvider);
  return SmeProvidersNotifier(repo);
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
