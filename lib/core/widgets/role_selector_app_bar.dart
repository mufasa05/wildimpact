import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/eco_colors.dart';
import '../../presentation/providers/tourism_providers.dart';
import '../../presentation/screens/auth/auth_modal_sheet.dart';

class RoleSelectorAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const RoleSelectorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(activeRoleProvider);
    final lodges = ref.watch(allLodgesProvider);
    final selectedLodgeId = ref.watch(selectedLodgeIdProvider);
    final currentProfile = ref.watch(currentUserProfileProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 1200;
    final isMobile = screenWidth < 900;
    final isTiny = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isTiny ? 8 : 14, vertical: 6),
      decoration: BoxDecoration(
        color: EcoColors.obsidianBg.withValues(alpha: 0.98),
        border: const Border(
          bottom: BorderSide(color: EcoColors.cardBorder, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Brand Logo & Title
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: EcoColors.emeraldGradient,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: EcoColors.emeraldPrimary.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                  'assets/images/wildimpact_logo.jpg',
                  width: 26,
                  height: 26,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(Icons.park_rounded, color: Colors.black, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'ZIMTOUR',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: EcoColors.textPrimaryLight,
                      ),
                      children: [
                        const TextSpan(
                          text: ' • WILDIMPACT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: EcoColors.mintAccent,
                          ),
                        ),
                        if (!isMobile)
                          const TextSpan(
                            text: ' | National Intelligence OS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: EcoColors.savannaGold,
                            ),
                          ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isCompact)
                    const Text(
                      'Universal Tourism Intelligence, Living Heritage, Accessibility & Safari ESG Platform',
                      style: TextStyle(fontSize: 10.5, color: EcoColors.textSecondaryLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Lodge Selector Dropdown (When in Operator mode)
            if (!isCompact && currentRole == UserRole.operator) ...[
              Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: EcoColors.darkCardBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: EcoColors.cardBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLodgeId,
                    dropdownColor: EcoColors.darkCardBg,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: EcoColors.mintAccent, size: 16),
                    style: const TextStyle(
                      color: EcoColors.textPrimaryLight,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                    items: lodges.map((l) {
                      return DropdownMenuItem(
                        value: l.id,
                        child: Row(
                          children: [
                            const Icon(Icons.cottage_rounded, color: EcoColors.savannaGold, size: 14),
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
              const SizedBox(width: 8),
            ],

            // Role Switcher Segmented Buttons (Scrollable on small screens)
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: EcoColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildRoleBtn(context, ref, UserRole.nationalZta, 'ZTA Intel', Icons.analytics_rounded, currentRole, isTiny),
                      _buildRoleBtn(context, ref, UserRole.culturalHeritage, 'Living Heritage', Icons.record_voice_over_rounded, currentRole, isTiny),
                      _buildRoleBtn(context, ref, UserRole.accessibility, 'Accessibility', Icons.accessible_rounded, currentRole, isTiny),
                      _buildRoleBtn(context, ref, UserRole.operator, 'Lodge Hub', Icons.cottage_rounded, currentRole, isTiny),
                      _buildRoleBtn(context, ref, UserRole.providerPortal, 'SME Portal', Icons.handshake_rounded, currentRole, isTiny),
                      _buildRoleBtn(context, ref, UserRole.guest, 'Guest App', Icons.smartphone_rounded, currentRole, isTiny),
                      _buildRoleBtn(context, ref, UserRole.platformShowcase, 'Deck', Icons.auto_awesome_rounded, currentRole, isTiny),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Profile / Auth Avatar Button
            InkWell(
              onTap: () => AuthModalSheet.show(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: EcoColors.forestDeep.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: EcoColors.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(currentProfile.persona.emoji, style: const TextStyle(fontSize: 14)),
                    if (!isTiny) ...[
                      const SizedBox(width: 4),
                      Text(
                        currentProfile.fullName.split(' ')[0],
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: EcoColors.mintAccent),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBtn(
    BuildContext context,
    WidgetRef ref,
    UserRole role,
    String label,
    IconData icon,
    UserRole currentRole,
    bool isTiny,
  ) {
    final isSelected = currentRole == role;
    return InkWell(
      onTap: () {
        ref.read(activeRoleProvider.notifier).state = role;
      },
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: isTiny ? 6 : 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? EcoColors.emeraldPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.black : EcoColors.textSecondaryLight,
            ),
            if (!isTiny) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? Colors.black : EcoColors.textSecondaryLight,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
