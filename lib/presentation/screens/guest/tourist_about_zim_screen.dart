import 'package:flutter/material.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/eco_badge.dart';

class TouristAboutZimScreen extends StatelessWidget {
  const TouristAboutZimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Zimbabwe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A land of ancient stone empires, thundering waters, and wildlife conservation pioneers.',
                    style: TextStyle(fontSize: 13, color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                  ),
                ],
              ),
              EcoBadge.gold(text: 'Official Heritage Guide', icon: Icons.castle_rounded),
            ],
          ),
          const SizedBox(height: 24),

          // Overview Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0D281E), const Color(0xFF071B13)]
                    : [const Color(0xFF0E4331), const Color(0xFF062B1D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: EcoColors.emeraldPrimary.withValues(alpha: 0.2),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: EcoColors.savannaGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: EcoColors.savannaGold),
                      ),
                      child: const Text(
                        'THE JEWEL OF AFRICA',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: EcoColors.savannaGold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Zimbabwe (Dzimba-dza-Mabwe: "Houses of Stone")',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Situated between the Zambezi and Limpopo rivers, Zimbabwe is famed for its dramatic landscapes, warm people, rich oral histories, and over 15% of national land dedicated to wildlife sanctuaries and national parks.',
                  style: TextStyle(fontSize: 13.5, height: 1.5, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 5 UNESCO World Heritage Sites
          Text(
            '5 UNESCO World Heritage Sites',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          _buildHeritageItem(
            '1. Victoria Falls / Mosi-oa-Tunya (1989)',
            'The world\'s largest curtain of falling water, generating mist visible from 50 kilometers away.',
            'Matabeleland North',
            Icons.water_rounded,
            isDark,
          ),
          const SizedBox(height: 10),

          _buildHeritageItem(
            '2. Great Zimbabwe National Monument (1986)',
            'Medieval metropolis and dry-stone masonry masterpiece of the Karanga/Shona civilization.',
            'Masvingo Province',
            Icons.account_balance_rounded,
            isDark,
          ),
          const SizedBox(height: 10),

          _buildHeritageItem(
            '3. Mana Pools National Park & Sapi/Chewore (1984)',
            'Wild Zambezi floodplains renowned globally for safe unguided walking safaris and wild dogs.',
            'Mashonaland West',
            Icons.nature_people_rounded,
            isDark,
          ),
          const SizedBox(height: 10),

          _buildHeritageItem(
            '4. Matobo Hills Cultural Landscape (2003)',
            'Sculpted granite boulder formations holding the highest concentration of prehistoric San rock art in Southern Africa.',
            'Matabeleland South',
            Icons.landscape_rounded,
            isDark,
          ),
          const SizedBox(height: 10),

          _buildHeritageItem(
            '5. Khami Ruins National Monument (1986)',
            'Capital of the Torwa dynasty featuring tiered stone retaining walls and ancient glass bead trade relics.',
            'Bulawayo West',
            Icons.domain_rounded,
            isDark,
          ),
          const SizedBox(height: 28),

          // CAMPFIRE & Wildlife Conservation
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? EcoColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_rounded, color: EcoColors.mintAccent, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Pioneering CAMPFIRE Conservation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Founded in Zimbabwe in 1989, CAMPFIRE proved to the world that when local rural communities directly benefit from wildlife conservation through eco-tourism levies, poaching drops dramatically and human-wildlife coexistence thrives.',
                  style: TextStyle(fontSize: 13, height: 1.5, color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeritageItem(String title, String desc, String location, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? EcoColors.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: EcoColors.savannaGold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: EcoColors.savannaGold, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      location,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: EcoColors.mintAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(fontSize: 12, height: 1.35, color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
