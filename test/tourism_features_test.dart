import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wildimpact/data/tourism_repository.dart';
import 'package:wildimpact/presentation/providers/tourism_providers.dart';

void main() {
  group('WildImpact Tourism Platform Tests', () {
    late TourismRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = TourismRepository();
      container = ProviderContainer(
        overrides: [
          tourismRepositoryProvider.overrideWithValue(repository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial Lodges and Projects Load Accurately', () {
      final lodges = container.read(allLodgesProvider);
      expect(lodges.length, greaterThanOrEqualTo(3));
      expect(lodges.first.name, contains('Hwange Safari Lodge'));

      final projects = container.read(conservationProjectsProvider);
      expect(projects.length, greaterThanOrEqualTo(3));
      expect(projects.any((p) => p.name.contains('Anti-Poaching')), isTrue);
    });

    test('Adding a Conservation Milestone auto-increments currentMetric and prepends milestone', () {
      final notifier = container.read(conservationProjectsProvider.notifier);
      final initialProjects = container.read(conservationProjectsProvider);
      final targetProject = initialProjects.first;
      final initialMetric = targetProject.currentMetric;

      notifier.addMilestone(
        projectId: targetProject.id,
        title: 'Sector 7 Snare Sweep Completed',
        description: 'Patrolled 50km with K9 unit, zero snares found.',
        metricDelta: 50.0,
        latitude: -18.732,
        longitude: 26.953,
        verifiedBy: 'Chief Ranger Sibanda',
      );

      final updatedProjects = container.read(conservationProjectsProvider);
      final updatedProject = updatedProjects.firstWhere((p) => p.id == targetProject.id);

      expect(updatedProject.currentMetric, equals(initialMetric + 50.0));
      expect(updatedProject.milestones.first.title, equals('Sector 7 Snare Sweep Completed'));
      expect(updatedProject.milestones.first.verifiedBy, equals('Chief Ranger Sibanda'));
    });

    test('Carbon Offset Purchase calculates CAMPFIRE community split & generates certificate', () {
      final offsetProjects = container.read(carbonOffsetProjectsProvider);
      final project = offsetProjects.first;
      final initialRemaining = project.remainingCapacity;

      final purchaseNotifier = container.read(purchasesProvider.notifier);
      final purchase = purchaseNotifier.purchaseOffset(
        offsetProjectId: project.id,
        touristName: 'Elena Rostova',
        touristEmail: 'elena@safari.org',
        tonnes: 2.0,
        paymentMethod: 'PAYNOW (EcoCash)',
      );

      expect(purchase.tonnes, equals(2.0));
      expect(purchase.amountPaid, equals(2.0 * project.pricePerTonne));
      expect(purchase.campfireShare, equals(purchase.amountPaid * (project.zimbabweCampfirePct / 100)));
      expect(purchase.certificateCode, startsWith('WI-ZW-'));

      final allPurchases = container.read(purchasesProvider);
      expect(allPurchases.contains(purchase), isTrue);

      expect(project.remainingCapacity, equals(initialRemaining - 2.0));
    });

    test('Switching User Role toggles activeRoleProvider state correctly', () {
      expect(container.read(activeRoleProvider), equals(UserRole.operator));

      container.read(activeRoleProvider.notifier).state = UserRole.guest;
      expect(container.read(activeRoleProvider), equals(UserRole.guest));

      container.read(activeRoleProvider.notifier).state = UserRole.tourismBoard;
      expect(container.read(activeRoleProvider), equals(UserRole.tourismBoard));
    });

    test('Switching Lodge updates selectedLodgeProvider context', () {
      expect(container.read(selectedLodgeProvider).id, equals('hwange-safari-lodge'));

      container.read(selectedLodgeIdProvider.notifier).state = 'vic-falls-river-lodge';
      expect(container.read(selectedLodgeProvider).name, contains('Victoria Falls'));
    });
  });
}
