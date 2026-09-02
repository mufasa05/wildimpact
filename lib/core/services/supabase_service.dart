import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService instance = SupabaseService._internal();
  SupabaseService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Supabase Credentials (configurable via --dart-define or defaults)
  static const String defaultUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://demo-wildimpact.supabase.co',
  );

  static const String defaultAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'demo-anon-key-wildimpact-safari',
  );

  SupabaseClient? get client {
    if (!_isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  Future<void> initialize({String? url, String? anonKey}) async {
    final finalUrl = url ?? defaultUrl;
    final finalKey = anonKey ?? defaultAnonKey;

    try {
      await Supabase.initialize(
        url: finalUrl,
        publishableKey: finalKey,
      );
      _isInitialized = true;
      debugPrint('Supabase initialized successfully with $finalUrl');
    } catch (e) {
      debugPrint('Supabase initialization note: Running in resilient/offline mode ($e)');
      _isInitialized = false;
    }
  }

  // Authentication Helpers
  User? get currentUser => client?.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    if (client == null) return null;
    return await client!.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse?> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    if (client == null) return null;
    return await client!.auth.signUp(
      email: email,
      password: password,
      data: fullName != null ? {'full_name': fullName} : null,
    );
  }

  Future<void> signOut() async {
    if (client == null) return;
    await client!.auth.signOut();
  }
}
