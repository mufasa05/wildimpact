import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/immersive_background_scaffold.dart';
import '../../../core/widgets/safari_glow_button.dart';
import '../../../domain/models/sme_provider.dart';
import '../../providers/tourism_providers.dart';

class ProviderOnboardingScreen extends ConsumerStatefulWidget {
  const ProviderOnboardingScreen({super.key});

  static const String backgroundUrl =
      'https://images.unsplash.com/photo-1575550959106-5a7defe28b56?auto=format&fit=crop&w=1600&q=80';

  @override
  ConsumerState<ProviderOnboardingScreen> createState() => _ProviderOnboardingScreenState();
}

class _ProviderOnboardingScreenState extends ConsumerState<ProviderOnboardingScreen> {
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  String _selectedCategory = 'Artisan Craft';
  bool _shareAnonymousAggregates = true;
  bool _isEcoCertifiedChecked = true;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _whatsappController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitProviderRegistration() {
    if (_businessNameController.text.isEmpty || _ownerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out your business and owner name'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final newProvider = SmeProvider(
      id: 'sme-${DateTime.now().millisecondsSinceEpoch}',
      businessName: _businessNameController.text.trim(),
      category: _selectedCategory,
      location: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : 'Masvingo / Eastern Highlands',
      ownerName: _ownerNameController.text.trim(),
      whatsappNumber: _whatsappController.text.trim().isNotEmpty ? _whatsappController.text.trim() : '+263770000000',
      startingPriceUsd: double.tryParse(_priceController.text.trim()) ?? 15.0,
      priceUnit: 'per booking / craft item',
      rating: 5.0,
      reviewCount: 1,
      isZtaRegistered: true,
      isEcoCertified: _isEcoCertifiedChecked,
      description: _descController.text.trim().isNotEmpty ? _descController.text.trim() : 'Verified local enterprise partnering with WildImpact Eco-Platform.',
      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=600&q=80',
    );

    ref.read(smeProvidersProvider.notifier).registerSme(newProvider);

    setState(() {
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ImmersiveBackgroundScaffold(
      imageUrl: ProviderOnboardingScreen.backgroundUrl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 20),

            // Provider Resistance Mitigation Guarantees
            _buildAdoptionGuarantees(context),
            const SizedBox(height: 24),

            if (_isSubmitted) ...[
              _buildSuccessCard(context),
            ] else ...[
              // Registration Form
              _buildRegistrationForm(context),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      border: BorderSide(color: EcoColors.savannaGold.withValues(alpha: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: EcoColors.savannaGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.handshake_rounded, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SERVICE PROVIDER & SME ONBOARDING PORTAL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: EcoColors.savannaGold,
                      ),
                    ),
                    Text(
                      'Zero-Commission Direct Tourism Integration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: EcoColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Addressing adoption friction by giving informal businesses and independent lodges 100% data sovereignty, 0% middleman commission, and instant verified ZTA ESG credentials.',
            style: TextStyle(fontSize: 12.5, color: EcoColors.textSecondaryLight, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildAdoptionGuarantees(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildGuaranteeTile('0% Commission', 'Keep 100% of guest revenue via WhatsApp direct inquiries', Icons.percent_rounded, EcoColors.mintAccent),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildGuaranteeTile('Data Sovereignty', 'You control what is shared; no forced financial disclosure', Icons.security_rounded, EcoColors.savannaGold),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildGuaranteeTile('ZTA ESG Badge', 'Automatic verified compliance certificate for annual permits', Icons.verified_user_rounded, EcoColors.mintAccent),
        ),
      ],
    );
  }

  Widget _buildGuaranteeTile(String title, String desc, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      border: BorderSide(color: color.withValues(alpha: 0.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 10.5, color: EcoColors.textSecondaryLight, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'REGISTER YOUR TOURISM ENTERPRISE (3 MINUTES)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: EcoColors.mintAccent),
          ),
          const SizedBox(height: 16),

          // Business Name & Category
          Row(
            children: [
              Expanded(
                child: _buildInput('Business / Enterprise Name', 'e.g. Vumba Mountain Pottery Guild', _businessNameController),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          dropdownColor: const Color(0xFF0E221B),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          isExpanded: true,
                          items: ['Artisan Craft', 'Community Guide', 'Village Homestay', 'Traditional Cuisine', 'Local Transport']
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (val) => setState(() => _selectedCategory = val!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Owner Name & WhatsApp Number
          Row(
            children: [
              Expanded(
                child: _buildInput('Owner / Contact Name', 'e.g. Tariro Mandaza', _ownerNameController),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInput('WhatsApp Number', 'e.g. +263 77 123 4567', _whatsappController),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Location & Starting Price
          Row(
            children: [
              Expanded(
                child: _buildInput('Location / District', 'e.g. Bvumba, Mutare Rural', _locationController),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInput('Starting Price (US\$)', 'e.g. 15', _priceController),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _buildInput('Description of Experiences & Local Crafts', 'Tell visiting tourists what makes your community craft or guided tour special...', _descController, maxLines: 3),
          const SizedBox(height: 16),

          // Data Sovereignty & Eco-Cert Checkboxes
          CheckboxListTile(
            value: _shareAnonymousAggregates,
            activeColor: EcoColors.emeraldPrimary,
            contentPadding: EdgeInsets.zero,
            title: const Text('Share anonymized visitor footfall counts with ZTA National Dashboard', style: TextStyle(fontSize: 12, color: Colors.white)),
            subtitle: const Text('Keeps private pricing confidential; assists national planning', style: TextStyle(fontSize: 10.5, color: Colors.white54)),
            onChanged: (val) => setState(() => _shareAnonymousAggregates = val ?? true),
          ),
          CheckboxListTile(
            value: _isEcoCertifiedChecked,
            activeColor: EcoColors.emeraldPrimary,
            contentPadding: EdgeInsets.zero,
            title: const Text('Request Free Verified Community Eco-Badge & Certificate', style: TextStyle(fontSize: 12, color: Colors.white)),
            subtitle: const Text('Guarantees 0% middleman fees on all tourist inquiries', style: TextStyle(fontSize: 10.5, color: EcoColors.mintAccent)),
            onChanged: (val) => setState(() => _isEcoCertifiedChecked = val ?? true),
          ),
          const SizedBox(height: 18),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: SafariGlowButton(
              text: 'Complete Free Onboarding & Activate Listing',
              icon: Icons.check_circle_outline_rounded,
              onPressed: _submitProviderRegistration,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      border: const BorderSide(color: EcoColors.mintAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(color: EcoColors.forestDeep, shape: BoxShape.circle),
            child: const Icon(Icons.verified_rounded, color: EcoColors.mintAccent, size: 36),
          ),
          const SizedBox(height: 14),
          const Text(
            'Enterprise Successfully Verified & Activated!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your business is now discoverable across the Universal Accessibility & Community Discovery Layer with direct WhatsApp inquiries.',
            style: TextStyle(fontSize: 12, color: EcoColors.textSecondaryLight),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SafariGlowButton(
            text: 'Download Official ZTA Eco-Compliance Badge (PDF)',
            icon: Icons.download_rounded,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ZTA Compliance Certificate downloaded'), backgroundColor: EcoColors.forestDeep),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
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
