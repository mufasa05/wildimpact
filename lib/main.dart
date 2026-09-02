import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'presentation/providers/tourism_providers.dart';
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/shell/app_shell_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.instance.initialize();
  runApp(
    const ProviderScope(
      child: WildImpactApp(),
    ),
  );
}

class WildImpactApp extends ConsumerWidget {
  const WildImpactApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return MaterialApp(
      title: 'WildImpact - Zimbabwe Eco-Tourism & Conservation OS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: isAuthenticated ? const AppShellScreen() : const AuthScreen(),
    );
  }
}
