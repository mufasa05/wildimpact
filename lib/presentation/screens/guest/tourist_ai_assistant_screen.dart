import 'package:flutter/material.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/eco_badge.dart';

class TouristAiAssistantScreen extends StatefulWidget {
  final String? initialQuery;
  final Function(int)? onNavigateTouristTab;

  const TouristAiAssistantScreen({
    super.key,
    this.initialQuery,
    this.onNavigateTouristTab,
  });

  @override
  State<TouristAiAssistantScreen> createState() => _TouristAiAssistantScreenState();
}

class _TouristAiAssistantScreenState extends State<TouristAiAssistantScreen> {
  final _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<Map<String, dynamic>> _messages = [];

  final List<String> _quickPrompts = [
    'Hotels & eco-lodges near Great Zimbabwe',
    'Best itinerary for Mana Pools walking safari',
    'How does CAMPFIRE ensure 0% economic leakage?',
    'Pack list & health tips for Hwange dry season',
    'Where to buy verified Shona soapstone carvings?',
    'Accessible safari options for wheelchair travelers',
  ];

  @override
  void initState() {
    super.initState();
    // Default welcome message
    _messages.add({
      'isUser': false,
      'text':
          'Salibonani & Mauya! I am your **WildImpact AI Travel Concierge**.\n\nI can help you plan your itinerary, find verified eco-lodges, explain indigenous cultural folklore, calculate your safari carbon footprint, and connect you directly to local artisan guilds with 0% middleman leakage.\n\nHow can I help you explore Zimbabwe today?',
      'time': 'Just now',
    });

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSendMessage(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String userText) {
    if (userText.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': userText.trim(),
        'time': 'Just now',
      });
      _isTyping = true;
    });

    _inputController.clear();
    _scrollToBottom();

    // Generate contextual intelligent answer
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final responseText = _generateAiAnswer(userText);
      setState(() {
        _isTyping = false;
        _messages.add({
          'isUser': false,
          'text': responseText,
          'time': 'Just now',
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateAiAnswer(String query) {
    final q = query.toLowerCase();

    if (q.contains('great zimbabwe') || q.contains('masvingo') || q.contains('hotel') || q.contains('lodge')) {
      return '''### 🏛️ Eco-Lodges & Highlights near Great Zimbabwe:

1. **Singita Pamushana Lodge (Malilangwe Reserve)**:
   - *Distance*: ~145 km south in Chiredzi
   - *Rating*: 5.0 ★ | 99% Eco-Impact
   - *Conservation Impact*: 100% of proceeds fund the Malilangwe Trust black rhino breeding project and local school nutrition programs.

2. **Nyuni Mountain Lodge & Lakeside Resort**:
   - *Distance*: 32 km on the shores of Lake Mutirikwi
   - *Rating*: 4.8 ★ | 94% Eco-Impact
   - *Highlights*: Solar-powered chalets, boat safaris, bass fishing, and scenic hilltop granite trails.

3. **Great Zimbabwe Hotel & Heritage Camp**:
   - *Distance*: 0.8 km from the Monument gate
   - *Rating*: 4.6 ★ | Direct walking access to the Hill Complex for sunrise photography.

💡 *Pro Tip*: Visit the Conical Tower at 6:30 AM to beat the mid-day sun and hear the acoustic resonance designed by ancient Karanga builders.''';
    }

    if (q.contains('mana pools') || q.contains('walking safari') || q.contains('itinerary')) {
      return '''### 🐾 Mana Pools 4-Day UNESCO Walking Safari:

- **Day 1**: Fly into Mana Main Airstrip; afternoon canoe excursion down the Zambezi river channel to spot elephant herds crossing to Zambia.
- **Day 2**: Dawn walking safari accompanied by a certified ZimParks Professional Guide. Track wild dog packs (*Lycaon pictus*) through the albida woodland.
- **Day 3**: Chitake Springs expedition: witness massive lion prides and buffalo herds gathered around the natural dry-season spring.
- **Day 4**: Community tree planting ceremony in the buffer zone and zero-plastic lodge checkout.

🌱 *Carbon Footprint*: Estimated 0.85 tonnes CO₂ for local light aircraft transfer; verified offsets available on WildImpact for only \$12.''';
    }

    if (q.contains('campfire') || q.contains('leakage') || q.contains('economic')) {
      return '''### 🛡️ What is CAMPFIRE & How WildImpact Eliminates Leakage:

**CAMPFIRE** (*Communal Areas Management Programme for Indigenous Resources*) is Zimbabwe's world-pioneering community wildlife conservation framework established in 1989.

**How your money flows on WildImpact:**
- **Traditional OTAs**: 65%+ leaks offshore to foreign booking platforms.
- **WildImpact**: 0% platform intermediary commission.
- **Direct Breakdown**:
  - 60% directly to your local lodge / safari host
  - 20% to the rural Ward CAMPFIRE Development Fund (funding solar clinics, boreholes & anti-poaching scouts)
  - 15% fair-trade artisan wages
  - 5% ZimParks National Habitat Conservation''';
    }

    if (q.contains('artisan') || q.contains('sculpture') || q.contains('shona') || q.contains('craft')) {
      return '''### 🗿 Verified 0% Middleman Shona Stone Artisan Guilds:

1. **Farai Ndlovu (Master Sculptor)**:
   - *Guild*: Masvingo & Chitungwiza Artisan Guild
   - *Materials*: Rare Springstone granite & Black Serpentine
   - *Authenticity*: Every piece is engraved with a tamper-proof provenance code `PROV-ZW-XXXXX` and recorded in the heritage ledger.

2. **Binga Tonga Women's Basket Weaving Collective**:
   - *Location*: Binga / Lake Kariba
   - *Craft*: Geometric ilala palm baskets hand-dyed with wild bark extracts.

🛍️ *Order Direct*: Tap **Services & Artisans** on the sidebar to send custom commission requests directly over WhatsApp with 0% middleman deductions.''';
    }

    if (q.contains('accessible') || q.contains('wheelchair') || q.contains('disability')) {
      return '''### ♿ Universal Accessibility & Inclusive Safaris:

Zimbabwe features several wheelchair-graded trails and accessible safari vehicles:
1. **Victoria Falls Rainforest Trail**: Paved, level-graded tarmac paths leading to Viewpoints 1 through 10 with tactile braille trail markers.
2. **Matobo National Park Rhino Drive**: Specially adapted open 4x4 safari cruisers with hydraulic ramps and low-vibration seating.
3. **Great Zimbabwe Heritage Museum**: Ramp access to the soapstone bird exhibition hall and audio-narrated Braille guides.

Tap the **Living Heritage & Accessibility** module to view live obstacle reports and elevation charts!''';
    }

    return '''### 🌟 WildImpact Travel Insights for "$query":

Zimbabwe is home to 5 UNESCO World Heritage Sites and over 15 pristine national parks. 

**Recommended Next Steps:**
- 🧭 **Explore Places**: Check out Great Zimbabwe, Mana Pools, and Victoria Falls.
- 🌿 **Carbon Offsets**: Calculate your journey emissions and fund local reforestation.
- 📅 **Bookings**: Manage permits, game drives, and lodge stays with verified eco-receipts.

Would you like me to create a customized 7-day green itinerary for this region?''';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: EcoColors.emeraldPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: EcoColors.mintAccent, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WildImpact AI Concierge',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'Real-time Zimbabwe Eco-Tourism & Heritage Intelligence',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              EcoBadge.gold(text: 'GPT-4o Tourism Engine', icon: Icons.bolt_rounded),
            ],
          ),
          const SizedBox(height: 16),

          // Quick Prompt Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quickPrompts.map((prompt) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
                    side: BorderSide(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
                    avatar: const Icon(Icons.help_outline_rounded, size: 14, color: EcoColors.mintAccent),
                    label: Text(
                      prompt,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => _handleSendMessage(prompt),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Messages List View
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? EcoColors.darkCardBg.withValues(alpha: 0.6) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(18),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator(isDark);
                  }
                  final msg = _messages[index];
                  return _buildMessageBubble(msg, isDark);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? EcoColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline_rounded, color: EcoColors.mintAccent, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.5),
                    decoration: InputDecoration(
                      hintText: 'Ask anything about Zimbabwean safaris, routes, permits, culture...',
                      hintStyle: TextStyle(color: isDark ? Colors.white38 : EcoColors.textMutedDark, fontSize: 12.5),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                    onSubmitted: (val) => _handleSendMessage(val),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: EcoColors.emeraldPrimary),
                  onPressed: () => _handleSendMessage(_inputController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isDark) {
    final isUser = msg['isUser'] as bool;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                gradient: EcoColors.emeraldGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.park_rounded, color: Colors.black, size: 16),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? EcoColors.emeraldPrimary
                    : (isDark ? Colors.black.withValues(alpha: 0.4) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(16),
                border: !isUser
                    ? Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg['text'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: isUser
                          ? Colors.black
                          : (isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 14,
              backgroundColor: EcoColors.savannaGold,
              child: const Text('M', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(gradient: EcoColors.emeraldGradient, shape: BoxShape.circle),
            child: const Icon(Icons.park_rounded, color: Colors.black, size: 16),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.black38 : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: EcoColors.mintAccent),
                ),
                SizedBox(width: 8),
                Text('Consulting National Tourism Graph...', style: TextStyle(fontSize: 12, color: EcoColors.mintAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
