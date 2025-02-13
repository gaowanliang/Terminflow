import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:terminflow/core/providers/drawer_provider.dart';

class EndDrawerSection extends ConsumerWidget {
  const EndDrawerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawerContent = ref.watch(drawerContentProvider);
    return Drawer(
      child: drawerContent,
    );
  }
}
