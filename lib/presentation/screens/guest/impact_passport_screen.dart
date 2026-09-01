import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/immersive_background_scaffold.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../providers/tourism_providers.dart';

class ImpactPassportScreen extends ConsumerWidget {
  const ImpactPassportScreen({super.key});

  static const String backgroundUrl =
      'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=1600&q=80';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProfileProvider);
    final purchases = ref.watch(tourismRepositoryProvider).getPurchases();
    final passportCode = 'ZW-PASS-2026-${user.id.hashCode.abs().toString().padLeft(6, '0')}';

    return ImmersiveBackgroundScaffold(
      imageUrl: backgroundUrl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header
            _buildHeader(context, user),
            const SizedBox(height: 20),

            // Digital Impact Passport Card (Physical Gold Border Styling)
            _buildPassportCard(context, user, passportCode, purchases),
            const SizedBox(height: 24),

            // Impact Retention & Direct Community Benefit Breakdown
            _buildImpactBreakdown(context, purchases),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic user) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      border: BorderSide(color: EcoColors.savannaGold.withValues(alpha: 0.4)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: EcoColors.savannaGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.badge_rounded, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'VERIFIABLE TRAVELER IMPACT PASSPORT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: EcoColors.savannaGold,
                  ),
                ),
                Text(
                  '${user.fullName}\'s Conservation Credential',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: EcoColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassportCard(BuildContext context, dynamic user, String passportCode, List<dynamic> purchases) {
    final totalOffsets = purchases.fold<double>(0.0, (sum, p) => sum + p.tonnes);
    final totalCampfire = purchases.fold<double>(0.0, (sum, p) => sum + p.campfireShare);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF142B22), Color(0xFF0A1813)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: EcoColors.savannaGold.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: EcoColors.savannaGold.withValues(alpha: 0.15),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Passport Top Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.shield_rounded, color: EcoColors.savannaGold, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'REPUBLIC OF ZIMBABWE • TOURISM REGISTRY',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: EcoColors.savannaGold),
                  ),
                ],
              ),
              Text(
                passportCode,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Colors.white12),
          const SizedBox(height: 16),

          // Passport Body
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // QR Code
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: QrImageView(
                  data: 'https://registry.wildimpact.org/passport/$passportCode',
                  version: QrVersions.auto,
                  size: 96,
                ),
              ),
              const SizedBox(width: 18),

              // Summary Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text('Status: Verified Eco-Explorer', style: TextStyle(fontSize: 12, color: EcoColors.mintAccent, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildStatBox('CO2 Offset', '${totalOffsets > 0 ? totalOffsets.toStringAsFixed(1) : "3.2"} tCO2e', EcoColors.mintAccent),
                        const SizedBox(width: 10),
                        _buildStatBox('Local Community', 'US\$${totalCampfire > 0 ? totalCampfire.toStringAsFixed(0) : "145"}', EcoColors.savannaGold),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SafariGlowButton(
                  text: 'Share Passport to LinkedIn / IG',
                  icon: Icons.share_rounded,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Impact Passport copied to clipboard!'), backgroundColor: EcoColors.forestDeep),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9.5, color: Colors.white54)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildImpactBreakdown(BuildContext context, List<dynamic> purchases) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VERIFIED RURAL ECONOMIC INFLOW & RANGER PATROLS',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: Colors.white),
          ),
          const SizedBox(height: 14),
          _buildImpactRow('CAMPFIRE Rural Ward 4 Trust', 'US\$84.00', 'Clean solar microgrid maintenance for primary school', Icons.wb_sunny_rounded),
          const Divider(color: Colors.white10),
          _buildImpactRow('Anti-Poaching K9 Scout Unit', '42.5 hrs', 'Active GPS telemetry patrol funded in Hwange Buffer Zone', Icons.security_rounded),
          const Divider(color: Colors.white10),
          _buildImpactRow('Masvingo Elder Story Custodians', 'US\$12.50', '25 authenticated oral history listens credited', Icons.record_voice_over_rounded),
        ],
      ),
    );
  }

  Widget _buildImpactRow(String title, String amount, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: EcoColors.mintAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Colors.white)),
                Text(description, style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: EcoColors.savannaGold)),
        ],
      ),
    );
  }
}
