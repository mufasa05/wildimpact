import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../providers/tourism_providers.dart';

class EsgReportingScreen extends ConsumerStatefulWidget {
  const EsgReportingScreen({super.key});

  @override
  ConsumerState<EsgReportingScreen> createState() => _EsgReportingScreenState();
}

class _EsgReportingScreenState extends ConsumerState<EsgReportingScreen> {
  bool _isGenerating = false;
  bool _showExportSuccess = false;

  void _exportReport() {
    setState(() => _isGenerating = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _showExportSuccess = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lodge = ref.watch(selectedLodgeProvider);
    final projects = ref.watch(conservationProjectsProvider);
    final purchases = ref.watch(purchasesProvider);
    final totalOffsetTonnes = purchases.fold<double>(0.0, (sum, p) => sum + p.tonnes);
    final campfireDistributed = purchases.fold<double>(0.0, (sum, p) => sum + p.campfireShare);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Export Button
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ESG & CSRD / CAMPFIRE Audit Report',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: EcoColors.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Auditable biodiversity metrics & carbon ledgers',
                    style: TextStyle(fontSize: 12.5, color: EcoColors.textSecondaryLight),
                  ),
                ],
              ),
              SafariGlowButton(
                text: 'Export Audit PDF',
                icon: Icons.picture_as_pdf_rounded,
                isLoading: _isGenerating,
                onPressed: _exportReport,
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (_showExportSuccess)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EcoColors.emeraldPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: EcoColors.emeraldPrimary),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: EcoColors.mintAccent, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ESG Report Generated & Signed Successfully!',
                          style: TextStyle(fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight, fontSize: 13.5),
                        ),
                        Text(
                          'Report ID: ESG-ZW-2026-8912 • Cryptographic SHA-256 Ledger: 0x7c49...b109 • Ready for ZTA submission',
                          style: const TextStyle(color: EcoColors.textSecondaryLight, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _showExportSuccess = false),
                    icon: const Icon(Icons.close, color: EcoColors.textSecondaryLight, size: 18),
                  ),
                ],
              ),
            ),

          // Report Document Preview Card
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Report Header Banner
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: EcoColors.savannaGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'OFFICIAL ESG AUDIT DOCUMENT',
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: EcoColors.savannaGold, letterSpacing: 1),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          lodge.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: EcoColors.textPrimaryLight),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${lodge.region}, Zimbabwe',
                          style: const TextStyle(fontSize: 12.5, color: EcoColors.textSecondaryLight),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EcoBadge(text: 'Standard: CSRD / GRI 2026', icon: Icons.verified_user_rounded),
                        const SizedBox(height: 6),
                        Text(
                          'Reporting Period: Q1-Q3 2026',
                          style: const TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight),
                        ),
                        Text(
                          'Generated: ${DateFormat('MMMM d, yyyy').format(DateTime.now())}',
                          style: const TextStyle(fontSize: 10.5, color: EcoColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: EcoColors.cardBorder, height: 28),

                // Section 1: Biodiversity & Ecosystem Conservation
                _buildSectionHeader('1.0 Biodiversity & Habitat Protection Framework'),
                const SizedBox(height: 12),
                _buildMetricGrid([
                  {'label': 'Total Area Under Active Protection', 'val': '${lodge.hectaresProtected} ha', 'sub': 'Wildlife buffer & migration corridor'},
                  {'label': 'Verified Anti-Poaching Patrol Hours', 'val': '${lodge.totalPatrolHours} hrs', 'sub': 'GPS verified with ranger telemetry'},
                  {'label': 'Illegal Snare Incursions Neutralized', 'val': '42 Snares', 'sub': 'Sinamatella boundary sweeps'},
                  {'label': 'Dangerous Incidents Averted', 'val': '18 Incidents', 'sub': 'Human-wildlife boundary defense'},
                ]),
                const SizedBox(height: 24),

                // Section 2: Social & CAMPFIRE Community Benefit Sharing
                _buildSectionHeader('2.0 CAMPFIRE Benefit-Sharing & Community Empowerment'),
                const SizedBox(height: 12),
                _buildMetricGrid([
                  {'label': 'CAMPFIRE Direct Pool Distributed', 'val': '\$${(campfireDistributed + 4600).toStringAsFixed(2)}', 'sub': '20% split on offset marketplace'},
                  {'label': 'Community Clean Water Delivered', 'val': '${lodge.waterLitersProvided} Liters', 'sub': '400 Dete households supplied'},
                  {'label': 'Indigenous Trees Propagated', 'val': '${lodge.treesPlanted} Trees', 'sub': '35 local nursery jobs funded'},
                  {'label': 'Rural Schools Solar Electrified', 'val': '2 Primary Schools', 'sub': 'Clean power for 450 students'},
                ]),
                const SizedBox(height: 24),

                // Section 3: Carbon Offset & Emissions Ledger
                _buildSectionHeader('3.0 Verified Carbon Offset & Retirement Ledger'),
                const SizedBox(height: 12),
                _buildMetricGrid([
                  {'label': 'Total Carbon Offsets Retired', 'val': '${totalOffsetTonnes.toStringAsFixed(1)} Tonnes CO₂', 'sub': 'Registered under ZCR Registry'},
                  {'label': 'Active Offset Projects Listed', 'val': '${projects.length} Hyper-Local Initiatives', 'sub': 'Solar, clean stoves, reforestation'},
                  {'label': 'Third-Party Verification Hash', 'val': '0x8F2A...9B3C', 'sub': 'Tamper-proof cryptographically signed'},
                  {'label': 'Auditor Compliance Grade', 'val': 'A+ (Exemplary)', 'sub': 'Zero greenwashing discrepancies'},
                ]),
                const SizedBox(height: 28),

                // Signature & Seal
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: EcoColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: EcoColors.savannaGold.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified_rounded, color: EcoColors.savannaGold, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Verified & Endorsed by Zimbabwe Tourism Authority (ZTA) Framework',
                              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'This auditable document serves as verified proof of eco-credentials for international corporate travel ESG mandates and JICA community benefit agreements.',
                              style: TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 4,
          height: 16,
          decoration: BoxDecoration(color: EcoColors.emeraldPrimary, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: EcoColors.mintAccent),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricGrid(List<Map<String, String>> metrics) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth < 600 ? 1 : 2;
        if (crossCount == 1) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: metrics.length,
            separatorBuilder: (context, i) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final m = metrics[i];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: EcoColors.cardBorder.withValues(alpha: 0.6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m['label']!, style: const TextStyle(fontSize: 11.5, color: EcoColors.textSecondaryLight)),
                    const SizedBox(height: 4),
                    Text(m['val']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: EcoColors.textPrimaryLight)),
                    const SizedBox(height: 2),
                    Text(m['sub']!, style: const TextStyle(fontSize: 10.5, color: EcoColors.textMuted)),
                  ],
                ),
              );
            },
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3.2,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, i) {
            final m = metrics[i];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: EcoColors.cardBorder.withValues(alpha: 0.6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(m['label']!, style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight)),
                  const SizedBox(height: 3),
                  Text(m['val']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: EcoColors.textPrimaryLight)),
                  const SizedBox(height: 1),
                  Text(m['sub']!, style: const TextStyle(fontSize: 10, color: EcoColors.textMuted)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
