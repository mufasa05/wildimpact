import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/role_selector_app_bar.dart';
import '../../providers/tourism_providers.dart';
import '../intelligence/national_intelligence_screen.dart';
import '../heritage/cultural_heritage_screen.dart';
import '../accessibility/universal_accessibility_screen.dart';
import '../providers/provider_onboarding_screen.dart';
import '../operator/operator_overview_screen.dart';
import '../operator/bookings_screen.dart';
import '../operator/contributions_ledger_screen.dart';
import '../operator/conservation_manager_screen.dart';
import '../operator/geospatial_radar_screen.dart';
import '../operator/offset_admin_screen.dart';
import '../operator/esg_reporting_screen.dart';
import '../guest/guest_welcome_screen.dart';
import '../guest/guest_mobile_simulator_screen.dart';
import '../guest/carbon_calculator_screen.dart';
import '../guest/impact_passport_screen.dart';
import '../guest/gamification_badges_screen.dart';
import '../showcase/platform_showcase_screen.dart';

class AppShellScreen extends ConsumerStatefulWidget {
  const AppShellScreen({super.key});

  @override
  ConsumerState<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends ConsumerState<AppShellScreen> {
  int _operatorTabIndex = 0;
  int _guestTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(activeRoleProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final hasSidebar = isDesktop && (role == UserRole.operator || role == UserRole.guest);

    return Scaffold(
      backgroundColor: EcoColors.obsidianBg,
      appBar: const RoleSelectorAppBar(),
      body: Row(
        children: [
          // Sidebar Nav for Operator & Guest multi-tab modules
          if (hasSidebar) _buildSidebar(role),

          // Main Screen Body
          Expanded(
            child: _buildActiveScreen(role),
          ),
        ],
      ),
      bottomNavigationBar: !isDesktop && (role == UserRole.operator || role == UserRole.guest)
          ? _buildBottomNav(role)
          : null,
    );
  }

  Widget _buildActiveScreen(UserRole role) {
    switch (role) {
      case UserRole.nationalZta:
        return const NationalIntelligenceScreen();

      case UserRole.culturalHeritage:
        return const CulturalHeritageScreen();

      case UserRole.accessibility:
        return const UniversalAccessibilityScreen();

      case UserRole.providerPortal:
        return const ProviderOnboardingScreen();

      case UserRole.operator:
        switch (_operatorTabIndex) {
          case 0:
            return OperatorOverviewScreen(onNavigateTab: (idx) => setState(() => _operatorTabIndex = idx));
          case 1:
            return const BookingsScreen();
          case 2:
            return const GeospatialRadarScreen();
          case 3:
            return const ContributionsLedgerScreen();
          case 4:
            return const ConservationManagerScreen();
          case 5:
            return const EsgReportingScreen();
          case 6:
            return const OffsetAdminScreen();
          case 7:
            return const GuestMobileSimulatorScreen();
          case 8:
            return PlatformShowcaseScreen(onNavigateTab: (idx) => setState(() => _operatorTabIndex = idx));
          default:
            return OperatorOverviewScreen(onNavigateTab: (idx) => setState(() => _operatorTabIndex = idx));
        }

      case UserRole.guest:
        switch (_guestTabIndex) {
          case 0:
            return GuestWelcomeScreen(onNavigateGuestTab: (idx) => setState(() => _guestTabIndex = idx));
          case 1:
            return const GuestMobileSimulatorScreen();
          case 2:
            return CarbonCalculatorScreen(onNavigateGuestTab: (idx) => setState(() => _guestTabIndex = idx));
          case 3:
            return const ImpactPassportScreen();
          case 4:
            return const GamificationBadgesScreen();
          default:
            return GuestWelcomeScreen(onNavigateGuestTab: (idx) => setState(() => _guestTabIndex = idx));
        }

      case UserRole.platformShowcase:
        return PlatformShowcaseScreen(
          onNavigateTab: (idx) {
            ref.read(activeRoleProvider.notifier).state = UserRole.operator;
            setState(() => _operatorTabIndex = idx);
          },
        );
    }
  }

  Widget _buildSidebar(UserRole role) {
    final items = role == UserRole.operator
        ? [
            {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
            {'icon': Icons.luggage_rounded, 'label': 'Bookings'},
            {'icon': Icons.radar_rounded, 'label': 'Impact Tracking'},
            {'icon': Icons.paid_rounded, 'label': 'Contributions'},
            {'icon': Icons.nature_people_rounded, 'label': 'Projects'},
            {'icon': Icons.description_rounded, 'label': 'Reports'},
            {'icon': Icons.eco_rounded, 'label': 'Carbon Offsets'},
            {'icon': Icons.smartphone_rounded, 'label': 'Guest Mobile App'},
            {'icon': Icons.auto_awesome_rounded, 'label': 'Platform Showcase'},
          ]
        : [
            {'icon': Icons.wb_sunny_rounded, 'label': 'Live Safari Impact'},
            {'icon': Icons.smartphone_rounded, 'label': 'Mobile App Simulator'},
            {'icon': Icons.calculate_rounded, 'label': 'Carbon Calculator'},
            {'icon': Icons.badge_rounded, 'label': 'Impact Passport'},
            {'icon': Icons.military_tech_rounded, 'label': 'Badges & Ranks'},
          ];

    final currentIndex = role == UserRole.operator ? _operatorTabIndex : _guestTabIndex;

    return Container(
      width: 235,
      decoration: const BoxDecoration(
        color: EcoColors.darkCardBg,
        border: Border(right: BorderSide(color: EcoColors.cardBorder, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Text(
              role == UserRole.operator ? 'OPERATOR COMMAND' : 'GUEST EXPERIENCE',
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: EcoColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 3),
              itemBuilder: (context, idx) {
                final item = items[idx];
                final isSelected = currentIndex == idx;

                return InkWell(
                  onTap: () {
                    setState(() {
                      if (role == UserRole.operator) {
                        _operatorTabIndex = idx;
                      } else {
                        _guestTabIndex = idx;
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? EcoColors.emeraldPrimary.withValues(alpha: 0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected ? Border.all(color: EcoColors.emeraldPrimary.withValues(alpha: 0.4)) : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 18,
                          color: isSelected ? EcoColors.mintAccent : EcoColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? EcoColors.textPrimaryLight : EcoColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Footer info
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: EcoColors.cardBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_moon_rounded, color: EcoColors.savannaGold, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ZCR & CAMPFIRE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight)),
                      Text('100% Impact Verified', style: TextStyle(fontSize: 9.5, color: EcoColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(UserRole role) {
    if (role == UserRole.operator) {
      return BottomNavigationBar(
        currentIndex: _operatorTabIndex.clamp(0, 4),
        onTap: (idx) => setState(() => _operatorTabIndex = idx),
        backgroundColor: EcoColors.darkCardBg,
        selectedItemColor: EcoColors.mintAccent,
        unselectedItemColor: EcoColors.textMuted,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.luggage_rounded), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.radar_rounded), label: 'Radar'),
          BottomNavigationBarItem(icon: Icon(Icons.paid_rounded), label: 'Funds'),
          BottomNavigationBarItem(icon: Icon(Icons.nature_people_rounded), label: 'Projects'),
        ],
      );
    }

    return BottomNavigationBar(
      currentIndex: _guestTabIndex.clamp(0, 4),
      onTap: (idx) => setState(() => _guestTabIndex = idx),
      backgroundColor: EcoColors.darkCardBg,
      selectedItemColor: EcoColors.mintAccent,
      unselectedItemColor: EcoColors.textMuted,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.wb_sunny_rounded), label: 'Impact'),
        BottomNavigationBarItem(icon: Icon(Icons.smartphone_rounded), label: 'App'),
        BottomNavigationBarItem(icon: Icon(Icons.calculate_rounded), label: 'Carbon'),
        BottomNavigationBarItem(icon: Icon(Icons.badge_rounded), label: 'Passport'),
        BottomNavigationBarItem(icon: Icon(Icons.military_tech_rounded), label: 'Badges'),
      ],
    );
  }
}
