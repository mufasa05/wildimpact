import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../../domain/models/carbon_offset_project.dart';
import '../../../domain/models/offset_purchase.dart';
import '../../providers/tourism_providers.dart';

class OffsetCheckoutDialog extends ConsumerStatefulWidget {
  final double defaultTonnes;
  final CarbonOffsetProject? preselectedProject;
  final Function(OffsetPurchase)? onPurchaseSuccess;

  const OffsetCheckoutDialog({
    super.key,
    this.defaultTonnes = 2.4,
    this.preselectedProject,
    this.onPurchaseSuccess,
  });

  @override
  ConsumerState<OffsetCheckoutDialog> createState() => _OffsetCheckoutDialogState();
}

class _OffsetCheckoutDialogState extends ConsumerState<OffsetCheckoutDialog> {
  final _nameController = TextEditingController(text: 'Elena Rostova');
  final _emailController = TextEditingController(text: 'elena.rostova@safari-world.com');
  late double _tonnes;
  late String _selectedProjectId;
  String _paymentMethod = 'STRIPE'; // 'STRIPE' or 'PAYNOW_ECOCASH'
  final _ecocashPhoneController = TextEditingController(text: '+263 77 123 4567');
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _tonnes = widget.defaultTonnes;
    final projects = ref.read(carbonOffsetProjectsProvider);
    _selectedProjectId = widget.preselectedProject?.id ?? (projects.isNotEmpty ? projects.first.id : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ecocashPhoneController.dispose();
    super.dispose();
  }

  void _handlePay() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        final paymentLabel = _paymentMethod == 'STRIPE'
            ? 'Stripe (Visa •••• 4242)'
            : 'PayNow (EcoCash ${_ecocashPhoneController.text})';

        final purchase = ref.read(purchasesProvider.notifier).purchaseOffset(
          offsetProjectId: _selectedProjectId,
          touristName: _nameController.text,
          touristEmail: _emailController.text,
          tonnes: _tonnes,
          paymentMethod: paymentLabel,
        );

        ref.read(latestCertificateProvider.notifier).state = purchase;

        setState(() => _isProcessing = false);
        Navigator.pop(context);
        widget.onPurchaseSuccess?.call(purchase);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(carbonOffsetProjectsProvider);
    final selectedProj = projects.firstWhere(
      (p) => p.id == _selectedProjectId,
      orElse: () => projects.first,
    );

    final totalAmount = _tonnes * selectedProj.pricePerTonne;
    final campfireShare = totalAmount * (selectedProj.zimbabweCampfirePct / 100);
    final directProjectShare = totalAmount * 0.65;
    final rangerSupportShare = totalAmount * 0.15;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: GlassCard(
          backgroundColor: EcoColors.darkCardBg,
          padding: const EdgeInsets.all(28),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: EcoColors.emeraldGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.eco_rounded, color: Colors.black, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hyper-Local Carbon Offset',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: EcoColors.textPrimaryLight),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Direct funding for Zimbabwean wildlife & community projects',
                            style: TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: EcoColors.textSecondaryLight, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tonnes adjustment
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: EcoColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Offset Quantity', style: TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight)),
                          const SizedBox(height: 2),
                          Text(
                            '${_tonnes.toStringAsFixed(1)} Tonnes CO₂',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: EcoColors.mintAccent),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _tonnes > 0.5 ? () => setState(() => _tonnes = (_tonnes - 0.5).clamp(0.5, 50.0)) : null,
                            icon: const Icon(Icons.remove_circle_outline, color: EcoColors.textSecondaryLight),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _tonnes = (_tonnes + 0.5).clamp(0.5, 50.0)),
                            icon: const Icon(Icons.add_circle_outline, color: EcoColors.mintAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Project Selector
                const Text('Select Local Conservation Project', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EcoColors.textSecondaryLight)),
                const SizedBox(height: 8),
                Column(
                  children: projects.map((p) {
                    final isSelected = p.id == _selectedProjectId;
                    return InkWell(
                      onTap: () => setState(() => _selectedProjectId = p.id),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? EcoColors.emeraldPrimary.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? EcoColors.emeraldPrimary : EcoColors.cardBorder,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected ? EcoColors.mintAccent : EcoColors.textSecondaryLight,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight)),
                                  Text(p.impactNarrative, style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight), maxLines: 1),
                                ],
                              ),
                            ),
                            Text('\$${p.pricePerTonne.toStringAsFixed(2)}/t', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: EcoColors.savannaGold)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Transparent $ Breakdown
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: EcoColors.emeraldPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: EcoColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('100% Transparent Financial Breakdown', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: EcoColors.mintAccent)),
                          Text('Total: \$${totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: EcoColors.textPrimaryLight)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildBreakdownItem('☀️ Direct Village Project Deployment', '\$${directProjectShare.toStringAsFixed(2)} (65%)'),
                      _buildBreakdownItem('🤝 CAMPFIRE Rural Council Community Share', '\$${campfireShare.toStringAsFixed(2)} (${selectedProj.zimbabweCampfirePct.toInt()}%)'),
                      _buildBreakdownItem('🛡️ Ranger Anti-Poaching Patrol & Fuel Stipend', '\$${rangerSupportShare.toStringAsFixed(2)} (15%)'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Method Selector
                const Text('Choose Payment Gateway', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: EcoColors.textSecondaryLight)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildPaymentTab(
                        'Stripe (International)',
                        Icons.credit_card_rounded,
                        _paymentMethod == 'STRIPE',
                        () => setState(() => _paymentMethod = 'STRIPE'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildPaymentTab(
                        'PayNow (EcoCash / Zim)',
                        Icons.phone_android_rounded,
                        _paymentMethod == 'PAYNOW_ECOCASH',
                        () => setState(() => _paymentMethod = 'PAYNOW_ECOCASH'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (_paymentMethod == 'PAYNOW_ECOCASH') ...[
                  TextFormField(
                    controller: _ecocashPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'EcoCash Mobile Number',
                      prefixIcon: Icon(Icons.phone, size: 18, color: EcoColors.savannaGold),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Action Button
                SafariGlowButton(
                  text: 'Complete Offset & Generate Certificate (\$${totalAmount.toStringAsFixed(2)})',
                  icon: Icons.lock_rounded,
                  isLoading: _isProcessing,
                  width: double.infinity,
                  onPressed: _handlePay,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: EcoColors.textPrimaryLight)),
        ],
      ),
    );
  }

  Widget _buildPaymentTab(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? EcoColors.emeraldPrimary.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? EcoColors.emeraldPrimary : EcoColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? EcoColors.mintAccent : EcoColors.textSecondaryLight),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? EcoColors.textPrimaryLight : EcoColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
