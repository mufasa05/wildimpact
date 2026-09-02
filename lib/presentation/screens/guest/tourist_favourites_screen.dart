import 'package:flutter/material.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/eco_badge.dart';

class TouristFavouritesScreen extends StatefulWidget {
  final Function(int)? onNavigateTouristTab;
  const TouristFavouritesScreen({super.key, this.onNavigateTouristTab});

  @override
  State<TouristFavouritesScreen> createState() => _TouristFavouritesScreenState();
}

class _TouristFavouritesScreenState extends State<TouristFavouritesScreen> {
  final List<Map<String, dynamic>> _favourites = [
    {
      'title': 'Singita Pamushana Lodge',
      'location': 'Malilangwe Reserve, Chiredzi',
      'category': 'Luxury Safari',
      'price': 'From \$1,200/night',
      'image': 'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=600&q=80',
      'rating': 5.0,
      'ecoScore': 99,
    },
    {
      'title': 'Great Zimbabwe Conical Tower & Ruins',
      'location': 'Masvingo',
      'category': 'UNESCO Heritage',
      'price': '\$15 entry',
      'image': 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=600&q=80',
      'rating': 4.8,
      'ecoScore': 98,
    },
    {
      'title': 'Mana Pools Canoe Trail & Walking Camp',
      'location': 'Zambezi Valley',
      'category': 'Wilderness Safari',
      'price': 'From \$350/day',
      'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?auto=format&fit=crop&w=600&q=80',
      'rating': 4.9,
      'ecoScore': 99,
    },
    {
      'title': 'Chapungu Spirit Bird Artisan Guild',
      'location': 'Masvingo / Chitungwiza',
      'category': 'Direct Artisan Craft',
      'price': '0% Middleman Fees',
      'image': 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=600&q=80',
      'rating': 5.0,
      'ecoScore': 100,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved & Favourites',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your curated bucket list of Zimbabwean eco-lodges, wonders, and master craftspeople.',
                    style: TextStyle(fontSize: 13, color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                  ),
                ],
              ),
              EcoBadge(text: '${_favourites.length} Saved', fontSize: 11),
            ],
          ),
          const SizedBox(height: 20),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _favourites.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _favourites[index];
              return Container(
                decoration: BoxDecoration(
                  color: isDark ? EcoColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item['image'] as String,
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 75,
                          height: 75,
                          color: Colors.white12,
                          child: const Icon(Icons.favorite_rounded, color: EcoColors.mintAccent),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['category'] as String,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? EcoColors.mintAccent : EcoColors.emeraldDark,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: EcoColors.savannaGold, size: 14),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${item['rating']}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['title'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['location'] as String,
                            style: TextStyle(fontSize: 11, color: isDark ? EcoColors.textMuted : EcoColors.textMutedDark),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.favorite_rounded, color: EcoColors.error, size: 22),
                      onPressed: () {
                        setState(() {
                          _favourites.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removed from favourites')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
