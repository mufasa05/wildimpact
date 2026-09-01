import 'package:flutter/material.dart';
import '../theme/eco_colors.dart';
import 'safari_glow_button.dart';

class ElderPayoutModal extends StatefulWidget {
  final double currentBalanceUsd;
  final String elderName;
  final Function(double amountDisbursed) onPayoutSuccess;

  const ElderPayoutModal({
    super.key,
    required this.currentBalanceUsd,
    required this.elderName,
    required this.onPayoutSuccess,
  });

  static void show(
    BuildContext context, {
    required double balance,
    required String elderName,
    required Function(double) onPayoutSuccess,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (c) => ElderPayoutModal(
        currentBalanceUsd: balance,
        elderName: elderName,
        onPayoutSuccess: onPayoutSuccess,
      ),
    );
  }

  @override
  State<ElderPayoutModal> createState() => _ElderPayoutModalState();
}

class _ElderPayoutModalState extends State<ElderPayoutModal> {
  String _selectedProvider = 'EcoCash Zimbabwe (USD/ZiG)';
  final _mobileNumberController = TextEditingController(text: '+263 77 412 8904');
  late final TextEditingController _amountController;
  bool _isProcessing = false;
  bool _isComplete = false;
  String? _transactionRef;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.currentBalanceUsd.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _disbursePayout() async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0 || amount > widget.currentBalanceUsd) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid payout amount'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1400));

    setState(() {
      _isProcessing = false;
      _isComplete = true;
      _transactionRef = 'MM-ZW-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
    });

    widget.onPayoutSuccess(amount);
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
        border: Border(top: BorderSide(color: EcoColors.savannaGold, width: 2)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),

            if (_isComplete) ...[
              _buildSuccessView(context),
            ] else ...[
              _buildFormView(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFormView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: EcoColors.forestDeep, shape: BoxShape.circle),
              child: const Icon(Icons.account_balance_wallet_rounded, color: EcoColors.savannaGold, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ELDER ORAL ROYALTY PAYOUT',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: EcoColors.savannaGold, letterSpacing: 1.0),
                  ),
                  Text(
                    'Direct Mobile Money Disbursement for ${widget.elderName}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Available Balance Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: EcoColors.cardBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Accrued Royalty Balance', style: TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight)),
                  SizedBox(height: 2),
                  Text('Verified Pay-Per-Listen Oral Plays', style: TextStyle(fontSize: 10, color: EcoColors.textMuted)),
                ],
              ),
              Text(
                'US\$${widget.currentBalanceUsd.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: EcoColors.savannaGold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Mobile Money Provider Selector
        const Text('SELECT DIRECT MOBILE WALLET:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white70)),
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
              value: _selectedProvider,
              dropdownColor: const Color(0xFF0C1B15),
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
              isExpanded: true,
              items: [
                'EcoCash Zimbabwe (USD/ZiG)',
                'Mukuru Direct Cash / Orange Money',
                'InnBucks Micro-Wallet',
                'OMARI (Old Mutual Money)'
              ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (val) => setState(() => _selectedProvider = val!),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Mobile Number & Amount
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _buildTextField('Recipient Mobile Number', _mobileNumberController),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildTextField('Disburse Amount (US\$)', _amountController),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Disburse Button
        SizedBox(
          width: double.infinity,
          child: SafariGlowButton(
            text: _isProcessing ? 'Connecting to Mobile Switch...' : 'Authorize Instant Mobile Payout',
            icon: Icons.send_to_mobile_rounded,
            isLoading: _isProcessing,
            onPressed: _disbursePayout,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.check_circle_rounded, color: EcoColors.mintAccent, size: 54),
        const SizedBox(height: 12),
        const Text(
          'Royalty Successfully Disbursed!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          'US\$${_amountController.text} sent via $_selectedProvider to ${_mobileNumberController.text}',
          style: const TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: EcoColors.mintAccent.withValues(alpha: 0.3)),
          ),
          child: Text(
            'Ref: $_transactionRef • 0% Transaction Leakage',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: EcoColors.mintAccent),
          ),
        ),
        const SizedBox(height: 20),
        SafariGlowButton(
          text: 'Done & Return',
          icon: Icons.close_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
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
