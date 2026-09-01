import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../../core/widgets/animated_progress_bar.dart';
import '../../../core/widgets/safari_glow_button.dart';
import 'offset_checkout_dialog.dart';

class GamificationBadgesScreen extends ConsumerStatefulWidget {
  const GamificationBadgesScreen({super.key});

  @override
  ConsumerState<GamificationBadgesScreen> createState() =>
      _GamificationBadgesScreenState();
}

class _GamificationBadgesScreenState
    extends ConsumerState<GamificationBadgesScreen> {
  final List<Map<String, dynamic>> _badges = [
    {
      'title': 'Elephant Corridor Guardian',
      'desc': 'Funded 3+ verified anti-poaching ranger patrols in Hwange Buffer Zone.',
      'icon': '🐘',
      'isUnlocked': true,
      'unlockedAt': 'Unlocked Aug 2026',
      'tier': 'Gold Tier',
      'shareText': 'I just earned the 🐘 Elephant Corridor Guardian badge for funding anti-poaching ranger patrols in Hwange! #WildImpact #EcoTravel',
    },
    {
      'title': 'Rural Solar Champion',
      'desc': 'Funded 2.0+ tonnes of solar microgrid infrastructure for Dete schools.',
      'icon': '☀️',
      'isUnlocked': true,
      'unlockedAt': 'Unlocked Aug 2026',
      'tier': 'Platinum Tier',
      'shareText': 'I earned the ☀️ Rural Solar Champion badge! My safari funded solar microgrids for rural schools in Zimbabwe. #WildImpact',
    },
    {
      'title': 'CAMPFIRE Community Hero',
      'desc': 'Contributed directly to household-level revenue sharing in Gokwe/Binga.',
      'icon': '🤝',
      'isUnlocked': true,
      'unlockedAt': 'Unlocked Aug 2026',
      'tier': 'Silver Tier',
      'shareText': 'Proud to have earned the 🤝 CAMPFIRE Community Hero badge by directly funding Zimbabwean community conservation! #WildImpact',
    },
    {
      'title': 'Indigenous Forest Restorer',
      'desc': 'Plant 50 native Zambezi teak trees in deforested wildlife corridors.',
      'icon': '🌳',
      'isUnlocked': false,
      'progress': 0.65,
      'tier': 'Locked (32/50 Trees)',
      'unlockCost': 15.0,
    },
    {
      'title': 'Zero-Poaching Milestone Pioneer',
      'desc': 'Support 10 snare sweep missions across Sinamatella corridor.',
      'icon': '🛡️',
      'isUnlocked': false,
      'progress': 0.40,
      'tier': 'Locked (4/10 Sweeps)',
      'unlockCost': 25.0,
    },
    {
      'title': 'Wild Dog Sanctuary Ally',
      'desc': 'Help sponsor satellite collar tracking for painted dog packs.',
      'icon': '🐾',
      'isUnlocked': false,
      'progress': 0.20,
      'tier': 'Locked (1/5 Packs)',
      'unlockCost': 20.0,
    },
  ];

  final List<Map<String, dynamic>> _leaderboard = [
    {'rank': 1, 'name': 'Marcus Lindqvist', 'country': '🇸🇪 Sweden', 'tonnes': '14.2 t', 'points': '2,840 pts', 'isTop': true},
    {'rank': 2, 'name': 'Elena Rostova (You)', 'country': '🇩🇪 Germany', 'tonnes': '10.8 t', 'points': '2,160 pts', 'isUser': true},
    {'rank': 3, 'name': 'David & Claire Thorne', 'country': '🇬🇧 UK', 'tonnes': '8.5 t', 'points': '1,700 pts'},
    {'rank': 4, 'name': 'Tinashe Mudzingwa', 'country': '🇿🇼 Zimbabwe', 'tonnes': '6.4 t', 'points': '1,280 pts'},
    {'rank': 5, 'name': 'Sophie Laurent', 'country': '🇫🇷 France', 'tonnes': '5.1 t', 'points': '1,020 pts'},
  ];

  void _onBadgeTap(Map<String, dynamic> badge) {
    if (badge['isUnlocked'] == true) {
      _showShareDialog(badge);
    } else {
      _showUnlockDialog(badge);
    }
  }

  void _showShareDialog(Map<String, dynamic> badge) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: EcoColors.darkCardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: EcoColors.savannaGold.withValues(alpha: 0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(badge['icon'] as String,
                        style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(badge['title'] as String,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: EcoColors.textPrimaryLight)),
                          Text(badge['unlockedAt'] as String,
                              style: const TextStyle(
                                  fontSize: 11, color: EcoColors.mintAccent)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: EcoColors.textMuted, size: 18),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: EcoColors.cardBorder),
                  ),
                  child: Text(badge['shareText'] as String,
                      style: const TextStyle(
                          fontSize: 12.5,
                          color: EcoColors.textSecondaryLight,
                          height: 1.4)),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: SafariGlowButton(
                        text: 'Share on LinkedIn',
                        icon: Icons.share_rounded,
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: EcoColors.forestDeep,
                              content: Text(
                                  '${badge['title']} badge shared to LinkedIn! 🎉'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SafariGlowButton(
                        text: 'Copy Badge',
                        icon: Icons.copy_rounded,
                        isSecondary: true,
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: EcoColors.forestDeep,
                              content:
                                  Text('Badge text copied to clipboard!'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUnlockDialog(Map<String, dynamic> badge) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: EcoColors.darkCardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: EcoColors.emeraldPrimary.withValues(alpha: 0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(badge['icon'] as String,
                    style: const TextStyle(fontSize: 42)),
                const SizedBox(height: 12),
                Text(badge['title'] as String,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: EcoColors.textPrimaryLight),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(badge['desc'] as String,
                    style: const TextStyle(
                        fontSize: 12.5,
                        color: EcoColors.textSecondaryLight,
                        height: 1.4),
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
                AnimatedProgressBar(
                    progress: (badge['progress'] as double?) ?? 0.0,
                    height: 8),
                const SizedBox(height: 8),
                Text(badge['tier'] as String,
                    style: const TextStyle(
                        fontSize: 11, color: EcoColors.textMuted)),
                const SizedBox(height: 20),
                SafariGlowButton(
                  text: 'Unlock via Carbon Offset (\$${(badge['unlockCost'] as double?)?.toStringAsFixed(0)})',
                  icon: Icons.lock_open_rounded,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    showDialog(
                      context: context,
                      builder: (ctx2) => OffsetCheckoutDialog(
                        defaultTonnes: ((badge['unlockCost'] as double?) ?? 15.0) / 12.5,
                        onPurchaseSuccess: (_) {
                          setState(() => badge['isUnlocked'] = true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: EcoColors.forestDeep,
                              content: Text(
                                  '${badge['icon']} ${badge['title']} UNLOCKED! 🎉'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Maybe Later',
                      style: TextStyle(color: EcoColors.textMuted)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 850;
    final unlockedCount = _badges.where((b) => b['isUnlocked'] == true).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Conservation Achievements & Eco-Leaderboard',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: EcoColors.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Earn verified conservation badges for funding ranger patrols and community solar projects',
                    style: TextStyle(fontSize: 13, color: EcoColors.textSecondaryLight),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  EcoBadge.gold(
                      text: 'Rank #2 Contributor',
                      icon: Icons.emoji_events_rounded),
                  const SizedBox(height: 4),
                  Text(
                    '$unlockedCount/${_badges.length} Badges Unlocked',
                    style: const TextStyle(
                        fontSize: 11, color: EcoColors.textSecondaryLight),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          isMobile
              ? Column(
                  children: [
                    _buildBadgesGrid(),
                    const SizedBox(height: 24),
                    _buildLeaderboardCard(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildBadgesGrid()),
                    const SizedBox(width: 24),
                    SizedBox(width: 380, child: _buildLeaderboardCard()),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildBadgesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Conservation Milestone Badges',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: EcoColors.textPrimaryLight),
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap a badge to share it or unlock it via carbon offset',
          style: TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 450;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isSmall ? 1 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: isSmall ? 150 : 175,
              ),
              itemCount: _badges.length,
              itemBuilder: (context, idx) {
                final b = _badges[idx];
                final unlocked = b['isUnlocked'] as bool;

                return GestureDetector(
                  onTap: () => _onBadgeTap(b),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: unlocked
                          ? EcoColors.darkCardBg
                          : Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: unlocked
                            ? EcoColors.savannaGold.withValues(alpha: 0.35)
                            : EcoColors.cardBorder,
                        width: unlocked ? 1.5 : 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: unlocked
                                      ? EcoColors.savannaGold
                                          .withValues(alpha: 0.2)
                                      : Colors.white.withValues(alpha: 0.05),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(b['icon'] as String,
                                    style: const TextStyle(fontSize: 20)),
                              ),
                              Icon(
                                unlocked
                                    ? Icons.share_rounded
                                    : Icons.lock_outline_rounded,
                                size: 14,
                                color: unlocked
                                    ? EcoColors.mintAccent
                                    : EcoColors.textMuted,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                b['title'] as String,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: unlocked
                                      ? EcoColors.textPrimaryLight
                                      : EcoColors.textSecondaryLight,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                b['desc'] as String,
                                style: const TextStyle(
                                    fontSize: 10.5,
                                    color: EcoColors.textSecondaryLight),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          if (unlocked)
                            Row(
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    size: 12, color: EcoColors.mintAccent),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    b['unlockedAt'] as String,
                                    style: const TextStyle(
                                        fontSize: 9.5,
                                        color: EcoColors.mintAccent,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedProgressBar(
                                    progress: (b['progress'] as double?) ?? 0.0,
                                    height: 5),
                                const SizedBox(height: 4),
                                Text(
                                  b['tier'] as String,
                                  style: const TextStyle(
                                      fontSize: 9.5, color: EcoColors.textMuted),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildLeaderboardCard() {
    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Top Safari Protectors',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: EcoColors.textPrimaryLight),
              ),
              Icon(Icons.military_tech_rounded,
                  color: EcoColors.savannaGold, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          const Text('August 2026 Eco-Contributions',
              style: TextStyle(
                  fontSize: 11.5, color: EcoColors.textSecondaryLight)),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _leaderboard.length,
            separatorBuilder: (ctx, i) =>
                const Divider(color: EcoColors.cardBorder, height: 16),
            itemBuilder: (ctx, i) {
              final item = _leaderboard[i];
              final isUser = item['isUser'] == true;

              return GestureDetector(
                onTap: isUser
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: EcoColors.forestDeep,
                            content: Text(
                                'Your profile: Elena Rostova • Rank #2 • 10.8 tonnes offset • \$57.50 funded'),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  padding: isUser
                      ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
                      : EdgeInsets.zero,
                  decoration: isUser
                      ? BoxDecoration(
                          color:
                              EcoColors.emeraldPrimary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: EcoColors.emeraldPrimary
                                  .withValues(alpha: 0.5)),
                        )
                      : null,
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: item['rank'] == 1
                              ? EcoColors.savannaGold
                              : item['rank'] == 2
                                  ? EcoColors.mintAccent
                                  : Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${item['rank']}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: (item['rank'] as int) <= 2
                                ? Colors.black
                                : EcoColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] as String,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isUser
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: isUser
                                    ? EcoColors.mintAccent
                                    : EcoColors.textPrimaryLight,
                              ),
                            ),
                            Text(item['country'] as String,
                                style: const TextStyle(
                                    fontSize: 10.5, color: EcoColors.textMuted)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item['tonnes'] as String,
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: EcoColors.textPrimaryLight)),
                          Text(item['points'] as String,
                              style: const TextStyle(
                                  fontSize: 10, color: EcoColors.savannaGold)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),
          // Challenge other guests
          SafariGlowButton(
            text: 'Challenge a Friend',
            icon: Icons.group_add_rounded,
            isSecondary: true,
            width: double.infinity,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: EcoColors.forestDeep,
                  content: Text(
                      'Challenge link copied! Share with your travel companions to see who offsets more. 🏆'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
