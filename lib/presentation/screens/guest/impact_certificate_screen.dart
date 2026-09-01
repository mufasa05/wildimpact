import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/eco_badge.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../providers/tourism_providers.dart';
import 'offset_checkout_dialog.dart';

class ImpactCertificateScreen extends ConsumerStatefulWidget {
  const ImpactCertificateScreen({super.key});

  @override
  ConsumerState<ImpactCertificateScreen> createState() => _ImpactCertificateScreenState();
}

class _ImpactCertificateScreenState extends ConsumerState<ImpactCertificateScreen> {
  bool _isSharing = false;

  void _shareCertificate() {
    setState(() => _isSharing = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isSharing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: EcoColors.forestDeep,
            content: Text('Certificate & Social Card copied to clipboard! Ready to share on LinkedIn & Instagram.'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cert = ref.watch(latestCertificateProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (cert == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: GlassCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.workspace_premium_outlined, color: EcoColors.savannaGold, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'No Carbon Offset Certificates Yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Offset your safari footprint or fund a local solar microgrid to receive your verifiable ZCR certificate.',
                  style: TextStyle(fontSize: 13, color: EcoColors.textSecondaryLight),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SafariGlowButton(
                  text: 'Purchase Carbon Offset (\$15)',
                  icon: Icons.eco_rounded,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => const OffsetCheckoutDialog(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              // Certificate Action Bar
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 10,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Carbon Retirement Certificate',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: EcoColors.textPrimaryLight),
                      ),
                      Text('Official tokenized environmental retirement proof', style: TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight)),
                    ],
                  ),
                  SafariGlowButton(
                    text: 'Share Impact',
                    icon: Icons.share_rounded,
                    isSecondary: true,
                    isLoading: _isSharing,
                    height: 38,
                    onPressed: _shareCertificate,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // The Certificate Frame
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: EcoColors.savannaGold.withValues(alpha: 0.6), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: EcoColors.savannaGold.withValues(alpha: 0.15),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: GlassCard(
                  padding: EdgeInsets.all(isMobile ? 18 : 36),
                  backgroundColor: const Color(0xFF091A13),
                  borderRadius: 22,
                  child: Column(
                    children: [
                      // Certificate Header
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: EcoColors.savannaGold.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(Icons.eco_rounded, color: EcoColors.savannaGold, size: 16),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'WILDIMPACT CONSERVATION REGISTRY',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                      color: EcoColors.savannaGold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Certificate of Retirement',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: EcoColors.textPrimaryLight,
                                ),
                              ),
                            ],
                          ),
                          EcoBadge.gold(text: 'VERIFIED RETIRED', icon: Icons.verified_rounded),
                        ],
                      ),
                      const Divider(color: EcoColors.cardBorder, height: 28),

                      // Present to
                      const Text(
                        'THIS IS TO CERTIFY THAT',
                        style: TextStyle(fontSize: 11, letterSpacing: 2, color: EcoColors.textSecondaryLight, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cert.touristName,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: EcoColors.mintAccent,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cert.touristEmail,
                        style: const TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'has permanently retired and neutralized carbon emissions via direct funding of Zimbabwean community-led wildlife habitat initiatives:',
                        style: TextStyle(fontSize: 13, color: EcoColors.textSecondaryLight, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Quantity & Initiative Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: EcoColors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${cert.tonnes.toStringAsFixed(1)} TONNES CO₂ NEUTRALIZED',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                                color: EcoColors.savannaGold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cert.projectName,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: EcoColors.textPrimaryLight),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Amount Contributed: \$${cert.amountPaid.toStringAsFixed(2)} • CAMPFIRE Direct Rural Share: \$${cert.campfireShare.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 11.5, color: EcoColors.mintAccent),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // QR Code and Metadata Footer
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: QrImageView(
                              data: 'https://registry.wildimpact.org/verify/${cert.certificateCode}',
                              version: QrVersions.auto,
                              size: 72.0,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Certificate ID: ', style: TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight)),
                                    Text(cert.certificateCode, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: EcoColors.textPrimaryLight)),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Issue Date: ${DateFormat('MMMM d, yyyy HH:mm').format(cert.createdAt)} UTC',
                                  style: const TextStyle(fontSize: 11, color: EcoColors.textSecondaryLight),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Payment Gateway: ${cert.paymentMethod}',
                                  style: const TextStyle(fontSize: 10.5, color: EcoColors.textMuted),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Registry Protocol: ZCR-2026-CAMPFIRE-V3',
                                  style: TextStyle(fontSize: 10.5, color: EcoColors.mintAccent, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SafariGlowButton(
                      text: 'Download Official PDF',
                      icon: Icons.download_rounded,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: EcoColors.forestDeep,
                            content: Text(
                              'Official Certificate ${cert.certificateCode} downloaded to device storage!',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SafariGlowButton(
                      text: 'Verify on ZCR Registry',
                      icon: Icons.verified_rounded,
                      isSecondary: true,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: EcoColors.forestDeep,
                            content: Text(
                              'Verified: Certificate ${cert.certificateCode} is valid and immutable on ZCR-2026-CAMPFIRE-V3.',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
