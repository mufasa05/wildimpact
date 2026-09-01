import 'package:flutter/material.dart';
import '../theme/eco_colors.dart';
import '../../domain/models/trail_elevation_data.dart';
import 'safari_glow_button.dart';

class ReportObstacleModal extends StatefulWidget {
  final String trailId;
  final String trailName;
  final Function(TrailObstacleReport report) onObstacleReported;

  const ReportObstacleModal({
    super.key,
    required this.trailId,
    required this.trailName,
    required this.onObstacleReported,
  });

  static void show(
    BuildContext context, {
    required String trailId,
    required String trailName,
    required Function(TrailObstacleReport) onObstacleReported,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (c) => ReportObstacleModal(
        trailId: trailId,
        trailName: trailName,
        onObstacleReported: onObstacleReported,
      ),
    );
  }

  @override
  State<ReportObstacleModal> createState() => _ReportObstacleModalState();
}

class _ReportObstacleModalState extends State<ReportObstacleModal> {
  String _selectedObstacleType = 'Fallen Tree / Branch';
  final _descController = TextEditingController();
  final _distanceController = TextEditingController(text: '450');
  final _reporterNameController = TextEditingController(text: 'Field Scout Sibanda');
  bool _isPhotoAttached = false;

  @override
  void dispose() {
    _descController.dispose();
    _distanceController.dispose();
    _reporterNameController.dispose();
    super.dispose();
  }

  void _submitObstacle() {
    if (_descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe the trail obstruction'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final newReport = TrailObstacleReport(
      id: 'obs-${DateTime.now().millisecondsSinceEpoch}',
      trailId: widget.trailId,
      obstacleType: _selectedObstacleType,
      description: _descController.text.trim(),
      distanceMeters: double.tryParse(_distanceController.text) ?? 200.0,
      latitude: -17.9244 + (0.002 * (DateTime.now().second % 5)),
      longitude: 25.8560 + (0.002 * (DateTime.now().second % 5)),
      reporterName: _reporterNameController.text.trim(),
      reportedAt: DateTime.now(),
      isResolved: false,
    );

    widget.onObstacleReported(newReport);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Accessibility alert logged & broadcast to GIS maintenance rangers!'),
        backgroundColor: EcoColors.forestDeep,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0C1B15),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: EcoColors.sunsetGlow, width: 2)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: EcoColors.sunsetGlow.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.report_problem_rounded, color: EcoColors.sunsetGlow, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LOG TRAIL ACCESSIBILITY BARRIER / HAZARD',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: EcoColors.sunsetGlow, letterSpacing: 1.0),
                      ),
                      Text(
                        widget.trailName,
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Obstacle Type Dropdown
            const Text('OBSTACLE TYPE:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white70)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedObstacleType,
                  dropdownColor: const Color(0xFF0C1B15),
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                  isExpanded: true,
                  items: [
                    'Fallen Tree / Branch',
                    'Eroded Boardwalk Ramp',
                    'Severe Water / Mud Inundation',
                    'Steep Unassisted Granite Incline',
                    'Missing Tactile Paver',
                  ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: (val) => setState(() => _selectedObstacleType = val!),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Distance along trail & Reporter Name
            Row(
              children: [
                Expanded(
                  child: _buildTextField('Approx. Distance (Meters from Trailhead)', _distanceController),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField('Reporter / Scout Name', _reporterNameController),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Description
            _buildTextField('Detailed Description of Obstruction', _descController, maxLines: 3),
            const SizedBox(height: 14),

            // Photo Capture simulation button
            InkWell(
              onTap: () {
                setState(() => _isPhotoAttached = !_isPhotoAttached);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _isPhotoAttached ? EcoColors.emeraldPrimary.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _isPhotoAttached ? EcoColors.mintAccent : Colors.white12),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isPhotoAttached ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
                      color: _isPhotoAttached ? EcoColors.mintAccent : Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isPhotoAttached ? 'GPS Photo Geo-Tagged & Attached (1.4MB)' : 'Attach GPS Camera Snapshot',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _isPhotoAttached ? EcoColors.mintAccent : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: SafariGlowButton(
                text: 'Broadcast Obstacle to Maintenance Crew',
                icon: Icons.send_rounded,
                onPressed: _submitObstacle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.35),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white12)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white12)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: EcoColors.emeraldPrimary, width: 1.5)),
          ),
        ),
      ],
    );
  }
}
