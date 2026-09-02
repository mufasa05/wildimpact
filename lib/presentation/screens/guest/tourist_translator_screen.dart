import 'package:flutter/material.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/eco_badge.dart';

class TouristTranslatorScreen extends StatefulWidget {
  const TouristTranslatorScreen({super.key});

  @override
  State<TouristTranslatorScreen> createState() => _TouristTranslatorScreenState();
}

class _TouristTranslatorScreenState extends State<TouristTranslatorScreen> {
  String _selectedLanguage = 'ChiShona';
  String _selectedCategory = 'Greetings & Respect';
  final _customTranslateController = TextEditingController();
  String? _translatedResult;

  final List<String> _languages = ['ChiShona', 'IsiNdebele', 'ChiTonga'];
  final List<String> _categories = [
    'Greetings & Respect',
    'Safari & Wildlife',
    'Food & Hospitality',
    'Directions & Travel',
    'Emergencies & Help',
  ];

  final Map<String, List<Map<String, String>>> _phrasebook = {
    'Greetings & Respect': [
      {
        'english': 'Hello / How are you?',
        'shona': 'Mhoro / Makadii henyu?',
        'ndebele': 'Salibonani / Kunjani?',
        'tonga': 'Mwabonwa / Muli kabotu?',
        'context': 'Polite greeting for elders and hosts; clasp hands softly in respect.',
      },
      {
        'english': 'Thank you very much',
        'shona': 'Tatenda chaizvo / Mazvita',
        'ndebele': 'Siyabonga kakhulu',
        'tonga': 'Twalumba kapati',
        'context': 'Always clap two cupped hands together twice when receiving food or gifts.',
      },
      {
        'english': 'Welcome to our country',
        'shona': 'Mauya / Titambire',
        'ndebele': 'Samukele',
        'tonga': 'Mwakatambula',
        'context': 'Warm indigenous hospitality welcoming visitors as family.',
      },
      {
        'english': 'Peace & Harmony',
        'shona': 'Runyararo / Rugare',
        'ndebele': 'Ukuthula',
        'tonga': 'Luumuno',
        'context': 'Foundational Ubuntu philosophy linking all humans and nature.',
      },
    ],
    'Safari & Wildlife': [
      {
        'english': 'Lion',
        'shona': 'Shumba',
        'ndebele': 'Silwane',
        'tonga': 'Syumbwa',
        'context': 'Revered apex predator & royal totem of Great Zimbabwe rulers.',
      },
      {
        'english': 'Elephant',
        'shona': 'Nzou / Zhou',
        'ndebele': 'Indlovu',
        'tonga': 'Muzovu',
        'context': 'Symbol of wisdom, ancient matriarchal leadership, and earth memory.',
      },
      {
        'english': 'Rhino (Black / White)',
        'shona': 'Chipembere',
        'ndebele': 'Ubhejane',
        'tonga': 'Cipembele',
        'context': 'Strictly protected critically endangered armor of the savanna.',
      },
      {
        'english': 'Victoria Falls (The Smoke that Thunders)',
        'shona': 'Mosi-oa-Tunya',
        'ndebele': 'Amanzi Athunqayo',
        'tonga': 'Muso-O-Tunya',
        'context': 'Sacred river mist where local Tonga priests conducted rain ceremonies.',
      },
    ],
    'Food & Hospitality': [
      {
        'english': 'Traditional Cornmeal Dish',
        'shona': 'Sadza',
        'ndebele': 'Isitshwala',
        'tonga': 'Nsima',
        'context': 'The staple grain energy of Zimbabwe, served hot with stew and wild greens.',
      },
      {
        'english': 'Clean drinking water',
        'shona': 'Mvura yekunwa',
        'ndebele': 'Amanzi okunatha',
        'tonga': 'Meenda aakunwa',
        'context': 'Sourced from solar boreholes funded through CAMPFIRE levies.',
      },
    ],
    'Directions & Travel': [
      {
        'english': 'Where is the eco-lodge / camp?',
        'shona': 'Lodge iri kupi?',
        'ndebele': 'Iphi indawo yokulala?',
        'tonga': 'Kuli kuli lodge?',
        'context': 'Used when navigating rural buffer zones.',
      },
      {
        'english': 'Have a safe journey',
        'shona': 'Fambai zvakanaka',
        'ndebele': 'Uhambe kahle',
        'tonga': 'Mweende kabotu',
        'context': 'Spoken by hosts as safari vehicles depart.',
      },
    ],
    'Emergencies & Help': [
      {
        'english': 'Please help me',
        'shona': 'Ndibatsireiwo ndapota',
        'ndebele': 'Ncedani ngicela',
        'tonga': 'Ndigwasyei mebo',
        'context': 'Urgent respectful assistance.',
      },
      {
        'english': 'Call the park ranger',
        'shona': 'Danai ranger wepaki',
        'ndebele': 'Bizani umlindi wepaki',
        'tonga': 'Bani ranger wa park',
        'context': 'For wildlife sightings or road obstacles.',
      },
    ],
  };

  void _translateCustomPhrase() {
    final text = _customTranslateController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _translatedResult = 'Translating "$text" into $_selectedLanguage...\n\n'
          '✅ Translation: "${_selectedLanguage == 'ChiShona' ? 'Zviri nani / Fambai zvakanaka' : 'Kuhle kakhulu / Hambani kahle'}"\n'
          '🔊 Pronunciation: Phonetic tone steady with penultimate vowel elongation.\n'
          '🤝 Cultural Etiquette: Maintain gentle eye contact and a slight bow.';
    });
  }

  void _simulateAudioPlay(String phrase) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.volume_up_rounded, color: EcoColors.mintAccent),
            const SizedBox(width: 10),
            Text('Playing native audio: "$phrase"'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentList = _phrasebook[_selectedCategory] ?? [];

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
                    'Live Translator & Cultural Voice',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Master authentic indigenous greetings, wildlife terms, and Ubuntu cultural etiquette.',
                    style: TextStyle(fontSize: 13, color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                  ),
                ],
              ),
              EcoBadge.gold(text: '3 Indigenous Languages', icon: Icons.record_voice_over_rounded),
            ],
          ),
          const SizedBox(height: 20),

          // Instant Phrase Translator Box
          Container(
            padding: const EdgeInsets.all(20),
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
                Row(
                  children: [
                    const Icon(Icons.translate_rounded, color: EcoColors.mintAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'INSTANT VOICE & PHRASE TRANSLATOR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: isDark ? EcoColors.savannaGold : EcoColors.terracotta,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _customTranslateController,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.5),
                        decoration: InputDecoration(
                          hintText: 'Type English phrase e.g. "How much is the stone sculpture?"',
                          hintStyle: TextStyle(color: isDark ? Colors.white38 : EcoColors.textMutedDark, fontSize: 12.5),
                        ),
                        onSubmitted: (_) => _translateCustomPhrase(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _translateCustomPhrase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: EcoColors.emeraldPrimary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Translate', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                if (_translatedResult != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black45 : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: EcoColors.emeraldPrimary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _translatedResult!,
                      style: TextStyle(fontSize: 12.5, height: 1.4, color: isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Language Selector Tabs
          Row(
            children: _languages.map((lang) {
              final isSelected = _selectedLanguage == lang;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ChoiceChip(
                  label: Text(lang),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedLanguage = lang),
                  selectedColor: EcoColors.emeraldPrimary,
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
                  labelStyle: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.black : (isDark ? Colors.white70 : Colors.black87),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Categories Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: EcoColors.savannaGold,
                    checkmarkColor: Colors.black,
                    backgroundColor: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC),
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
          const SizedBox(height: 20),

          // Phrase Cards Grid
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: currentList.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = currentList[index];
              final localized = _selectedLanguage == 'ChiShona'
                  ? item['shona']!
                  : (_selectedLanguage == 'IsiNdebele' ? item['ndebele']! : item['tonga']!);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? EcoColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: EcoColors.emeraldPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.volume_up_rounded, color: EcoColors.mintAccent, size: 22),
                        onPressed: () => _simulateAudioPlay(localized),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localized,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isDark ? EcoColors.mintAccent : EcoColors.emeraldDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['english']!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '💡 Etiquette: ${item['context']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? EcoColors.textMuted : EcoColors.textMutedDark,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
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
