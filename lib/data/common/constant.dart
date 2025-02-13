import 'package:flutter/material.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';

enum ScreenSelected {
  host(0),
  sftp(1),
  snippets(2),
  setting(3);

  const ScreenSelected(this.value);
  final int value;
}

// NavigationRail shows if the screen width is greater or equal to
// narrowScreenWidthThreshold; otherwise, NavigationBar is used for navigation.
const double narrowScreenWidthThreshold = 450;

const double mediumWidthBreakpoint = 1000;
const double largeWidthBreakpoint = 1500;

const double transitionLength = 500;

List<NavigationDestination> getAppBarDestinations(BuildContext context) {
  return [
    NavigationDestination(
      tooltip: '',
      icon: Icon(Icons.dns_outlined),
      label: AppLocalizations.of(context)?.host ?? '主机',
      selectedIcon: Icon(Icons.dns),
    ),
    NavigationDestination(
      tooltip: '',
      icon: Icon(Icons.folder_outlined),
      label: 'SFTP',
      selectedIcon: Icon(Icons.folder),
    ),
    NavigationDestination(
      tooltip: '',
      icon: Icon(Icons.code_outlined),
      label: AppLocalizations.of(context)?.snippets ?? '代码片段',
      selectedIcon: Icon(Icons.code),
    ),
    NavigationDestination(
      tooltip: '',
      icon: Icon(Icons.settings_outlined),
      label: AppLocalizations.of(context)?.settings ?? '设置',
      selectedIcon: Icon(Icons.settings),
    )
  ];
}
