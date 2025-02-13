import 'package:flutter/material.dart';
import 'package:terminflow/data/common/constant.dart';
import 'package:terminflow/screens/host/host_screen.dart';
import 'package:terminflow/screens/setting/setting_dart.dart';
import 'package:terminflow/screens/sftp/sftp_screen.dart';
import 'package:terminflow/screens/snippets/snippets_screen.dart';

import 'components/navigation_bar.dart';
import 'components/navigation_transition.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _HomeState();
}

class _HomeState extends State<MainScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  bool controllerInitialized = false;
  bool showMediumSizeLayout = false;
  bool showLargeSizeLayout = false;

  int screenIndex = ScreenSelected.host.value;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: transitionLength.toInt() * 2),
      value: 0,
      vsync: this,
    );
    railAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = controller.status;
    if (width > mediumWidthBreakpoint) {
      if (width > largeWidthBreakpoint) {
        showMediumSizeLayout = false;
        showLargeSizeLayout = true;
      } else {
        showMediumSizeLayout = true;
        showLargeSizeLayout = false;
      }
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        controller.forward();
      }
    } else {
      showMediumSizeLayout = false;
      showLargeSizeLayout = false;
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      controller.value = width > mediumWidthBreakpoint ? 1 : 0;
    }
  }

  void handleScreenChanged(int screenSelected) {
    setState(() {
      screenIndex = screenSelected;
    });
  }

  //
  Widget createScreenFor(
      ScreenSelected screenSelected, bool showNavBarExample) {
    switch (screenSelected) {
      case ScreenSelected.host:
        return const HostScreen();
      case ScreenSelected.sftp:
        return const SftpScreen();
      case ScreenSelected.snippets:
        return const SnippetsScreen();
      case ScreenSelected.setting:
        return const SettingScreen();
    }
  }

  Widget _expandedTrailingActions() => Container(
        constraints: const BoxConstraints.tightFor(width: 100),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(),
          ],
        ),
      );

  Widget _trailingActions() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [],
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return NavigationTransition(
          scaffoldKey: scaffoldKey,
          animationController: controller,
          railAnimation: railAnimation,
          // appBar: createAppBar(),
          body: createScreenFor(
              ScreenSelected.values[screenIndex], controller.value == 1),
          navigationRail: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 6),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: NavigationRail(
                    // extended: showLargeSizeLayout,
                    destinations: getNavRailDestinations(context),
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                    labelType: NavigationRailLabelType.all,
                    selectedIndex: screenIndex,
                    onDestinationSelected: (index) {
                      setState(() {
                        screenIndex = index;
                        handleScreenChanged(screenIndex);
                      });
                    },
                    leading: Padding(padding: EdgeInsets.only(top: 20)),
                    trailing: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: showLargeSizeLayout
                            ? _expandedTrailingActions()
                            : _trailingActions(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          navigationBar: NavigationBars(
            onSelectItem: (index) {
              setState(() {
                screenIndex = index;
                handleScreenChanged(screenIndex);
              });
            },
            selectedIndex: screenIndex,
          ),
        );
      },
    );
  }
}

List<NavigationRailDestination> getNavRailDestinations(BuildContext context) {
  final List<NavigationDestination> appBarDestinations =
      getAppBarDestinations(context);
  return appBarDestinations
      .map(
        (destination) => NavigationRailDestination(
          icon: Tooltip(
            message: destination.label,
            child: destination.icon,
          ),
          selectedIcon: Tooltip(
            message: destination.label,
            child: destination.selectedIcon,
          ),
          label: Text(destination.label),
        ),
      )
      .toList();
}
