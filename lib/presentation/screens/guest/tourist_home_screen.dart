import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../providers/tourism_providers.dart';

class TouristHomeScreen extends ConsumerStatefulWidget {
  final Function(int)? onNavigateTouristTab;
  final Function(String)? onSearchAi;

  const TouristHomeScreen({
    super.key,
    this.onNavigateTouristTab,
    this.onSearchAi,
  });

  @override
  ConsumerState<TouristHomeScreen> createState() => _TouristHomeScreenState();
}

class _TouristHomeScreenState extends ConsumerState<TouristHomeScreen> {
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _popularDestinations = [
    {
      'title': 'Great Zimbabwe National Monument',
      'location': 'Masvingo',
      'distance': '0.8 km',
      'rating': 4.8,
      'reviews': 230,
      'category': 'Heritage Site',
      'tag': 'UNESCO World Heritage',
      'price': '\$15 entry',
      'image': 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=800&q=80',
      'description': 'Ancient stone city built between the 11th and 15th centuries. Iconic home of the carved soapstone Zimbabwe Birds (Chapungu).',
    },
    {
      'title': 'Singita Pamushana Lodge',
      'location': 'Malilangwe Reserve, Chiredzi',
      'distance': '145 km',
      'rating': 5.0,
      'reviews': 142,
      'category': 'Ultra-Luxury Safari Lodge',
      'tag': 'Black Rhino Sanctuary',
      'price': 'From \$1,200/night',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=800&q=80',
      'description': 'Cliff-top luxury lodge overlooking the Malilangwe Dam. Direct funding for 50,000 hectares of black & white rhino protection.',
    },
    {
      'title': 'Nyuni Mountain Lodge & Lakeside Resort',
      'location': 'Lake Mutirikwi, Masvingo',
      'distance': '32 km',
      'rating': 4.8,
      'reviews': 89,
      'category': 'Mountain & Lake Resort',
      'tag': 'Lake Cruise & Hiking',
      'price': 'From \$95/night',
      'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
      'description': 'Nestled amidst the granite hills of Lake Mutirikwi, offering eco-boat cruises, bass fishing, and scenic hilltop trails.',
    },
    {
      'title': 'Pokoteke Gorge & Wilderness Trail',
      'location': 'Mutirikwi Basin, Masvingo',
      'distance': '29 km',
      'rating': 4.7,
      'reviews': 64,
      'category': 'Nature Walk & Gorge Hike',
      'tag': 'Canyon & Birding',
      'price': 'Free / \$5 Guide',
      'image': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=800&q=80',
      'description': 'Dramatic granite canyon with cascading waterfalls, rare bird species, and ancient San rock art shelters.',
    },
    {
      'title': 'Victoria Falls / Mosi-oa-Tunya',
      'location': 'Victoria Falls, Matabeleland North',
      'distance': '420 km',
      'rating': 4.9,
      'reviews': 1850,
      'category': 'Natural Wonder',
      'tag': 'Seven Natural Wonders',
      'price': '\$30 ZimParks',
      'image': 'https://images.unsplash.com/photo-1534567153574-2b12153a87f0?auto=format&fit=crop&w=800&q=80',
      'description': 'The Smoke that Thunders: the world\'s largest sheet of falling water, rainforest trails, and Zambezi river adventures.',
    },
    {
      'title': 'Mana Pools Canoe Trail & Camp',
      'location': 'Zambezi Valley, Mashonaland West',
      'distance': '380 km',
      'rating': 4.9,
      'reviews': 310,
      'category': 'Walking Safari',
      'tag': 'UNESCO Wilderness',
      'price': 'From \$350/night',
      'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=800&q=80',
      'description': 'Legendary close-up walking safaris alongside wild dogs, giant elephant bulls, and Zambezi river canoe trails.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      if (widget.onSearchAi != null) {
        widget.onSearchAi!(query);
      } else {
        widget.onNavigateTouristTab?.call(2); // Navigate to AI Assistant tab
      }
    }
  }

  void _showDestinationDetail(Map<String, dynamic> item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: isDark ? EcoColors.darkCardBg : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EcoBadge(text: item['tag'] as String, fontSize: 11),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: EcoColors.savannaGold, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${item['rating']} (${item['reviews']} reviews)',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item['title'] as String,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, size: 14, color: EcoColors.mintAccent),
                const SizedBox(width: 4),
                Text(
                  '${item['location']} • ${item['distance']}',
                  style: TextStyle(fontSize: 12.5, color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              item['description'] as String,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      widget.onNavigateTouristTab?.call(3); // Bookings
                    },
                    icon: const Icon(Icons.calendar_month_rounded, size: 18),
                    label: Text('Book Now (${item['price']})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EcoColors.emeraldPrimary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    widget.onNavigateTouristTab?.call(4); // Audio Translator & Stories
                  },
                  icon: const Icon(Icons.headphones_rounded, size: 18, color: EcoColors.savannaGold),
                  label: const Text('Oral Guide', style: TextStyle(color: EcoColors.savannaGold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: EcoColors.savannaGold),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
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
          // Majestic Hero Banner with Search Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0D281E), const Color(0xFF061A12)]
                    : [const Color(0xFF0F3E2E), const Color(0xFF062B1D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: EcoColors.emeraldPrimary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: EcoColors.savannaGold, size: 13),
                          SizedBox(width: 4),
                          Text(
                            'WILDIMPACT AI CONCIERGE',
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: EcoColors.savannaGold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Discover Zimbabwe with Intelligence',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'AI-powered travel insights, verified eco-discovery & real-time conservation impact near you.',
                  style: TextStyle(fontSize: 13.5, color: Colors.white70),
                ),
                const SizedBox(height: 22),

                // Interactive AI Search Input
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.auto_awesome_rounded, color: EcoColors.mintAccent, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white, fontSize: 13.5),
                          decoration: const InputDecoration(
                            hintText: 'Ask WildImpact AI... e.g. "Hotels near Great Zimbabwe or walking safaris?"',
                            hintStyle: TextStyle(color: Colors.white54, fontSize: 12.5),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => _submitSearch(),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _submitSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: EcoColors.emeraldPrimary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Ask', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Category Tiles (Matching Screenshot)
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              return GridView.count(
                crossAxisCount: isWide ? 6 : 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: isWide ? 1.4 : 1.1,
                children: [
                  _buildCategoryTile(Icons.location_on_outlined, 'Explore Places', 'Attractions & gems nearby', 1, isDark),
                  _buildCategoryTile(Icons.hotel_rounded, 'Stay', 'Hotels & eco-lodges', 1, isDark),
                  _buildCategoryTile(Icons.calendar_today_rounded, 'Things to Do', 'Tours & activities', 1, isDark),
                  _buildCategoryTile(Icons.directions_car_rounded, 'Get Around', 'Car hire & travel info', 1, isDark),
                  _buildCategoryTile(Icons.shopping_bag_outlined, 'Services', 'Dining & shopping', 1, isDark),
                  _buildCategoryTile(Icons.local_hospital_outlined, 'Emergency & Health', 'Hospitals, police & clinics', 1, isDark),
                ],
              );
            },
          ),

          const SizedBox(height: 28),

          // Popular Near You Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular near you',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              InkWell(
                onTap: () => widget.onNavigateTouristTab?.call(1), // Explore Tab
                child: const Row(
                  children: [
                    Text(
                      'View all',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: EcoColors.mintAccent),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_outward_rounded, size: 14, color: EcoColors.mintAccent),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Popular Near You Horizontal / Responsive Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth < 600 ? constraints.maxWidth : (constraints.maxWidth - 36) / 3;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _popularDestinations.take(4).map((dest) {
                  return SizedBox(
                    width: cardWidth,
                    child: _buildDestinationCard(dest, isDark),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 28),

          // Local Operator CTA Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.handshake_rounded, color: EcoColors.savannaGold, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Are you a local operator? Join our verified tourism intelligence graph.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(activeRoleProvider.notifier).state = UserRole.providerPortal;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('List Your Business', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 14),
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

  Widget _buildCategoryTile(IconData icon, String title, String subtitle, int tabIdx, bool isDark) {
    return InkWell(
      onTap: () => widget.onNavigateTouristTab?.call(tabIdx),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? EcoColors.darkCardBg : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: EcoColors.emeraldPrimary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: EcoColors.mintAccent, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                color: isDark ? EcoColors.textMuted : EcoColors.textMutedDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> dest, bool isDark) {
    return InkWell(
      onTap: () => _showDestinationDetail(dest),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? EcoColors.darkCardBg : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with distance pill
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    dest['image'] as String,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      height: 120,
                      color: isDark ? Colors.white10 : Colors.black12,
                      child: const Icon(Icons.landscape_rounded, size: 36, color: EcoColors.mintAccent),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      dest['distance'] as String,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dest['title'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: EcoColors.mintAccent),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          dest['location'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isDark ? EcoColors.textMuted : EcoColors.textMutedDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: EcoColors.savannaGold, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            '${dest['rating']} (${dest['reviews']})',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        dest['category'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isDark ? EcoColors.mintAccent : EcoColors.emeraldDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
