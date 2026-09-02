import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/eco_colors.dart';
import '../../presentation/providers/tourism_providers.dart';

class AppShellHeader extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback? onOpenDrawer;
  const AppShellHeader({super.key, this.onOpenDrawer});

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(activeRoleProvider);
    final lodges = ref.watch(allLodgesProvider);
    final selectedLodgeId = ref.watch(selectedLodgeIdProvider);
    final currentProfile = ref.watch(currentUserProfileProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 900;
    final isTiny = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isTiny ? 10 : 18, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? EcoColors.obsidianBg.withValues(alpha: 0.98) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Drawer button on small screens
            if (isCompact && onOpenDrawer != null) ...[
              IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
                ),
                onPressed: onOpenDrawer,
              ),
              const SizedBox(width: 4),
            ],

            // Brand Logo & Title
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: EcoColors.emeraldGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: EcoColors.emeraldPrimary.withValues(alpha: 0.35),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/images/wildimpact_logo.jpg',
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(Icons.park_rounded, color: Colors.white, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'WILDIMPACT',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                          color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Active Role Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: EcoColors.emeraldPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: EcoColors.emeraldPrimary.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(currentProfile.persona.emoji, style: const TextStyle(fontSize: 11)),
                            const SizedBox(width: 4),
                            Text(
                              currentRole.label.split(' ')[0],
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: EcoColors.emeraldPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isTiny)
                    Text(
                      currentRole.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark,
                      ),
                    ),
                ],
              ),
            ),

            // Operator Lodge Selector (Only for Operator role)
            if (!isCompact && currentRole == UserRole.operator) ...[
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? EcoColors.darkCardBg : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLodgeId,
                    dropdownColor: isDark ? EcoColors.darkCardBg : Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: EcoColors.mintAccent, size: 16),
                    style: TextStyle(
                      color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    items: lodges.map((l) {
                      return DropdownMenuItem(
                        value: l.id,
                        child: Row(
                          children: [
                            const Icon(Icons.cottage_rounded, color: EcoColors.savannaGold, size: 15),
                            const SizedBox(width: 6),
                            Text(l.name, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(selectedLodgeIdProvider.notifier).state = val;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],

            // Theme Mode Toggle
            Container(
              decoration: BoxDecoration(
                color: isDark ? EcoColors.darkCardBg : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder,
                ),
              ),
              child: IconButton(
                tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: EcoColors.savannaGold,
                  size: 18,
                ),
                onPressed: () {
                  ref.read(themeModeProvider.notifier).state =
                      themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                },
              ),
            ),
            const SizedBox(width: 8),

            // Profile & Logout Menu
            PopupMenuButton<String>(
              tooltip: 'User Account & Profile',
              offset: const Offset(0, 48),
              color: isDark ? EcoColors.darkCardBg : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? EcoColors.forestDeep.withValues(alpha: 0.6) : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? EcoColors.cardBorder : EcoColors.emeraldPrimary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: EcoColors.emeraldPrimary,
                      child: Text(
                        currentProfile.fullName.isNotEmpty ? currentProfile.fullName[0].toUpperCase() : 'M',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                    ),
                    if (!isTiny) ...[
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentProfile.fullName.split(' ')[0],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isDark ? EcoColors.mintAccent : EcoColors.emeraldDark,
                            ),
                          ),
                          Text(
                            currentProfile.persona.title.split(' ')[0],
                            style: TextStyle(
                              fontSize: 9.5,
                              color: isDark ? EcoColors.textMuted : EcoColors.textSecondaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: isDark ? EcoColors.textMuted : EcoColors.textSecondaryDark,
                      ),
                    ],
                  ],
                ),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentProfile.fullName,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        currentProfile.email,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? EcoColors.textMuted : EcoColors.textSecondaryDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.verified_rounded, size: 13, color: EcoColors.savannaGold),
                          const SizedBox(width: 4),
                          Text(
                            'Verified ${currentProfile.persona.title}',
                            style: const TextStyle(fontSize: 10.5, color: EcoColors.savannaGold, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'switch_role',
                  child: const Row(
                    children: [
                      Icon(Icons.switch_account_rounded, size: 18, color: EcoColors.mintAccent),
                      SizedBox(width: 10),
                      Text('Switch Account / Role', style: TextStyle(fontSize: 12.5)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'sign_out',
                  child: const Row(
                    children: [
                      Icon(Icons.logout_rounded, size: 18, color: EcoColors.error),
                      SizedBox(width: 10),
                      Text('Sign Out', style: TextStyle(fontSize: 12.5, color: EcoColors.error)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'sign_out' || value == 'switch_role') {
                  ref.read(currentUserProfileProvider.notifier).signOut();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
