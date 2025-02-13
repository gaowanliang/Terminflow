import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:terminflow/core/providers/drawer_provider.dart';
import 'package:terminflow/core/providers/ssh_tab_bar_provider.dart';
import 'package:terminflow/data/common/responsive.dart';
import 'package:terminflow/screens/new_host/new_host_screen.dart';

import 'components/host_main_context.dart';
import 'components/ssh_tab_bar.dart';

class HostScreen extends ConsumerWidget {
  const HostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        child: Scaffold(
      body: Padding(
        padding: Responsive.isMobile(context)
            ? const EdgeInsets.symmetric(horizontal: 16)
            : const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: HostFrame(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (Responsive.isMobile(context)) {
            // 带动画的跳转到NewHost
            // NewHostScreen();
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    NewHostScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          } else {
            ref
                .read(drawerContentProvider.notifier)
                .setDrawerContent(const NewHostScreen());
            ref.read(drawerProvider.notifier).closeDrawer();
            ref.read(drawerProvider.notifier).openDrawer();
          }
        },
        child: const Icon(Icons.add),
      ),
    ));
  }
}

class MainHostListWrapper extends StatelessWidget {
  const MainHostListWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.surfaceContainerHighest),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: HostMainContent(),
      ),
    );
  }
}

class HostFrame extends ConsumerWidget {
  const HostFrame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = ref.watch(sshTabsProvider);

    return Column(
      children: [
        Expanded(
          child: SSHTabBar(
            tabs: tabs,
          ),
        ),
      ],
    );
  }
}
