import 'package:flutter/material.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/eco_badge.dart';

class TouristExploreScreen extends StatefulWidget {
  final Function(int)? onNavigateTouristTab;
  const TouristExploreScreen({super.key, this.onNavigateTouristTab});

  @override
  State<TouristExploreScreen> createState() => _TouristExploreScreenState();
}

class _TouristExploreScreenState extends State<TouristExploreScreen> {
  String _selectedRegion = 'All';
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();

  final List<String> _regions = [
    'All',
    'Masvingo & Great Zimbabwe',
    'Victoria Falls & Zambezi',
    'Hwange & Matabeleland',
    'Mana Pools & Kariba',
    'Eastern Highlands & Nyanga',
    'Matobo Hills & Bulawayo',
  ];

  final List<String> _categories = [
    'All',
    'Heritage & Ruins',
    'Safari & Game Reserves',
    'Eco-Lodges',
    'Waterfalls & Canyons',
    'Mountain Hiking',
    'Artisans & Crafts',
  ];

  final List<Map<String, dynamic>> _places = [
    {
      'title': 'Great Zimbabwe National Monument',
      'region': 'Masvingo & Great Zimbabwe',
      'category': 'Heritage & Ruins',
      'ecoScore': 98,
      'price': '\$15 / person',
      'image': 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=800&q=80',
      'badge': 'UNESCO World Heritage',
      'desc': 'Ancient stone capital of the Kingdom of Zimbabwe (11th–15th century). Marvel at the Conical Tower and Hill Complex.',
      'highlights': ['Hill Complex', 'Great Enclosure', 'Soapstone Bird Museum', 'CAMPFIRE Curios'],
    },
    {
      'title': 'Singita Pamushana Lodge',
      'region': 'Masvingo & Great Zimbabwe',
      'category': 'Eco-Lodges',
      'ecoScore': 99,
      'price': 'From \$1,200/night',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=800&q=80',
      'badge': 'Rhino Sanctuary',
      'desc': 'Unrivaled eco-luxury in the Malilangwe Wildlife Reserve protecting endangered black rhinos and San rock art.',
      'highlights': ['Black Rhino Tracking', 'Sunset Lake Cruise', 'Rock Art Excursions', 'Community Preschools'],
    },
    {
      'title': 'Victoria Falls / Mosi-oa-Tunya',
      'region': 'Victoria Falls & Zambezi',
      'category': 'Waterfalls & Canyons',
      'ecoScore': 96,
      'price': '\$30 / person',
      'image': 'https://images.unsplash.com/photo-1534567153574-2b12153a87f0?auto=format&fit=crop&w=800&q=80',
      'badge': 'Natural Wonder of the World',
      'desc': 'The world\'s greatest sheet of falling water. Rainforest walk, Devil\'s Pool, and Zambezi gorge exploration.',
      'highlights': ['Rainforest Trail', 'Danger Point', 'Bridge Bungee', 'Zambezi River Safari'],
    },
    {
      'title': 'Hwange National Park Main Camp',
      'region': 'Hwange & Matabeleland',
      'category': 'Safari & Game Reserves',
      'ecoScore': 95,
      'price': '\$20 ZimParks',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=800&q=80',
      'badge': '40,000+ Elephants',
      'desc': 'Zimbabwe\'s largest park, renowned for presidential elephant herds, lion prides, and vital pumped waterholes.',
      'highlights': ['Nyamandhlovu Viewing Platform', 'Walking Safaris', 'K9 Anti-Poaching Unit', 'Night Drives'],
    },
    {
      'title': 'Mana Pools UNESCO Canoe Trail',
      'region': 'Mana Pools & Kariba',
      'category': 'Safari & Game Reserves',
      'ecoScore': 99,
      'price': 'From \$280/day',
      'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=800&q=80',
      'badge': 'Wilderness Walking',
      'desc': 'Untamed river floodplains where guests can walk unescorted or paddle canoes alongside hippos and wild dogs.',
      'highlights': ['Canoeing Safaris', 'Wild Dog Tracking', 'Baobab Sunsets', 'Zero-Light Pollution Stargazing'],
    },
    {
      'title': 'Matobo Hills & San Rock Art',
      'region': 'Matobo Hills & Bulawayo',
      'category': 'Heritage & Ruins',
      'ecoScore': 97,
      'price': '\$15 / person',
      'image': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=800&q=80',
      'badge': 'UNESCO Cultural Landscape',
      'desc': 'Granite balancing rocks, ancient San cave paintings, and sanctuary for white rhinos and black eagles.',
      'highlights': ['Rhino Foot Tracking', 'Nswatugi Cave Art', 'Worlds View Hill', 'Eagle Nesting Cliffs'],
    },
    {
      'title': 'Nyanga Mountain National Park & Mutarazi Falls',
      'region': 'Eastern Highlands & Nyanga',
      'category': 'Mountain Hiking',
      'ecoScore': 94,
      'price': '\$10 / person',
      'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
      'badge': 'SkyWalk & Zipline',
      'desc': 'Zimbabwe\'s highest peak (Mount Nyangani, 2,592m) and the breathtaking Mutarazi Falls skywalk bridge.',
      'highlights': ['Mutarazi Skywalk', 'Nyangani Summit', 'Trout Fishing Streams', 'Ancient Terraces'],
    },
    {
      'title': 'Chitungwiza & Tengenenge Artisan Guilds',
      'region': 'Masvingo & Great Zimbabwe',
      'category': 'Artisans & Crafts',
      'ecoScore': 100,
      'price': 'Direct Fair Trade',
      'image': 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=800&q=80',
      'badge': '0% Middleman Fees',
      'desc': 'Direct open-air sculptor communities carving black serpentine and verdite stone with provenance certificate.',
      'highlights': ['Live Sculptor Demos', 'Sadza Batik Weaving', 'Tonga Basket Weaving', 'Direct WhatsApp Ordering'],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _places.where((p) {
      final matchesRegion = _selectedRegion == 'All' || p['region'] == _selectedRegion;
      final matchesCat = _selectedCategory == 'All' || p['category'] == _selectedCategory;
      final query = _searchController.text.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          (p['title'] as String).toLowerCase().contains(query) ||
          (p['desc'] as String).toLowerCase().contains(query) ||
          (p['region'] as String).toLowerCase().contains(query);
      return matchesRegion && matchesCat && matchesQuery;
    }).toList();

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
                    'Explore Zimbabwe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover UNESCO world heritage, national parks, eco-lodges & verified artisans.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
              EcoBadge(text: '${filtered.length} Destinations', fontSize: 11),
            ],
          ),
          const SizedBox(height: 20),

          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.5),
            decoration: InputDecoration(
              hintText: 'Search destinations, parks, trails, rock art, or lodges...',
              hintStyle: TextStyle(color: isDark ? Colors.white38 : EcoColors.textMutedDark, fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, color: EcoColors.mintAccent, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () => setState(() => _searchController.clear()),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),

          // Region Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _regions.map((reg) {
                final isSelected = _selectedRegion == reg;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(reg),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedRegion = reg),
                    backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
                    selectedColor: EcoColors.emeraldPrimary,
                    checkmarkColor: Colors.black,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.black : (isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedCategory = cat),
                    backgroundColor: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC),
                    selectedColor: EcoColors.savannaGold,
                    labelStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: isSelected ? Colors.black : (isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Places Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 750;
              final crossCount = isWide ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 330,
                ),
                itemBuilder: (context, index) {
                  final place = filtered[index];
                  return _buildPlaceCard(place, isDark);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? EcoColors.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                child: Image.network(
                  place['image'] as String,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    height: 140,
                    color: isDark ? Colors.white10 : Colors.black12,
                    child: const Icon(Icons.landscape_rounded, color: EcoColors.mintAccent, size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: EcoBadge(text: place['badge'] as String, fontSize: 10.5),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.eco_rounded, color: EcoColors.mintAccent, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        '${place['ecoScore']}% Eco',
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        place['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
                        ),
                      ),
                    ),
                    Text(
                      place['price'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: EcoColors.savannaGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: EcoColors.mintAccent),
                    const SizedBox(width: 4),
                    Text(
                      place['region'] as String,
                      style: TextStyle(fontSize: 11, color: isDark ? EcoColors.textMuted : EcoColors.textSecondaryDark),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  place['desc'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.3,
                    color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => widget.onNavigateTouristTab?.call(3), // Bookings
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(color: isDark ? EcoColors.mintAccent : EcoColors.emeraldDark),
                        ),
                        child: Text(
                          'Book & Plan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? EcoColors.mintAccent : EcoColors.emeraldDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => widget.onNavigateTouristTab?.call(2), // AI Assistant
                      style: ElevatedButton.styleFrom(
                        backgroundColor: EcoColors.emeraldPrimary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.auto_awesome_rounded, size: 14),
                          SizedBox(width: 4),
                          Text('Ask AI', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
