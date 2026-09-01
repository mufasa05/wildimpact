import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../domain/models/user_auth_profile.dart';
import '../../providers/tourism_providers.dart';

class AuthModalSheet extends ConsumerStatefulWidget {
  const AuthModalSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AuthModalSheet(),
    );
  }

  @override
  ConsumerState<AuthModalSheet> createState() => _AuthModalSheetState();
}

class _AuthModalSheetState extends ConsumerState<AuthModalSheet> {
  bool _isSignUp = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSupabaseAuth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please provide both email and password';
      });
      return;
    }

    try {
      if (_isSignUp) {
        await ref.read(currentUserProfileProvider.notifier).signUpWithSupabase(
              email: email,
              password: password,
              fullName: _nameController.text.trim(),
            );
      } else {
        await ref.read(currentUserProfileProvider.notifier).signInWithSupabase(
              email: email,
              password: password,
            );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Authentication notice: $e';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentProfile = ref.watch(currentUserProfileProvider);

    return Container(
      decoration: BoxDecoration(
        color: EcoColors.darkCardBg.withValues(alpha: 0.96),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: EcoColors.cardBorder.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header with Active User Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isSignUp ? 'Create WildImpact Account' : 'Platform Identity Portal',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: EcoColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Multi-Persona Access for Tourists, Hosts & ZTA',
                      style: TextStyle(fontSize: 12, color: EcoColors.mintAccent.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: EcoColors.forestDeep.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: EcoColors.cardBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(currentProfile.persona.emoji, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        currentProfile.persona.title.split(' ')[0],
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: EcoColors.mintAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick 1-Click Persona Switcher for Instant Demos & Testing
            const Text(
              '⚡ FAST 1-CLICK PERSONA SWITCHER (FOR DEMOS)',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: EcoColors.savannaGold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: UserPersona.values.map((persona) {
                final isSelected = currentProfile.persona == persona;
                return InkWell(
                  onTap: () {
                    ref.read(currentUserProfileProvider.notifier).switchPersona(persona);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? EcoColors.emeraldPrimary.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? EcoColors.emeraldPrimary : Colors.white12,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(persona.emoji, style: const TextStyle(fontSize: 15)),
                        const SizedBox(width: 6),
                        Text(
                          persona.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? EcoColors.textPrimaryLight : EcoColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 22),
            const Divider(color: Colors.white12),
            const SizedBox(height: 14),

            // Supabase Email / Password Form
            Text(
              _isSignUp ? 'OR REGISTER WITH SUPABASE CLOUD' : 'OR SIGN IN WITH SUPABASE ACCOUNT',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8, color: Colors.white54),
            ),
            const SizedBox(height: 12),

            if (_isSignUp) ...[
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white, fontSize: 13.5),
                decoration: _buildInputDecoration('Full Name', Icons.person_outline),
              ),
              const SizedBox(height: 10),
            ],

            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white, fontSize: 13.5),
              decoration: _buildInputDecoration('Email Address', Icons.email_outlined),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white, fontSize: 13.5),
              decoration: _buildInputDecoration('Password', Icons.lock_outline),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(_errorMessage!, style: const TextStyle(fontSize: 12, color: EcoColors.amberWarm)),
            ],

            const SizedBox(height: 18),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSupabaseAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EcoColors.emeraldPrimary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                        : Text(
                            _isSignUp ? 'Create Supabase Account' : 'Sign In with Supabase',
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = !_isSignUp;
                      _errorMessage = null;
                    });
                  },
                  child: Text(
                    _isSignUp ? 'Have account? Sign In' : 'Need account? Sign Up',
                    style: const TextStyle(fontSize: 12, color: EcoColors.mintAccent, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54, fontSize: 12.5),
      prefixIcon: Icon(icon, color: EcoColors.mintAccent, size: 18),
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: EcoColors.emeraldPrimary, width: 1.5),
      ),
    );
  }
}
