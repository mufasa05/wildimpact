import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../../core/widgets/safari_glow_button.dart';
import 'offset_checkout_dialog.dart';

class GuestMobileSimulatorScreen extends ConsumerStatefulWidget {
  const GuestMobileSimulatorScreen({super.key});

  @override
  ConsumerState<GuestMobileSimulatorScreen> createState() => _GuestMobileSimulatorScreenState();
}

class _GuestMobileSimulatorScreenState extends ConsumerState<GuestMobileSimulatorScreen> {
  int _phoneNavIndex = 2; // Default to 'Impact' tab as shown in poster
  double _tripCo2 = 0.45;
  double _tripDonation = 25.0;
  final int _communitiesCount = 1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isRealPhone = screenWidth < 500;

    return Container(
      color: EcoColors.obsidianBg,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: isRealPhone ? 12 : 24,
            horizontal: isRealPhone ? 8 : 16,
          ),
          child: Column(
            children: [
              // Top descriptive bar
              if (!isRealPhone)
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: EcoColors.darkCardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: EcoColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.smartphone_rounded, color: EcoColors.mintAccent, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'GUEST MOBILE APP SIMULATOR',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: EcoColors.mintAccent,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '• Live Safari Guest Portal Preview',
                        style: TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight),
                      ),
                    ],
                  ),
                ),

              // Phone Device Mockup Container
              Container(
                width: isRealPhone ? double.infinity : 380,
                height: 720,
                constraints: BoxConstraints(
                  maxWidth: isRealPhone ? double.infinity : 380,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF14241C),
                  borderRadius: BorderRadius.circular(isRealPhone ? 20 : 44),
                  border: isRealPhone
                      ? Border.all(color: EcoColors.cardBorder, width: 1.5)
                      : Border.all(color: const Color(0xFF2C5542), width: 6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.7),
                      blurRadius: isRealPhone ? 16 : 36,
                      spreadRadius: isRealPhone ? 2 : 8,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: EcoColors.emeraldPrimary.withValues(alpha: 0.15),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isRealPhone ? 18 : 38),
                  child: Stack(
                    children: [
                      // Background
                      Container(
                        color: const Color(0xFF0C1712),
                      ),

                      // Phone Top Notch / Dynamic Island
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '3:31',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.signal_cellular_alt_rounded, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Icon(Icons.wifi_rounded, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Icon(Icons.battery_full_rounded, size: 12, color: Colors.white),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Phone Screen Content
                      Positioned.fill(
                        top: 36,
                        bottom: 60,
                        child: _buildPhoneTabContent(),
                      ),

                      // Phone Bottom Navigation Bar
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _buildPhoneBottomNav(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneTabContent() {
    switch (_phoneNavIndex) {
      case 0:
        return _buildPhoneHomeTab();
      case 1:
        return _buildPhoneTripsTab();
      case 2:
        return _buildPhoneImpactTab(); // The exact poster view!
      case 3:
        return _buildPhoneProfileTab();
      default:
        return _buildPhoneImpactTab();
    }
  }

  Widget _buildPhoneImpactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Greetings
          Center(
            child: Column(
              children: const [
                Text(
                  'Your Impact Matters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: EcoColors.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Thank you for making a difference!',
                  style: TextStyle(
                    fontSize: 12,
                    color: EcoColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // "Your Trip Impact" Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF132A20),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: EcoColors.emeraldPrimary.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Trip Impact',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: EcoColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 12),

                // 3 Stats items
                _buildTripImpactRow(
                  icon: Icons.cloud_outlined,
                  iconColor: EcoColors.mintAccent,
                  label: 'CO₂ Offset',
                  value: '$_tripCo2 tCO₂e',
                ),
                const Divider(color: EcoColors.cardBorder, height: 16),
                _buildTripImpactRow(
                  icon: Icons.shield_outlined,
                  iconColor: EcoColors.savannaGold,
                  label: 'Conservation Funded',
                  value: '\$${_tripDonation.toStringAsFixed(0)}',
                ),
                const Divider(color: EcoColors.cardBorder, height: 16),
                _buildTripImpactRow(
                  icon: Icons.groups_outlined,
                  iconColor: EcoColors.terracotta,
                  label: 'Communities Supported',
                  value: '$_communitiesCount',
                ),
                const SizedBox(height: 16),

                // "View Impact Story" Button
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF24583E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    onPressed: () => _showImpactStoryDialog(context),
                    child: const Text(
                      'View Impact Story',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // "Live Impact Feed"
          const Text(
            'Live Impact Feed',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: EcoColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 10),

          // Card 1: Ranger Patrol Funded
          _buildImpactFeedCard(
            icon: Icons.shield_rounded,
            iconColor: EcoColors.mintAccent,
            title: 'Ranger Patrol Funded',
            subtitle: '2 hours of anti-poaching patrol in Hwange NP',
            timeAgo: '2h ago',
            imageUrl: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=400&q=80',
          ),
          const SizedBox(height: 10),

          // Card 2: Community Project
          _buildImpactFeedCard(
            icon: Icons.water_drop_rounded,
            iconColor: EcoColors.savannaGold,
            title: 'Community Project',
            subtitle: 'Clean water borehole in Nyaminyami Village',
            timeAgo: '1d ago',
            imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=400&q=80',
          ),
          const SizedBox(height: 10),

          // Card 3: Habitat Restoration
          _buildImpactFeedCard(
            icon: Icons.park_rounded,
            iconColor: EcoColors.emeraldPrimary,
            title: 'Habitat Restoration',
            subtitle: '40 native teak saplings planted in Gwayi buffer',
            timeAgo: '3d ago',
            imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?auto=format&fit=crop&w=400&q=80',
          ),
          const SizedBox(height: 14),

          // Quick boost button
          Center(
            child: TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => OffsetCheckoutDialog(
                    defaultTonnes: 1.0,
                    onPurchaseSuccess: (purchase) {
                      setState(() {
                        _tripCo2 += purchase.tonnes;
                        _tripDonation += purchase.amountPaid;
                      });
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline_rounded, color: EcoColors.mintAccent, size: 16),
              label: const Text(
                'Boost My Safari Offset (+1 Tonne)',
                style: TextStyle(color: EcoColors.mintAccent, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripImpactRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: EcoColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildImpactFeedCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String timeAgo,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF10221A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EcoColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: EcoColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: const TextStyle(fontSize: 10, color: EcoColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(width: 44, height: 44, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome, Safari Explorer! 🦁', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 6),
          const Text('Hwange Safari Lodge & Wilderness Sanctuary', style: TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight)),
          const SizedBox(height: 16),
          Container(
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFF132A20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=600&q=80',
                width: double.infinity,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  color: const Color(0xFF132A20),
                  alignment: Alignment.center,
                  child: const Icon(Icons.park_rounded, color: EcoColors.mintAccent, size: 36),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Your Active Safari Itinerary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 8),
          _buildTripCard('Sunrise Game Drive • Sector 7', 'Tomorrow, 05:30 AM', 'Confirmed'),
          const SizedBox(height: 8),
          _buildTripCard('CAMPFIRE Cultural Village Walk', 'May 31, 02:00 PM', 'Levy Included'),
        ],
      ),
    );
  }

  Widget _buildPhoneTripsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Eco-Safaris', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 12),
          _buildTripCard('Zambezi Explorer Tour (4 Days)', 'Completed • 0.85 tCO₂e Offset', 'Certificate Issued'),
          const SizedBox(height: 10),
          _buildTripCard('Hwange Big 5 Photography Expedition', 'Current Stay • Eco-Contribution \$25', 'Active'),
        ],
      ),
    );
  }

  Widget _buildPhoneProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: EcoColors.mintAccent, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  color: EcoColors.emeraldPrimary.withValues(alpha: 0.2),
                  alignment: Alignment.center,
                  child: const Icon(Icons.person_rounded, color: EcoColors.mintAccent, size: 36),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Elena Rostova', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
          const Text('Tier 2 Eco-Guardian • Sweden', style: TextStyle(fontSize: 11.5, color: EcoColors.mintAccent)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF132A20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Column(children: [Text('2.6 t', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)), Text('Lifetime Offset', style: TextStyle(fontSize: 10, color: EcoColors.textMuted))]),
                Column(children: [Text('\$57.50', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: EcoColors.savannaGold)), Text('Funded', style: TextStyle(fontSize: 10, color: EcoColors.textMuted))]),
                Column(children: [Text('3', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: EcoColors.mintAccent)), Text('Badges', style: TextStyle(fontSize: 10, color: EcoColors.textMuted))]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(String title, String sub, String badge) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF12241B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EcoColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 2),
                Text(sub, style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight)),
              ],
            ),
          ),
          EcoBadge(text: badge, fontSize: 9.5),
        ],
      ),
    );
  }

  Widget _buildPhoneBottomNav() {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFF09140F),
        border: Border(top: BorderSide(color: Color(0xFF1B382B), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPhoneNavItem(0, Icons.home_rounded, 'Home'),
          _buildPhoneNavItem(1, Icons.explore_rounded, 'Trips'),
          _buildPhoneNavItem(2, Icons.eco_rounded, 'Impact'),
          _buildPhoneNavItem(3, Icons.person_rounded, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildPhoneNavItem(int index, IconData icon, String label) {
    final isSelected = _phoneNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _phoneNavIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? EcoColors.mintAccent : EcoColors.textMuted,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? EcoColors.mintAccent : EcoColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _showImpactStoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0E2219),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: EcoColors.emeraldPrimary.withValues(alpha: 0.6)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Your Safari Impact Story', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=600&q=80',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Because of your visit, Nyaminyami Village received reliable, solar-pumped clean drinking water. Rangers also completed 2 hours of foot patrols, keeping elephants safely away from crops.',
                  style: TextStyle(fontSize: 12.5, color: EcoColors.textSecondaryLight, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SafariGlowButton(
                  text: 'Share My Impact Badge',
                  icon: Icons.share_rounded,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Impact Badge copied to clipboard!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
