import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/shell/app_shell_screen.dart';

import 'core/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.instance.initialize();
  runApp(
    const ProviderScope(
      child: WildImpactApp(),
    ),
  );
}

class WildImpactApp extends StatelessWidget {
  const WildImpactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WildImpact - Eco-Impact B2B Tourism Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppShellScreen(),
    );
  }
}
