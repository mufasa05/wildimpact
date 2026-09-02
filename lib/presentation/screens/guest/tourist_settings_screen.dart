import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../providers/tourism_providers.dart';

class TouristSettingsScreen extends ConsumerStatefulWidget {
  const TouristSettingsScreen({super.key});

  @override
  ConsumerState<TouristSettingsScreen> createState() => _TouristSettingsScreenState();
}

class _TouristSettingsScreenState extends ConsumerState<TouristSettingsScreen> {
  String _currency = 'USD (\$)';
  bool _offlineMapsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);
    final profile = ref.watch(currentUserProfileProvider);

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
                    'Preferences & Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Customize theme, currencies, offline downloads, and eco-receipt settings.',
                    style: TextStyle(fontSize: 13, color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                  ),
                ],
              ),
              EcoBadge(text: 'Profile: ${profile.fullName}', fontSize: 11),
            ],
          ),
          const SizedBox(height: 24),

          // Appearance & Theme
          _buildSectionHeader('APPEARANCE & THEME', isDark),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? EcoColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: EcoColors.savannaGold,
                      size: 24,
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDark ? 'Obsidian Dark Theme' : 'Savanna Light Theme',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          isDark ? 'Deep contrast emerald & gold theme' : 'Crisp ivory safari theme',
                          style: TextStyle(fontSize: 11.5, color: isDark ? EcoColors.textMuted : EcoColors.textMutedDark),
                        ),
                      ],
                    ),
                  ],
                ),
                Switch(
                  value: themeMode == ThemeMode.dark,
                  activeThumbColor: EcoColors.emeraldPrimary,
                  onChanged: (val) {
                    ref.read(themeModeProvider.notifier).state = val ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Currency & Payments
          _buildSectionHeader('CURRENCY & REGIONAL', isDark),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? EcoColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.currency_exchange_rounded, color: EcoColors.mintAccent, size: 24),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Display Currency',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          'Used for lodges, permits & artisan pricing',
                          style: TextStyle(fontSize: 11.5, color: isDark ? EcoColors.textMuted : EcoColors.textMutedDark),
                        ),
                      ],
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: _currency,
                  dropdownColor: isDark ? EcoColors.darkCardBg : Colors.white,
                  underline: const SizedBox(),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'USD (\$)', child: Text('USD (\$)')),
                    DropdownMenuItem(value: 'ZiG (ZWG)', child: Text('ZiG (ZWG)')),
                    DropdownMenuItem(value: 'EUR (€)', child: Text('EUR (€)')),
                    DropdownMenuItem(value: 'GBP (£)', child: Text('GBP (£)')),
                    DropdownMenuItem(value: 'ZAR (R)', child: Text('ZAR (R)')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _currency = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Offline Pack & Storage
          _buildSectionHeader('OFFLINE SAFARI PACKS', isDark),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? EcoColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.download_for_offline_rounded, color: EcoColors.savannaGold, size: 24),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Offline Topo Maps & Trails',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              'GPS navigation when in remote national parks',
                              style: TextStyle(fontSize: 11.5, color: isDark ? EcoColors.textMuted : EcoColors.textMutedDark),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: _offlineMapsEnabled,
                      activeThumbColor: EcoColors.emeraldPrimary,
                      onChanged: (val) => setState(() => _offlineMapsEnabled = val),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Downloaded Packs:', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87)),
                    Text('Hwange + Victoria Falls (142 MB)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: EcoColors.mintAccent)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Sign Out Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(currentUserProfileProvider.notifier).signOut();
              },
              icon: const Icon(Icons.logout_rounded, color: EcoColors.error),
              label: const Text('Sign Out of Account', style: TextStyle(color: EcoColors.error, fontWeight: FontWeight.w800)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: EcoColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.9,
        color: isDark ? EcoColors.savannaGold : EcoColors.terracotta,
      ),
    );
  }
}
