import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/eco_colors.dart';
import '../../presentation/providers/tourism_providers.dart';

class RoleSelectorAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const RoleSelectorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRole = ref.watch(activeRoleProvider);
    final lodges = ref.watch(allLodgesProvider);
    final selectedLodgeId = ref.watch(selectedLodgeIdProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 1050;
    final isMobile = screenWidth < 800;
    final isTiny = screenWidth < 450;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isTiny ? 8 : 14, vertical: 6),
      decoration: BoxDecoration(
        color: EcoColors.obsidianBg.withValues(alpha: 0.95),
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
              padding: const EdgeInsets.all(6),
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
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  'assets/images/wildimpact_logo.jpg',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(Icons.park_rounded, color: Colors.black, size: 16),
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
                      text: 'WILDIMPACT',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: EcoColors.textPrimaryLight,
                      ),
                      children: [
                        if (!isMobile)
                          const TextSpan(
                            text: ' • Eco-Impact B2B',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: EcoColors.mintAccent,
                            ),
                          ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isCompact)
                    const Text(
                      'Multi-tenant SaaS for Safari Operators, Conservation & Communities',
                      style: TextStyle(fontSize: 10.5, color: EcoColors.textSecondaryLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Lodge Selector Dropdown (Desktop)
            if (!isCompact) ...[
              Container(
                height: 36,
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
                      fontSize: 12,
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
              const SizedBox(width: 10),
            ],

            // Role Switcher Segmented Buttons
            Container(
              height: 34,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EcoColors.cardBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRoleBtn(context, ref, UserRole.operator, 'Operator', Icons.dashboard_rounded, currentRole, isMobile),
                  _buildRoleBtn(context, ref, UserRole.guest, 'Guest App', Icons.smartphone_rounded, currentRole, isMobile),
                  _buildRoleBtn(context, ref, UserRole.platformShowcase, 'Showcase', Icons.auto_awesome_rounded, currentRole, isMobile),
                  _buildRoleBtn(context, ref, UserRole.tourismBoard, 'Audit', Icons.verified_user_rounded, currentRole, isMobile),
                ],
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
    bool isMobile,
  ) {
    final isSelected = currentRole == role;
    return InkWell(
      onTap: () {
        ref.read(activeRoleProvider.notifier).state = role;
      },
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 6 : 8,
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
            if (!isMobile) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
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
