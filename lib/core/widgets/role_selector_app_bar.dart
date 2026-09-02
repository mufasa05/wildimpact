import 'package:flutter/material.dart';
import 'app_shell_header.dart';

/// Backward-compatible alias directing to the clean [AppShellHeader]
class RoleSelectorAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RoleSelectorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    return const AppShellHeader();
  }
}
