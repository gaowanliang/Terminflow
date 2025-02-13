import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DrawerNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggleDrawer() {
    state = !state;
  }

  void openDrawer() {
    state = true;
  }

  void closeDrawer() {
    state = false;
  }
}

final drawerProvider = NotifierProvider<DrawerNotifier, bool>(() {
  return DrawerNotifier();
});

class DrawerContentNotifier extends Notifier<Widget> {
  @override
  Widget build() => Container();

  void setDrawerContent(Widget widget) {
    state = widget;
  }
}

final drawerContentProvider =
    NotifierProvider<DrawerContentNotifier, Widget>(() {
  return DrawerContentNotifier();
});
