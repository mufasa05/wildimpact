import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../../core/widgets/animated_progress_bar.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../../domain/models/conservation_project.dart';
import '../../providers/tourism_providers.dart';
import 'add_milestone_dialog.dart';

class ConservationManagerScreen extends ConsumerStatefulWidget {
  const ConservationManagerScreen({super.key});

  @override
  ConsumerState<ConservationManagerScreen> createState() => _ConservationManagerScreenState();
}

class _ConservationManagerScreenState extends ConsumerState<ConservationManagerScreen> {
  ProjectType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(conservationProjectsProvider);
    final filteredProjects = _selectedFilter == null
        ? projects
        : projects.where((p) => p.type == _selectedFilter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 14,
            runSpacing: 10,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Conservation Initiatives',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: EcoColors.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Track verified ranger patrols, water distribution & reforestation',
                    style: TextStyle(fontSize: 12.5, color: EcoColors.textSecondaryLight),
                  ),
                ],
              ),
              SafariGlowButton(
                text: 'Add Milestone',
                icon: Icons.add_location_alt_rounded,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AddMilestoneDialog(projects: projects),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All Initiatives', null),
                ...ProjectType.values.map((type) {
                  return _buildFilterChip('${type.iconEmoji} ${type.displayName}', type);
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Project Cards with Milestones
          if (filteredProjects.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text('No conservation initiatives found in this category.', style: TextStyle(color: EcoColors.textSecondaryLight)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProjects.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final proj = filteredProjects[index];
                return _buildDetailedProjectCard(proj, projects);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ProjectType? type) {
    final isSelected = _selectedFilter == type;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? type : null;
          });
        },
        selectedColor: EcoColors.emeraldPrimary,
        backgroundColor: EcoColors.darkCardBg,
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : EcoColors.textSecondaryLight,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? EcoColors.emeraldPrimary : EcoColors.cardBorder,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedProjectCard(ConservationProject proj, List<ConservationProject> allProjects) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: EcoColors.emeraldPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(proj.type.iconEmoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          proj.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: EcoColors.textPrimaryLight,
                          ),
                        ),
                        EcoBadge(text: proj.type.displayName),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      proj.description,
                      style: const TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SafariGlowButton(
            text: '+ Log Progress Milestone',
            isSecondary: true,
            height: 36,
            width: double.infinity,
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AddMilestoneDialog(projects: allProjects, initialProject: proj),
              );
            },
          ),
          const SizedBox(height: 18),

          // Progress section
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 4,
            children: [
              Text(
                'Target: ${proj.targetMetric.toInt()} ${proj.unit}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EcoColors.textSecondaryLight),
              ),
              Text(
                'Achieved: ${proj.currentMetric.toInt()} ${proj.unit} (${(proj.progressPercentage * 100).toStringAsFixed(1)}%)',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: EcoColors.mintAccent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedProgressBar(progress: proj.progressPercentage, height: 10),
          const SizedBox(height: 20),

          // Milestones list header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.history_rounded, size: 16, color: EcoColors.savannaGold),
                  const SizedBox(width: 6),
                  Text(
                    'Milestone Log (${proj.milestones.length})',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                  ),
                ],
              ),
              if (proj.latitude != null && proj.longitude != null)
                EcoBadge(
                  text: '📍 ${proj.latitude!.toStringAsFixed(3)}, ${proj.longitude!.toStringAsFixed(3)}',
                  backgroundColor: Colors.transparent,
                  textColor: EcoColors.textSecondaryLight,
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (proj.milestones.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: EcoColors.cardBorder.withValues(alpha: 0.5)),
              ),
              child: const Center(
                child: Text('No verified field milestones recorded yet. Click "+ Log Progress" to add first record.', style: TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: proj.milestones.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, mIdx) {
                final m = proj.milestones[mIdx];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: EcoColors.cardBorder.withValues(alpha: 0.6)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: EcoColors.emeraldPrimary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded, color: EcoColors.mintAccent, size: 14),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Text(
                                  m.title,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                                ),
                                Text(
                                  DateFormat('MMM d, yyyy').format(m.createdAt),
                                  style: const TextStyle(fontSize: 11, color: EcoColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              m.description,
                              style: const TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                EcoBadge(
                                  text: '+${m.metricDelta.toInt()} ${proj.unit}',
                                  fontSize: 10,
                                ),
                                if (m.verifiedBy != null)
                                  Text(
                                    'Verified: ${m.verifiedBy}',
                                    style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight),
                                  ),
                                if (m.latitude != null)
                                  Text(
                                    '• GNSS ${m.latitude!.toStringAsFixed(3)}, ${m.longitude!.toStringAsFixed(3)}',
                                    style: const TextStyle(fontSize: 10.5, color: EcoColors.textMuted),
                                  ),
                              ],
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
