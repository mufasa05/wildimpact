import 'package:flutter/material.dart';
import '../theme/eco_colors.dart';
import '../../domain/models/artisan_order.dart';
import 'safari_glow_button.dart';

class ArtisanCommissionModal extends StatefulWidget {
  final String artisanName;
  final String artisanVillage;
  final String artisanWhatsApp;

  const ArtisanCommissionModal({
    super.key,
    required this.artisanName,
    required this.artisanVillage,
    required this.artisanWhatsApp,
  });

  static void show(
    BuildContext context, {
    required String artisanName,
    required String artisanVillage,
    required String artisanWhatsApp,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (c) => ArtisanCommissionModal(
        artisanName: artisanName,
        artisanVillage: artisanVillage,
        artisanWhatsApp: artisanWhatsApp,
      ),
    );
  }

  @override
  State<ArtisanCommissionModal> createState() => _ArtisanCommissionModalState();
}

class _ArtisanCommissionModalState extends State<ArtisanCommissionModal> {
  late ArtisanCommissionOrder _order;
  final _inscriptionController = TextEditingController(text: 'Mhuri (Family & Unity)');
  final _touristNameController = TextEditingController(text: 'Tawanda Moyo');

  @override
  void initState() {
    super.initState();
    _order = ArtisanCommissionOrder(
      id: 'ord-${DateTime.now().millisecondsSinceEpoch}',
      artisanName: widget.artisanName,
      artisanVillage: widget.artisanVillage,
      artisanWhatsApp: widget.artisanWhatsApp,
    );
  }

  @override
  void dispose() {
    _inscriptionController.dispose();
    _touristNameController.dispose();
    super.dispose();
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
        border: Border(top: BorderSide(color: EcoColors.mintAccent, width: 2)),
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
                  decoration: const BoxDecoration(color: EcoColors.forestDeep, shape: BoxShape.circle),
                  child: const Icon(Icons.handyman_rounded, color: EcoColors.mintAccent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'COMMISSION DIRECT SHONA SCULPTURE / CRAFT',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: EcoColors.mintAccent, letterSpacing: 1.0),
                      ),
                      Text(
                        'Artisan: ${widget.artisanName} (${widget.artisanVillage})',
                        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Material Selector
            const Text('SELECT INDIGENOUS MATERIAL:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white70)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CraftMaterial>(
                  value: _order.selectedMaterial,
                  dropdownColor: const Color(0xFF0C1B15),
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                  isExpanded: true,
                  items: CraftMaterial.values.map((mat) {
                    return DropdownMenuItem(value: mat, child: Text('${mat.label} (+US\$${mat.basePriceUsd.toInt()})'));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _order.selectedMaterial = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _order.selectedMaterial.description,
              style: const TextStyle(fontSize: 11, color: EcoColors.savannaGold, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 14),

            // Size Selector Tabs
            const Text('SELECT PIECE DIMENSIONS:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white70)),
            const SizedBox(height: 8),
            Row(
              children: CraftDimension.values.map((dim) {
                final isSelected = _order.selectedDimension == dim;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: InkWell(
                      onTap: () => setState(() => _order.selectedDimension = dim),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? EcoColors.emeraldPrimary.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isSelected ? EcoColors.mintAccent : Colors.white12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              dim.label.split(' ')[0],
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: isSelected ? EcoColors.mintAccent : Colors.white70),
                            ),
                            Text(
                              '${dim.estimatedArtisanDays} Days Carve',
                              style: const TextStyle(fontSize: 9.5, color: Colors.white54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Inscription
            _buildTextField('Custom Shona / English Inscription to Engrave', _inscriptionController, onChanged: (v) => _order.customInscription = v),
            const SizedBox(height: 16),

            // Real-Time Price & Wage Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: EcoColors.cardBorder),
              ),
              child: Column(
                children: [
                  _buildPriceRow('Material & Prep', 'US\$${_order.baseMaterialCost.toStringAsFixed(2)}'),
                  const SizedBox(height: 4),
                  _buildPriceRow('Direct Artisan Fair-Trade Wage', 'US\$${_order.artisanLaborWageUsd.toStringAsFixed(2)}', isHighlight: true),
                  const SizedBox(height: 4),
                  _buildPriceRow('Village Heritage Trust Royalty (15%)', 'US\$${_order.communityHeritageRoyaltyUsd.toStringAsFixed(2)}'),
                  const Divider(color: Colors.white12, height: 16),
                  _buildPriceRow('Total Direct Order Price', 'US\$${_order.totalOrderPriceUsd.toStringAsFixed(2)}', isTotal: true),
                  const SizedBox(height: 8),
                  Text(
                    '🔒 Cryptographic Provenance Hash: ${_order.provenanceCertificateHash}',
                    style: const TextStyle(fontSize: 10, color: EcoColors.mintAccent, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Send Inquiry Button
            SizedBox(
              width: double.infinity,
              child: SafariGlowButton(
                text: 'Send Commission Payload via WhatsApp (0% Fee)',
                icon: Icons.chat_bubble_rounded,
                onPressed: () {
                  final msg = _order.generateWhatsAppMessage();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('WhatsApp payload created for ${widget.artisanName} (${widget.artisanWhatsApp})!'),
                      backgroundColor: EcoColors.forestDeep,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isHighlight = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 13 : 11,
            fontWeight: isTotal || isHighlight ? FontWeight.w800 : FontWeight.normal,
            color: isHighlight ? EcoColors.mintAccent : (isTotal ? Colors.white : EcoColors.textSecondaryLight),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 12,
            fontWeight: FontWeight.w900,
            color: isTotal ? EcoColors.savannaGold : (isHighlight ? EcoColors.mintAccent : Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
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
