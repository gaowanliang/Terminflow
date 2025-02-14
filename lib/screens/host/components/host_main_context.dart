import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:terminflow/core/database/database.dart';
import 'package:terminflow/core/providers/drawer_provider.dart';
import 'package:terminflow/core/providers/ssh_tab_bar_provider.dart';
import 'package:terminflow/data/common/responsive.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';
import 'package:terminflow/core/providers/host_provider.dart';
import 'package:terminflow/screens/new_host/new_host_screen.dart';

import 'top_tools_bar.dart';

class HostMainContent extends ConsumerStatefulWidget {
  const HostMainContent({super.key});

  @override
  ConsumerState<HostMainContent> createState() => _HostMainContentState();
}

class _HostMainContentState extends ConsumerState<HostMainContent> {
  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  // This function will be called when you long press on the blue box or the image
  void _showContextMenu(BuildContext context, HostInfo host) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    final position = RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
            overlay.paintBounds.size.height));
    final value = await _menuContent(position, context);
    if (value != null) {
      _onMenuItemSelected(value, host);
    }
  }

  void _createRightClickMenu(
      BuildContext context, HostInfo host, TapDownDetails? details) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // 计算菜单显示位置
    final RelativeRect position = details != null
        ? RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            details.globalPosition.dx + 1,
            details.globalPosition.dy + 1,
          )
        : RelativeRect.fromRect(
            Rect.fromPoints(
              Offset.zero,
              Offset(
                overlay.size.width,
                overlay.size.height,
              ),
            ),
            Offset.zero & overlay.size,
          );
    final value = await _menuContent(position, context);
    if (value != null) {
      _onMenuItemSelected(value, host);
    }
  }

  _menuContent(RelativeRect position, BuildContext context) async {
    return await showMenu(
      context: context,
      position: position,
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text(AppLocalizations.of(context)?.edit ?? 'Edit'),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text(AppLocalizations.of(context)?.delete ?? 'Delete'),
          ),
        ),
      ],
    );
  }

  void _onMenuItemSelected(String value, HostInfo host) {
    switch (value) {
      case 'edit':
        if (Responsive.isMobile(context)) {
          // 带动画的跳转到NewHost
          // NewHostScreen();
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  NewHostScreen(host),
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
              .setDrawerContent(NewHostScreen(host));
          ref.read(drawerProvider.notifier).closeDrawer();
          ref.read(drawerProvider.notifier).openDrawer();
        }

        break;
      case 'delete':
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete Host'),
              content: Text('Are you sure you want to delete this host?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final database = ref.read(AppDatabase.provider);

                    database.delete(database.hostInfos)
                      ..where((t) => t.id.equals(host.id))
                      ..go();
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)?.delete ?? 'Delete'),
                ),
              ],
            );
          },
        );

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allHosts = ref.watch(hostsStreamProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Responsive.isMobile(context) ? const SizedBox() : TopToolsBar(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                AppLocalizations.of(context)?.hostList ?? 'Host List',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            !Responsive.isMobile(context)
                ? const SizedBox()
                : Expanded(flex: 1, child: HostsGroupDropdownMenu()),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
            child: allHosts.when(
          data: (hosts) => hosts.isEmpty
              ? Center(
                  child: Text(
                    AppLocalizations.of(context)?.noHosts ?? 'No Hosts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              : GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: hosts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isMobile(context) ? 1 : 3,
                    mainAxisExtent: 85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (_, index) {
                    final host = hosts[index];
                    return InkWell(
                        onTap: () {
                          // Navigator.of(context).push(
                          //   PageRouteBuilder(
                          //     pageBuilder:
                          //         (context, animation, secondaryAnimation) =>
                          //             TerminalScreen(connection: host),
                          //     transitionsBuilder: (context, animation,
                          //         secondaryAnimation, child) {
                          //       var begin = Offset(1.0, 0.0);
                          //       var end = Offset.zero;
                          //       var curve = Curves.ease;
                          //       var tween = Tween(begin: begin, end: end)
                          //           .chain(CurveTween(curve: curve));
                          //       var offsetAnimation = animation.drive(tween);
                          //       return SlideTransition(
                          //         position: offsetAnimation,
                          //         child: child,
                          //       );
                          //     },
                          //   ),
                          // );
                          ref.read(sshTabsProvider.notifier).addTab(host);
                        },
                        onTapDown: (details) => _getTapPosition(details),
                        // show the context menu
                        onLongPress: () => _showContextMenu(context, host),
                        onSecondaryTapDown: (details) =>
                            _createRightClickMenu(context, host, details),
                        borderRadius: BorderRadius.circular(10),
                        child: HostItem(host: host, index: index));
                  },
                ),
          error: (e, s) {
            debugPrintStack(label: e.toString(), stackTrace: s);
            return const Text('An error has occured');
          },
          loading: () => const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        ))
      ],
    );
  }
}

class HostItem extends StatelessWidget {
  const HostItem({
    super.key,
    required this.host,
    required this.index,
  });

  final HostInfo host;
  final int index;

  iconByType(int type) {
    switch (type) {
      case 1:
        return FontAwesome.debian_brand;
      case 2:
        return FontAwesome.ubuntu_brand;
      case 3:
        return FontAwesome.centos_brand;
      case 4:
        return FontAwesome.archway_solid;
      default:
        return FontAwesome.server_solid;
    }
  }

  iconColorByType(int type) {
    switch (type) {
      case 1:
        return Color(0xFFA80030);
      case 2:
        return Color(0xFFDD4814);
      case 3:
        return Color(0xFF002C77);
      case 4:
        return Color(0xFF1793D1);
      default:
        return Color(0xFF6ab04c);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            width: 2.5,
            color: Theme.of(context).colorScheme.surfaceContainerHigh),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            iconColorByType(host.type).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        iconByType(host.type),
                        size: 30,
                        color: iconColorByType(host.type),
                      )),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          host.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          host.comment ?? '',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green),
                      color: Colors.green.withValues(alpha: 0.1)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text('Tag $index',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text("256 ms",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
