import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/eco_colors.dart';
import '../../../domain/models/user_auth_profile.dart';
import '../../providers/tourism_providers.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isSignUp = false;
  UserPersona _selectedPersona = UserPersona.tourist;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController.text = 'mufasa@wildimpact.org';
    _passwordController.text = 'WildImpact2026!';
    _fullNameController.text = 'Mufasa';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _onPersonaChanged(UserPersona persona) {
    setState(() {
      _selectedPersona = persona;
      switch (persona) {
        case UserPersona.tourist:
          _emailController.text = 'mufasa@wildimpact.org';
          _fullNameController.text = 'Mufasa';
          break;
        case UserPersona.operator:
          _emailController.text = 'tendai.c@hwangewild.org';
          _fullNameController.text = 'Tendai Chikwanda (GM)';
          break;
        case UserPersona.ranger:
          _emailController.text = 'dube.ranger@zimparks.org';
          _fullNameController.text = 'Ranger Chief Dube';
          break;
        case UserPersona.ztaAuditor:
          _emailController.text = 'chipo.m@tourismzimbabwe.gov.zw';
          _fullNameController.text = 'Dr. Chipo Marufu (Auditor General)';
          break;
        case UserPersona.smeProvider:
          _emailController.text = 'farai.crafts@masvingosme.org';
          _fullNameController.text = 'Farai Ndlovu (Artisan Guild)';
          break;
        case UserPersona.elderCustodian:
          _emailController.text = 'elder.munyaradzi@heritagezim.org';
          _fullNameController.text = 'Sekuru Munyaradzi Mutapa';
          break;
      }
    });
  }

  Future<void> _handleAuth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _fullNameController.text.trim();

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
              fullName: fullName.isNotEmpty ? fullName : null,
              persona: _selectedPersona,
            );
      } else {
        await ref.read(currentUserProfileProvider.notifier).signInWithSupabase(
              email: email,
              password: password,
              persona: _selectedPersona,
            );
      }
    } catch (e) {
      // Fallback direct login for seamless demo experience
      ref.read(currentUserProfileProvider.notifier).signInAsRole(
            _selectedPersona,
            fullName: fullName.isNotEmpty ? fullName : null,
            email: email,
          );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _quickOneClickLogin(UserPersona persona) {
    ref.read(currentUserProfileProvider.notifier).signInAsRole(persona);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 1000;

    return Scaffold(
      backgroundColor: isDark ? EcoColors.obsidianBg : EcoColors.lightBg,
      body: Stack(
        children: [
          // Background ambient gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF04140D),
                          const Color(0xFF0A2218),
                          EcoColors.obsidianBg,
                        ]
                      : [
                          const Color(0xFFE8F5E9),
                          const Color(0xFFF1F8E9),
                          EcoColors.lightBg,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Main Layout
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWide ? 1120 : 640),
                  child: isWide ? _buildWideLayout(isDark) : _buildNarrowLayout(isDark),
                ),
              ),
            ),
          ),

          // Top Header Bar with Theme Toggle
          Positioned(
            top: 12,
            right: 16,
            child: SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? EcoColors.darkCardBg : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                      icon: Icon(
                        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: EcoColors.savannaGold,
                        size: 20,
                      ),
                      onPressed: () {
                        final currentMode = ref.read(themeModeProvider);
                        ref.read(themeModeProvider.notifier).state =
                            currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Branding & Value Proposition Hero Panel
        Expanded(
          flex: 5,
          child: _buildHeroPanel(isDark),
        ),
        const SizedBox(width: 40),

        // Right Interactive Auth Box
        Expanded(
          flex: 6,
          child: _buildAuthCard(isDark),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(bool isDark) {
    return Column(
      children: [
        _buildBrandHeader(isDark),
        const SizedBox(height: 24),
        _buildAuthCard(isDark),
      ],
    );
  }

  Widget _buildBrandHeader(bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: EcoColors.emeraldGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: EcoColors.emeraldPrimary.withValues(alpha: 0.35),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/wildimpact_logo.jpg',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => const Icon(Icons.park_rounded, color: Colors.white, size: 36),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'WILDIMPACT',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Universal Eco-Impact Tourism & Safari Conservation OS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? EcoColors.mintAccent : EcoColors.emeraldDark,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroPanel(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrandHeader(isDark),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? EcoColors.darkCardBg.withValues(alpha: 0.7) : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: EcoColors.savannaGold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: EcoColors.savannaGold),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded, color: EcoColors.savannaGold, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'ZIMBABWE CONSERVATION GRAPH',
                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: EcoColors.savannaGold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Experience Zimbabwe with Verified Conservation Impact.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                  color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'WildImpact connects eco-travelers directly to national safari wonders, anti-poaching telemetry, 0% fee artisan commissions, and transparent CAMPFIRE community funds.',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 24),

              // Key Impact Metrics Grid
              Row(
                children: [
                  _buildMetricStat('100%', 'Verified Offsets', Icons.eco_rounded, EcoColors.mintAccent, isDark),
                  const SizedBox(width: 12),
                  _buildMetricStat('0%', 'Artisan Fees', Icons.handshake_rounded, EcoColors.savannaGold, isDark),
                  const SizedBox(width: 12),
                  _buildMetricStat('180k+ ha', 'Protected Corridors', Icons.shield_rounded, EcoColors.emeraldPrimary, isDark),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricStat(String value, String label, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? EcoColors.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? EcoColors.cardBorder : EcoColors.lightCardBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sign In / Sign Up Toggle Tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withValues(alpha: 0.5) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isSignUp = false),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !_isSignUp ? EcoColors.emeraldPrimary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: !_isSignUp ? Colors.black : (isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isSignUp = true),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _isSignUp ? EcoColors.emeraldPrimary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _isSignUp ? Colors.black : (isDark ? EcoColors.textSecondaryLight : EcoColors.textSecondaryDark),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Role Selector Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SELECT YOUR ACCESS ROLE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.9,
                  color: isDark ? EcoColors.savannaGold : EcoColors.terracotta,
                ),
              ),
              Text(
                'Dedicated role view',
                style: TextStyle(
                  fontSize: 10.5,
                  color: isDark ? EcoColors.textMuted : EcoColors.textMutedDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Role Selection Cards Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.3,
            children: UserPersona.values.map((persona) {
              final isSelected = _selectedPersona == persona;
              return InkWell(
                onTap: () => _onPersonaChanged(persona),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? EcoColors.emeraldPrimary.withValues(alpha: isDark ? 0.2 : 0.12)
                        : (isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? EcoColors.emeraldPrimary
                          : (isDark ? Colors.white12 : EcoColors.lightCardBorder),
                      width: isSelected ? 1.8 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(persona.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              persona.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected
                                    ? (isDark ? EcoColors.mintAccent : EcoColors.emeraldDark)
                                    : (isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark),
                              ),
                            ),
                            Text(
                              persona.description.split(',').first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9.5,
                                color: isDark ? EcoColors.textMuted : EcoColors.textMutedDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded, color: EcoColors.emeraldPrimary, size: 16),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Credentials Form
          if (_isSignUp) ...[
            TextField(
              controller: _fullNameController,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 13.5,
              ),
              decoration: _buildInputDeco('Full Name', Icons.person_outline, isDark),
            ),
            const SizedBox(height: 12),
          ],

          TextField(
            controller: _emailController,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 13.5,
            ),
            decoration: _buildInputDeco('Email Address', Icons.email_outlined, isDark),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 13.5,
            ),
            decoration: _buildInputDeco(
              'Password',
              Icons.lock_outline,
              isDark,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: isDark ? Colors.white54 : Colors.black54,
                  size: 18,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: EcoColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EcoColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: EcoColors.error, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_errorMessage!, style: const TextStyle(fontSize: 12, color: EcoColors.error)),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Primary Sign In / Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleAuth,
              style: ElevatedButton.styleFrom(
                backgroundColor: EcoColors.emeraldPrimary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isSignUp ? 'Create ${_selectedPersona.title} Account' : 'Sign In as ${_selectedPersona.title.split(' ').first}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: Divider(color: isDark ? Colors.white12 : EcoColors.lightCardBorder)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR 1-CLICK INSTANT DEMO LOGIN',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: isDark ? Colors.white54 : EcoColors.textMutedDark,
                  ),
                ),
              ),
              Expanded(child: Divider(color: isDark ? Colors.white12 : EcoColors.lightCardBorder)),
            ],
          ),
          const SizedBox(height: 14),

          // Instant 1-Click Access Buttons for each Role
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: UserPersona.values.map((p) {
              return ActionChip(
                backgroundColor: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9),
                side: BorderSide(
                  color: isDark ? Colors.white12 : EcoColors.lightCardBorder,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                avatar: Text(p.emoji, style: const TextStyle(fontSize: 13)),
                label: Text(
                  p == UserPersona.tourist ? 'Tourist (Mufasa)' : p.title.split(' ')[0],
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? EcoColors.textPrimaryLight : EcoColors.textPrimaryDark,
                  ),
                ),
                onPressed: () => _quickOneClickLogin(p),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDeco(String label, IconData icon, bool isDark, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? Colors.white60 : EcoColors.textSecondaryDark,
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: isDark ? EcoColors.mintAccent : EcoColors.emeraldDark,
        size: 18,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark ? Colors.black.withValues(alpha: 0.3) : const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? Colors.white12 : EcoColors.lightCardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? Colors.white12 : EcoColors.lightCardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: EcoColors.emeraldPrimary, width: 1.8),
      ),
    );
  }
}
