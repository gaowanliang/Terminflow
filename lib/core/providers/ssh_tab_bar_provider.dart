import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:terminflow/core/database/database.dart';
import 'package:terminflow/data/models/ssh_tab_entity.dart';
import 'package:terminflow/screens/host/components/host_main_context.dart';
import 'package:terminflow/screens/terminal/terminal_screen.dart';

class SSHTabsNotifier extends StateNotifier<List<SSHTab>> {
  SSHTabsNotifier()
      : super([
          SSHTab(
            id: 'home',
            name: 'Home',
            connectionState: ValueNotifier<int>(0),
            host: null, // 创建一个空的 HostInfo 对象
            terminal: const HostMainContent(),
            isHidden: ValueNotifier<bool>(false),
          ),
        ]);

  void addTab(HostInfo host) {
    final id = DateTime.now().toString();
    final ValueNotifier<int> connectionState = ValueNotifier<int>(0);
    final ValueNotifier<bool> isHidden = ValueNotifier<bool>(false);
    final newTab = SSHTab(
      id: id,
      name: host.name,
      connectionState: connectionState,
      host: host,
      // 为终端添加 key
      terminal: TerminalScreen(
        key: ValueKey(id),
        connection: host,
        connectId: id,
        connectionState: connectionState,
        isHidden: isHidden,
      ),
      isHidden: isHidden,
    );
    state = [...state, newTab];
  }

  void removeTab(String tabId) {
    if (tabId != 'home' && state.length > 1) {
      state = state.where((tab) => tab.id != tabId).toList();
    }
  }

  void hideTab(String tabId) {
    if (tabId != 'home') {
      state = state.map((tab) {
        if (tab.id == tabId) {
          tab.isHidden.value = true;
          return tab.copyWith(terminal: null);
        }
        return tab;
      }).toList();
    }
  }
}

final sshTabsProvider =
    StateNotifierProvider<SSHTabsNotifier, List<SSHTab>>((ref) {
  return SSHTabsNotifier();
});
