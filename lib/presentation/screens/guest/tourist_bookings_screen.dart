import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';

class TouristBookingsScreen extends ConsumerStatefulWidget {
  final Function(int)? onNavigateTouristTab;
  const TouristBookingsScreen({super.key, this.onNavigateTouristTab});

  @override
  ConsumerState<TouristBookingsScreen> createState() => _TouristBookingsScreenState();
}

class _TouristBookingsScreenState extends ConsumerState<TouristBookingsScreen> {

  final List<Map<String, dynamic>> _bookings = [
    {
      'id': 'BK-ZW-2026-8812',
      'title': 'Eco-Impact Safari Conservancy (Hwange Safari Lodge)',
      'type': 'Lodge Stay & Game Drive',
      'dates': '14 Oct 2026 – 18 Oct 2026 (4 Nights)',
      'guests': '2 Adults (Mufasa & Guest)',
      'status': 'Confirmed',
      'statusColor': EcoColors.success,
      'totalUsd': 940.00,
      'campfireShareUsd': 188.00,
      'rangersFundedHours': 12,
      'carbonOffsetTonnes': 1.8,
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=600&q=80',
    },
    {
      'id': 'BK-ZW-2026-5531',
      'title': 'Mana Pools UNESCO Walking & Canoe Expedition',
      'type': 'Guided Wilderness Trek',
      'dates': '22 Oct 2026 (Full Day)',
      'guests': '2 Explorers',
      'status': 'Active Next Week',
      'statusColor': EcoColors.savannaGold,
      'totalUsd': 320.00,
      'campfireShareUsd': 64.00,
      'rangersFundedHours': 8,
      'carbonOffsetTonnes': 0.6,
      'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=600&q=80',
    },
    {
      'id': 'BK-ZW-2026-1049',
      'title': 'Great Zimbabwe National Monument & Museum Pass',
      'type': 'ZimParks Heritage Entry',
      'dates': '05 Sep 2026 (Valid 3 Days)',
      'guests': '1 Traveler (Mufasa)',
      'status': 'Completed',
      'statusColor': EcoColors.mintAccent,
      'totalUsd': 25.00,
      'campfireShareUsd': 5.00,
      'rangersFundedHours': 2,
      'carbonOffsetTonnes': 0.1,
      'image': 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=600&q=80',
    },
    {
      'id': 'ART-ZW-7704',
      'title': 'Chapungu Spirit Bird (Black Serpentine Carving)',
      'type': 'Direct Fair Trade Commission',
      'dates': 'Artisan: Farai Ndlovu (Masvingo Guild)',
      'guests': 'Provenance Code: PROV-ZW-94821',
      'status': 'In Carving Studio',
      'statusColor': EcoColors.info,
      'totalUsd': 118.50,
      'campfireShareUsd': 17.70,
      'rangersFundedHours': 4,
      'carbonOffsetTonnes': 0.0,
      'image': 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=600&q=80',
    },
  ];

  void _showTicketDialog(Map<String, dynamic> bk) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? EcoColors.darkCardBg : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
        ),
        title: Row(
          children: [
            const Icon(Icons.qr_code_2_rounded, color: EcoColors.mintAccent, size: 24),
            const SizedBox(width: 8),
            Text(
              'Digital Impact Pass',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.qr_code_rounded, size: 120, color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              bk['title'] as String,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text('Booking ID: ${bk['id']}', style: const TextStyle(fontSize: 12, color: EcoColors.savannaGold, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.black38 : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('CAMPFIRE Rural Share:', style: TextStyle(fontSize: 11)),
                      Text('US\$${bk['campfireShareUsd']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: EcoColors.mintAccent)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ranger Patrol Funded:', style: TextStyle(fontSize: 11)),
                      Text('${bk['rangersFundedHours']} Hours', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: EcoColors.savannaGold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verified Impact Receipt downloaded as PDF!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: EcoColors.emeraldPrimary,
              foregroundColor: Colors.black,
            ),
            child: const Text('Download Receipt'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Bookings & Impact Receipts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'All lodge stays, permits, and artisan commissions recorded with 0% leakage.',
                    style: TextStyle(fontSize: 13, color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => widget.onNavigateTouristTab?.call(1), // Explore
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('New Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: EcoColors.emeraldPrimary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Total Eco-Contribution Summary Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? EcoColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              children: [
                _buildSummaryStat('US\$274.70', 'Direct CAMPFIRE Community Funds', Icons.volunteer_activism_rounded, EcoColors.savannaGold, isDark),
                _buildDivider(isDark),
                _buildSummaryStat('26 Hours', 'Ranger Patrols Protected', Icons.shield_moon_rounded, EcoColors.mintAccent, isDark),
                _buildDivider(isDark),
                _buildSummaryStat('2.5 t CO₂', 'Carbon Emissions Offset', Icons.eco_rounded, EcoColors.emeraldPrimary, isDark),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bookings List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _bookings.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final bk = _bookings[index];
              return _buildBookingCard(bk, isDark);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String value, String label, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isDark ? EcoColors.textMuted : EcoColors.textMutedDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 36,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: isDark ? Colors.white12 : EcoColors.lightCardBorder,
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> bk, bool isDark) {
    final statusColor = bk['statusColor'] as Color;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? EcoColors.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              bk['image'] as String,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                width: 80,
                height: 80,
                color: isDark ? Colors.white10 : Colors.black12,
                child: const Icon(Icons.confirmation_number_rounded, color: EcoColors.mintAccent),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        bk['status'] as String,
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: statusColor),
                      ),
                    ),
                    Text(
                      'US\$${bk['totalUsd']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: isDark ? EcoColors.mintAccent : EcoColors.emeraldDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  bk['title'] as String,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${bk['type']} • ${bk['dates']}',
                  style: TextStyle(fontSize: 11.5, color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.people_outline_rounded, size: 13, color: EcoColors.savannaGold),
                    const SizedBox(width: 4),
                    Text(
                      'CAMPFIRE: US\$${bk['campfireShareUsd']} (${bk['rangersFundedHours']}h patrols)',
                      style: const TextStyle(fontSize: 11, color: EcoColors.savannaGold, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'View Pass & Receipt',
            icon: const Icon(Icons.qr_code_rounded, color: EcoColors.mintAccent, size: 24),
            onPressed: () => _showTicketDialog(bk),
          ),
        ],
      ),
    );
  }
}
