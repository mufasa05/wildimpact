import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../../domain/models/conservation_project.dart';
import '../../providers/tourism_providers.dart';

class AddMilestoneDialog extends ConsumerStatefulWidget {
  final List<ConservationProject> projects;
  final ConservationProject? initialProject;

  const AddMilestoneDialog({
    super.key,
    required this.projects,
    this.initialProject,
  });

  @override
  ConsumerState<AddMilestoneDialog> createState() => _AddMilestoneDialogState();
}

class _AddMilestoneDialogState extends ConsumerState<AddMilestoneDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedProjectId;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _metricDeltaController = TextEditingController(text: '25');
  final _rangerController = TextEditingController(text: 'Chief Ranger Sibanda');
  final _latController = TextEditingController(text: '-18.7322');
  final _lngController = TextEditingController(text: '26.9535');
  bool _isSimulatingGps = false;

  @override
  void initState() {
    super.initState();
    _selectedProjectId = widget.initialProject?.id ?? widget.projects.first.id;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _metricDeltaController.dispose();
    _rangerController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _detectGps() {
    setState(() => _isSimulatingGps = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _latController.text = (-18.7322 + (0.01 * (DateTime.now().second % 10))).toStringAsFixed(4);
          _lngController.text = (26.9535 + (0.01 * (DateTime.now().second % 10))).toStringAsFixed(4);
          _isSimulatingGps = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedProj = widget.projects.firstWhere(
      (p) => p.id == _selectedProjectId,
      orElse: () => widget.projects.first,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: GlassCard(
          backgroundColor: EcoColors.darkCardBg,
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: EcoColors.emeraldPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add_location_alt_rounded, color: EcoColors.mintAccent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Log Conservation Milestone',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: EcoColors.textPrimaryLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: EcoColors.textSecondaryLight, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Project selector
                  const Text('Select Target Conservation Initiative', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EcoColors.textSecondaryLight)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: EcoColors.cardBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedProjectId,
                        isExpanded: true,
                        dropdownColor: EcoColors.darkCardBg,
                        style: const TextStyle(color: EcoColors.textPrimaryLight, fontSize: 13, fontWeight: FontWeight.w600),
                        items: widget.projects.map((p) {
                          return DropdownMenuItem(
                            value: p.id,
                            child: Row(
                              children: [
                                Text(p.type.iconEmoji),
                                const SizedBox(width: 8),
                                Expanded(child: Text(p.name, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedProjectId = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  const Text('Milestone Title / Action', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EcoColors.textSecondaryLight)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'e.g. Patrol Sector 7 North & Cleared 3 Snares'),
                    validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Metric Delta
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Impact Added (${selectedProj.unit})',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EcoColors.textSecondaryLight),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _metricDeltaController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                suffixText: selectedProj.unit,
                                suffixStyle: const TextStyle(color: EcoColors.mintAccent, fontSize: 12),
                              ),
                              validator: (v) => double.tryParse(v ?? '') == null ? 'Enter valid number' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Verified By Scout/Ranger', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EcoColors.textSecondaryLight)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _rangerController,
                              decoration: const InputDecoration(hintText: 'Ranger Sibanda'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  const Text('Observation Notes & Evidence Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EcoColors.textSecondaryLight)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'Recorded wildlife movements, fence integrity, community participation...'),
                    validator: (v) => v == null || v.isEmpty ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // GPS Geotag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GNSS Coordinates (Geo-Tagged)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EcoColors.textSecondaryLight)),
                      InkWell(
                        onTap: _detectGps,
                        child: Row(
                          children: [
                            Icon(Icons.my_location, size: 14, color: _isSimulatingGps ? EcoColors.savannaGold : EcoColors.mintAccent),
                            const SizedBox(width: 4),
                            Text(
                              _isSimulatingGps ? 'Locating...' : 'Auto-Detect GPS',
                              style: const TextStyle(fontSize: 11, color: EcoColors.mintAccent, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _latController,
                          decoration: const InputDecoration(prefixText: 'Lat: '),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _lngController,
                          decoration: const InputDecoration(prefixText: 'Lng: '),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: EcoColors.textSecondaryLight)),
                      ),
                      const SizedBox(width: 12),
                      SafariGlowButton(
                        text: 'Save Milestone',
                        icon: Icons.check_circle_rounded,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final delta = double.tryParse(_metricDeltaController.text) ?? 20.0;
                            final lat = double.tryParse(_latController.text);
                            final lng = double.tryParse(_lngController.text);

                            ref.read(conservationProjectsProvider.notifier).addMilestone(
                              projectId: _selectedProjectId,
                              title: _titleController.text,
                              description: _descController.text,
                              metricDelta: delta,
                              latitude: lat,
                              longitude: lng,
                              verifiedBy: _rangerController.text,
                            );

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: EcoColors.forestDeep,
                                content: Text('Milestone added! +$delta ${selectedProj.unit} logged to $selectedProj.name'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
