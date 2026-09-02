import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/immersive_background_scaffold.dart';
import '../../../core/widgets/waveform_audio_player.dart';
import '../../../core/widgets/elder_payout_modal.dart';
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
  String? _selectedStoryId;
  final TextEditingController _ragSearchController = TextEditingController();
  String? _ragAnswer;
  String _selectedLanguage = 'All';
  double _elderWalletBalanceUsd = 64.50;

  @override
  void initState() {
    super.initState();
    _selectedStoryId = 'story-1';
  }

  @override
  void dispose() {
    _ragSearchController.dispose();
    super.dispose();
  }

  void _streamOralRagAnswer(String fullAnswer) {
    setState(() {
      _ragAnswer = '';
    });

    int charIndex = 0;
    Timer.periodic(const Duration(milliseconds: 18), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (charIndex < fullAnswer.length) {
        setState(() {
          _ragAnswer = fullAnswer.substring(0, charIndex + 1);
          charIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _askOralRag(String query) {
    _ragSearchController.text = query;
    String answer;
    if (query.toLowerCase().contains('bird') || query.toLowerCase().contains('great zimbabwe')) {
      answer =
          '🦅 **Elder Oral Tradition (ChiShona Translation)**: The Hungwe (Bateleur Eagle) carved on the soapstone pillars represents the spiritual messenger between Mwari (The Supreme Creator) and the Shona kings. It was never a mere ornament—its presence at the Eastern Enclosure signaled divine peace, righteous governance, and timely seasonal rains for the kingdom.';
    } else if (query.toLowerCase().contains('njelele') || query.toLowerCase().contains('matobo')) {
      answer =
          '🌧️ **Gogo Sibanda (SiNdebele Keeper of Matobo)**: Njelele is an ancient spiritual oracle. In times of drought, designated clan elders walk the granite valleys barefoot with black cattle offerings. The sacred rock caves whisper the rain forecasts through natural acoustic chambers that resonate across the Matopos.';
    } else {
      answer =
          '✨ **Multi-Vocal Knowledge Retrieval**: Authenticated oral archives confirm that indigenous tourism corridors in Zimbabwe were designed around seasonal spiritual calendars, preserving sacred baobab groves, medicinal wild herbs, and river sanctuaries for generations.';
    }

    _streamOralRagAnswer(answer);
  }

  @override
  Widget build(BuildContext context) {
    final narratives = ref.watch(culturalNarrativesProvider);
    final filtered = _selectedLanguage == 'All'
        ? narratives
        : narratives.where((n) => n.language == _selectedLanguage).toList();

    final activeStory = narratives.firstWhere(
      (n) => n.id == _selectedStoryId,
      orElse: () => narratives.first,
    );

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

            // Active Interactive Waveform Audio Player
            WaveformAudioPlayer(
              key: ValueKey(activeStory.id),
              title: activeStory.title,
              elderName: activeStory.elderName,
              language: activeStory.language,
              transcript: activeStory.transcript,
              totalDuration: const Duration(seconds: 48),
              onListenCompleted: () {
                setState(() {
                  _elderWalletBalanceUsd += 0.50;
                  activeStory.royaltyEarnedUsd += 0.50;
                  activeStory.totalListens += 1;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Listen verified! +US\$0.50 credited to Elder Community Trust.'),
                    backgroundColor: EcoColors.forestDeep,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Interactive Oral RAG Search & Ask-Elder Concierge
            _buildOralRagConcierge(context),
            const SizedBox(height: 24),

            // Language Filter & Elder Royalty Wallet Summary
            _buildLanguageAndRoyaltyRow(narratives),
            const SizedBox(height: 16),

            // List of Multi-Vocal Audio Stories
            ...filtered.map((story) => _buildStorySelectionTile(context, story)),
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
          const Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: EcoColors.mintAccent, size: 18),
              SizedBox(width: 8),
              Text(
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
            runSpacing: 6,
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

        // Elder Mobile Money Payout Trigger Button
        InkWell(
          onTap: () {
            ElderPayoutModal.show(
              context,
              balance: _elderWalletBalanceUsd,
              elderName: 'Elder Mambo Chidzero',
              onPayoutSuccess: (amount) {
                setState(() {
                  _elderWalletBalanceUsd = (_elderWalletBalanceUsd - amount).clamp(0.0, 99999.0);
                });
              },
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: EcoColors.savannaGradient,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: EcoColors.savannaGold.withValues(alpha: 0.3), blurRadius: 8),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_balance_wallet_rounded, color: Colors.black, size: 14),
                const SizedBox(width: 6),
                Text(
                  'US\$${_elderWalletBalanceUsd.toStringAsFixed(2)} Disburse Payout',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStorySelectionTile(BuildContext context, CulturalNarrative story) {
    final isSelected = _selectedStoryId == story.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        border: BorderSide(
          color: isSelected ? EcoColors.mintAccent : EcoColors.cardBorder,
          width: isSelected ? 1.5 : 1.0,
        ),
        onTap: () => setState(() => _selectedStoryId = story.id),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? EcoColors.emeraldPrimary : Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? Icons.play_arrow_rounded : Icons.audiotrack_rounded,
                color: isSelected ? Colors.black : EcoColors.savannaGold,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '🎙️ ${story.elderName} • 📍 ${story.location} • 🗣️ ${story.language}',
                    style: const TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'US\$${story.royaltyEarnedUsd.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: EcoColors.savannaGold),
                ),
                Text(
                  '${story.totalListens} plays',
                  style: const TextStyle(fontSize: 10, color: EcoColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
