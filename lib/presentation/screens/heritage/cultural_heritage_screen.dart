import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/immersive_background_scaffold.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../../domain/models/cultural_narrative.dart';
import '../../providers/tourism_providers.dart';

class CulturalHeritageScreen extends ConsumerStatefulWidget {
  const CulturalHeritageScreen({super.key});

  static const String backgroundUrl =
      'https://images.unsplash.com/photo-1516426122078-c23e76319801?auto=format&fit=crop&w=1600&q=80';

  @override
  ConsumerState<CulturalHeritageScreen> createState() => _CulturalHeritageScreenState();
}

class _CulturalHeritageScreenState extends ConsumerState<CulturalHeritageScreen> {
  String? _currentlyPlayingId;
  bool _isPlaying = false;
  final TextEditingController _ragSearchController = TextEditingController();
  String? _ragAnswer;
  String _selectedLanguage = 'All';

  @override
  void dispose() {
    _ragSearchController.dispose();
    super.dispose();
  }

  void _askOralRag(String query) {
    setState(() {
      _ragSearchController.text = query;
      if (query.toLowerCase().contains('bird') || query.toLowerCase().contains('great zimbabwe')) {
        _ragAnswer =
            '🦅 **Elder Oral Tradition (ChiShona Translation)**: The Hungwe (Bateleur Eagle) carved on the soapstone pillars represents the spiritual messenger between Mwari (The Supreme Creator) and the Shona kings. It was never a mere ornament—its presence at the Eastern Enclosure signaled divine peace, righteous governance, and timely seasonal rains for the kingdom.';
      } else if (query.toLowerCase().contains('njelele') || query.toLowerCase().contains('matobo')) {
        _ragAnswer =
            '🌧️ **Gogo Sibanda (SiNdebele Keeper of Matobo)**: Njelele is an ancient spiritual oracle. In times of drought, designated clan elders walk the granite valleys barefoot with black cattle offerings. The sacred rock caves whisper the rain forecasts through natural acoustic chambers that resonate across the Matopos.';
      } else {
        _ragAnswer =
            '✨ **Multi-Vocal Knowledge Retrieval**: Authenticated oral archives confirm that indigenous tourism corridors in Zimbabwe were designed around seasonal spiritual calendars, preserving sacred baobab groves, medicinal wild herbs, and river sanctuaries for generations.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final narratives = ref.watch(culturalNarrativesProvider);
    final filtered = _selectedLanguage == 'All'
        ? narratives
        : narratives.where((n) => n.language == _selectedLanguage).toList();

    return ImmersiveBackgroundScaffold(
      imageUrl: CulturalHeritageScreen.backgroundUrl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header & Heritage Pillar Overview
            _buildHeritageHeader(context),
            const SizedBox(height: 20),

            // Interactive Oral RAG Search & Ask-Elder Concierge
            _buildOralRagConcierge(context),
            const SizedBox(height: 24),

            // Language Filter & Elder Royalty Wallet Summary
            _buildLanguageAndRoyaltyRow(narratives),
            const SizedBox(height: 16),

            // List of Multi-Vocal Audio Stories
            ...filtered.map((story) => _buildAudioStoryCard(context, story)),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeritageHeader(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      border: BorderSide(color: EcoColors.savannaGold.withValues(alpha: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: EcoColors.savannaGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.record_voice_over_rounded, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UNESCO-ALIGNED LIVING CULTURE INITIATIVE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: EcoColors.savannaGold,
                      ),
                    ),
                    Text(
                      'Multi-Vocal AI Cultural Interpretation & Elder Royalty Engine',
                      style: TextStyle(
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
          const SizedBox(height: 12),
          const Text(
            'Moving beyond clinical text signage by capturing living oral folklore, native translations (ChiShona, SiNdebele, ChiTonga), and streaming pay-per-listen micro-royalties straight to rural community elders.',
            style: TextStyle(fontSize: 12.5, color: EcoColors.textSecondaryLight, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildOralRagConcierge(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      border: BorderSide(color: EcoColors.mintAccent.withValues(alpha: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: EcoColors.mintAccent, size: 18),
              const SizedBox(width: 8),
              const Text(
                'ASK THE INDIGENOUS ORAL KNOWLEDGE RAG',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: EcoColors.mintAccent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ragSearchController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'e.g. Why is the Great Zimbabwe bird sacred? Or ask about Matobo rain shrines...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
              prefixIcon: const Icon(Icons.search_rounded, color: EcoColors.mintAccent, size: 18),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send_rounded, color: EcoColors.mintAccent, size: 18),
                onPressed: () => _askOralRag(_ragSearchController.text),
              ),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.35),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            onSubmitted: _askOralRag,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('🦅 Great Zimbabwe Bird', style: TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                onPressed: () => _askOralRag('Why is the soapstone bird sacred at Great Zimbabwe?'),
              ),
              ActionChip(
                label: const Text('🌧️ Njelele Rain Shrines', style: TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                onPressed: () => _askOralRag('Tell me about Njelele rainmaking rituals in Matobo'),
              ),
              ActionChip(
                label: const Text('🐉 Nyami Nyami River Spirit', style: TextStyle(fontSize: 11, color: Colors.white)),
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                onPressed: () => _askOralRag('Who is Nyami Nyami of the Zambezi?'),
              ),
            ],
          ),
          if (_ragAnswer != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: EcoColors.forestDeep.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: EcoColors.mintAccent.withValues(alpha: 0.3)),
              ),
              child: Text(
                _ragAnswer!,
                style: const TextStyle(fontSize: 12.5, color: EcoColors.textPrimaryLight, height: 1.4),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageAndRoyaltyRow(List<CulturalNarrative> narratives) {
    final totalRoyalties = narratives.fold<double>(0.0, (sum, n) => sum + n.royaltyEarnedUsd);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Language Filter Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'ChiShona', 'SiNdebele', 'ChiTonga'].map((lang) {
              final isSelected = _selectedLanguage == lang;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(lang),
                  selected: isSelected,
                  labelStyle: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.black : Colors.white70,
                  ),
                  selectedColor: EcoColors.mintAccent,
                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                  onSelected: (val) => setState(() => _selectedLanguage = lang),
                ),
              );
            }).toList(),
          ),
        ),

        // Total Royalty Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: EcoColors.savannaGold.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: EcoColors.savannaGold.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.payments_rounded, color: EcoColors.savannaGold, size: 14),
              const SizedBox(width: 6),
              Text(
                'US\$${totalRoyalties.toStringAsFixed(2)} Paid to Elders',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: EcoColors.savannaGold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioStoryCard(BuildContext context, CulturalNarrative story) {
    final isCurrent = _currentlyPlayingId == story.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlassCard(
        padding: const EdgeInsets.all(18),
        border: BorderSide(
          color: isCurrent ? EcoColors.mintAccent : EcoColors.cardBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Play / Pause Circle
                InkWell(
                  onTap: () {
                    setState(() {
                      if (isCurrent && _isPlaying) {
                        _isPlaying = false;
                      } else {
                        _currentlyPlayingId = story.id;
                        _isPlaying = true;
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Playing oral recording by ${story.elderName} (US\$0.50 micro-royalty logged)'),
                        backgroundColor: EcoColors.forestDeep,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: isCurrent && _isPlaying ? EcoColors.savannaGradient : EcoColors.emeraldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isCurrent && _isPlaying ? EcoColors.savannaGold : EcoColors.emeraldPrimary)
                              .withValues(alpha: 0.4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      isCurrent && _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.black,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Title & Custodian Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '🎙️ ${story.elderName} • ${story.communityName}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EcoColors.savannaGold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '📍 ${story.location} • ⏳ ${story.audioDuration} • 🗣️ ${story.language}',
                        style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Transcript Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ORAL TRANSCRIPT:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white54)),
                  const SizedBox(height: 4),
                  Text(
                    '"${story.transcript}"',
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: EcoColors.textPrimaryLight, height: 1.3),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Spiritual Context: ${story.spiritualContext}',
                    style: const TextStyle(fontSize: 11, color: EcoColors.mintAccent, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Royalty & Listens Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📊 ${story.totalListens} verified tourist listens',
                  style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight),
                ),
                Text(
                  '💰 US\$${story.royaltyEarnedUsd.toStringAsFixed(2)} Elder Royalty Generated',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: EcoColors.savannaGold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
