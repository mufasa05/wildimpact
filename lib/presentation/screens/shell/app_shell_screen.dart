import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/app_shell_header.dart';
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
import '../guest/tourist_home_screen.dart';
import '../guest/tourist_explore_screen.dart';
import '../guest/tourist_ai_assistant_screen.dart';
import '../guest/tourist_bookings_screen.dart';
import '../guest/tourist_translator_screen.dart';
import '../guest/tourist_favourites_screen.dart';
import '../guest/tourist_about_zim_screen.dart';
import '../guest/tourist_settings_screen.dart';
import '../guest/carbon_calculator_screen.dart';
import '../guest/impact_passport_screen.dart';
import '../guest/gamification_badges_screen.dart';
import '../guest/guest_mobile_simulator_screen.dart';

class AppShellScreen extends ConsumerStatefulWidget {
  const AppShellScreen({super.key});

  @override
  ConsumerState<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends ConsumerState<AppShellScreen> {
  int _touristTabIndex = 0;
  int _operatorTabIndex = 0;
  int _rangerTabIndex = 0;
  int _ztaTabIndex = 0;
  int _smeTabIndex = 0;
  int _heritageTabIndex = 0;
  String? _aiSearchQuery;

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(activeRoleProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? EcoColors.obsidianBg : EcoColors.lightBg,
      appBar: const AppShellHeader(),
      body: Row(
        children: [
          // Sidebar Nav
          if (isDesktop) _buildSidebar(role, isDark),

          // Main Screen Body
          Expanded(
            child: _buildActiveScreen(role),
          ),
        ],
      ),
      drawer: !isDesktop ? Drawer(child: _buildSidebar(role, isDark, isDrawer: true)) : null,
      bottomNavigationBar: !isDesktop ? _buildBottomNav(role, isDark) : null,
    );
  }

  Widget _buildActiveScreen(UserRole role) {
    switch (role) {
      case UserRole.tourist:
      case UserRole.guest:
        switch (_touristTabIndex) {
          case 0:
            return TouristHomeScreen(
              onNavigateTouristTab: (idx) => setState(() => _touristTabIndex = idx),
              onSearchAi: (query) {
                setState(() {
                  _aiSearchQuery = query;
                  _touristTabIndex = 2; // AI tab
                });
              },
            );
          case 1:
            return TouristExploreScreen(
              onNavigateTouristTab: (idx) => setState(() => _touristTabIndex = idx),
            );
          case 2:
            return TouristAiAssistantScreen(
              initialQuery: _aiSearchQuery,
              onNavigateTouristTab: (idx) => setState(() => _touristTabIndex = idx),
            );
          case 3:
            return TouristBookingsScreen(
              onNavigateTouristTab: (idx) => setState(() => _touristTabIndex = idx),
            );
          case 4:
            return const TouristTranslatorScreen();
          case 5:
            return CarbonCalculatorScreen(
              onNavigateGuestTab: (idx) => setState(() => _touristTabIndex = idx),
            );
          case 6:
            return const ImpactPassportScreen();
          case 7:
            return const GamificationBadgesScreen();
          case 8:
            return TouristFavouritesScreen(
              onNavigateTouristTab: (idx) => setState(() => _touristTabIndex = idx),
            );
          case 9:
            return const TouristAboutZimScreen();
          case 10:
            return const TouristSettingsScreen();
          default:
            return TouristHomeScreen(
              onNavigateTouristTab: (idx) => setState(() => _touristTabIndex = idx),
            );
        }

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
          default:
            return OperatorOverviewScreen(onNavigateTab: (idx) => setState(() => _operatorTabIndex = idx));
        }

      case UserRole.ranger:
        switch (_rangerTabIndex) {
          case 0:
            return const GeospatialRadarScreen();
          case 1:
            return const ConservationManagerScreen();
          case 2:
            return const EsgReportingScreen();
          default:
            return const GeospatialRadarScreen();
        }

      case UserRole.nationalZta:
        switch (_ztaTabIndex) {
          case 0:
            return const NationalIntelligenceScreen();
          case 1:
            return const EsgReportingScreen();
          case 2:
            return const ContributionsLedgerScreen();
          default:
            return const NationalIntelligenceScreen();
        }

      case UserRole.providerPortal:
        switch (_smeTabIndex) {
          case 0:
            return const ProviderOnboardingScreen();
          case 1:
            return const UniversalAccessibilityScreen();
          case 2:
            return const ContributionsLedgerScreen();
          default:
            return const ProviderOnboardingScreen();
        }

      case UserRole.culturalHeritage:
        switch (_heritageTabIndex) {
          case 0:
            return const CulturalHeritageScreen();
          case 1:
            return const ContributionsLedgerScreen();
          default:
            return const CulturalHeritageScreen();
        }

      case UserRole.accessibility:
        return const UniversalAccessibilityScreen();
    }
  }

  Widget _buildSidebar(UserRole role, bool isDark, {bool isDrawer = false}) {
    final profile = ref.watch(currentUserProfileProvider);

    List<Map<String, dynamic>> items;
    int currentIndex;
    String headerTitle;

    switch (role) {
      case UserRole.tourist:
      case UserRole.guest:
        headerTitle = 'TOURIST & TRAVELER';
        currentIndex = _touristTabIndex;
        items = [
          {'icon': Icons.home_rounded, 'label': 'Home'},
          {'icon': Icons.explore_rounded, 'label': 'Explore'},
          {'icon': Icons.chat_bubble_outline_rounded, 'label': 'AI Assistant'},
          {'icon': Icons.calendar_today_rounded, 'label': 'Bookings'},
          {'icon': Icons.translate_rounded, 'label': 'Live Translator'},
          {'icon': Icons.calculate_rounded, 'label': 'Carbon & Offsets'},
          {'icon': Icons.badge_rounded, 'label': 'Impact Passport'},
          {'icon': Icons.military_tech_rounded, 'label': 'Badges & Ranks'},
          {'icon': Icons.favorite_border_rounded, 'label': 'Favourites'},
          {'icon': Icons.info_outline_rounded, 'label': 'About Zimbabwe'},
          {'icon': Icons.settings_outlined, 'label': 'Settings'},
        ];
        break;

      case UserRole.operator:
        headerTitle = 'SAFARI LODGE HUB';
        currentIndex = _operatorTabIndex;
        items = [
          {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
          {'icon': Icons.luggage_rounded, 'label': 'Bookings'},
          {'icon': Icons.radar_rounded, 'label': 'Impact Tracking'},
          {'icon': Icons.paid_rounded, 'label': 'Contributions'},
          {'icon': Icons.nature_people_rounded, 'label': 'Projects'},
          {'icon': Icons.description_rounded, 'label': 'Reports'},
          {'icon': Icons.eco_rounded, 'label': 'Carbon Offsets'},
          {'icon': Icons.smartphone_rounded, 'label': 'Guest Mobile App'},
        ];
        break;

      case UserRole.ranger:
        headerTitle = 'RANGER & PATROL';
        currentIndex = _rangerTabIndex;
        items = [
          {'icon': Icons.shield_moon_rounded, 'label': 'Anti-Poaching Radar'},
          {'icon': Icons.nature_people_rounded, 'label': 'Patrol & Snare Log'},
          {'icon': Icons.satellite_alt_rounded, 'label': 'NDVI & Health Index'},
        ];
        break;

      case UserRole.nationalZta:
        headerTitle = 'NATIONAL TOURISM BOARD';
        currentIndex = _ztaTabIndex;
        items = [
          {'icon': Icons.analytics_rounded, 'label': 'National Intelligence'},
          {'icon': Icons.price_check_rounded, 'label': 'Economic Leakage Index'},
          {'icon': Icons.verified_rounded, 'label': 'ESG Verification Audit'},
        ];
        break;

      case UserRole.providerPortal:
        headerTitle = 'SME & ARTISAN PORTAL';
        currentIndex = _smeTabIndex;
        items = [
          {'icon': Icons.handshake_rounded, 'label': 'Supplier Onboarding'},
          {'icon': Icons.storefront_rounded, 'label': 'Community Marketplace'},
          {'icon': Icons.payments_rounded, 'label': 'Verified Payouts'},
        ];
        break;

      case UserRole.culturalHeritage:
        headerTitle = 'LIVING HERITAGE';
        currentIndex = _heritageTabIndex;
        items = [
          {'icon': Icons.record_voice_over_rounded, 'label': 'Oral Folklore Registry'},
          {'icon': Icons.account_balance_wallet_rounded, 'label': 'Elder Royalties Ledger'},
        ];
        break;

      default:
        headerTitle = 'WORKSPACE';
        currentIndex = 0;
        items = [
          {'icon': Icons.accessible_rounded, 'label': 'Universal Routes'},
        ];
    }

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: isDark ? EcoColors.darkCardBg : const Color(0xFF0F261E),
        border: Border(
          right: BorderSide(
            color: isDark ? EcoColors.cardBorder : Colors.white12,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Text(
              headerTitle,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: EcoColors.mintAccent,
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Items List
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 2),
              itemBuilder: (context, idx) {
                final item = items[idx];
                final isSelected = currentIndex == idx;

                return InkWell(
                  onTap: () {
                    setState(() {
                      switch (role) {
                        case UserRole.tourist:
                          _touristTabIndex = idx;
                          break;
                        case UserRole.operator:
                          _operatorTabIndex = idx;
                          break;
                        case UserRole.ranger:
                          _rangerTabIndex = idx;
                          break;
                        case UserRole.nationalZta:
                          _ztaTabIndex = idx;
                          break;
                        case UserRole.providerPortal:
                          _smeTabIndex = idx;
                          break;
                        case UserRole.culturalHeritage:
                          _heritageTabIndex = idx;
                          break;
                        default:
                          break;
                      }
                    });
                    if (isDrawer) Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? EcoColors.emeraldPrimary.withValues(alpha: 0.18) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected ? Border.all(color: EcoColors.emeraldPrimary.withValues(alpha: 0.5)) : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 18,
                          color: isSelected ? EcoColors.mintAccent : Colors.white60,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.white70,
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

          // User Profile Bottom Pill (Mufasa / Active User)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? EcoColors.cardBorder : Colors.white12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: EcoColors.savannaGold,
                  child: Text(
                    profile.fullName.isNotEmpty ? profile.fullName[0] : 'M',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        profile.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      Text(
                        profile.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 9.5, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Sign Out',
                  icon: const Icon(Icons.logout_rounded, size: 16, color: Colors.white54),
                  onPressed: () {
                    ref.read(currentUserProfileProvider.notifier).signOut();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(UserRole role, bool isDark) {
    if (role == UserRole.tourist || role == UserRole.guest) {
      return BottomNavigationBar(
        currentIndex: _touristTabIndex.clamp(0, 4),
        onTap: (idx) => setState(() => _touristTabIndex = idx),
        backgroundColor: isDark ? EcoColors.darkCardBg : Colors.white,
        selectedItemColor: EcoColors.emeraldPrimary,
        unselectedItemColor: isDark ? Colors.white54 : Colors.black54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'AI'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.translate_rounded), label: 'Translator'),
        ],
      );
    }

    if (role == UserRole.operator) {
      return BottomNavigationBar(
        currentIndex: _operatorTabIndex.clamp(0, 4),
        onTap: (idx) => setState(() => _operatorTabIndex = idx),
        backgroundColor: isDark ? EcoColors.darkCardBg : Colors.white,
        selectedItemColor: EcoColors.emeraldPrimary,
        unselectedItemColor: isDark ? Colors.white54 : Colors.black54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.luggage_rounded), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.radar_rounded), label: 'Radar'),
          BottomNavigationBarItem(icon: Icon(Icons.paid_rounded), label: 'Ledger'),
          BottomNavigationBarItem(icon: Icon(Icons.nature_people_rounded), label: 'Projects'),
        ],
      );
    }

    return BottomNavigationBar(
      currentIndex: 0,
      backgroundColor: isDark ? EcoColors.darkCardBg : Colors.white,
      selectedItemColor: EcoColors.emeraldPrimary,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.shield_moon_rounded), label: 'Command'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
      ],
    );
  }
}
