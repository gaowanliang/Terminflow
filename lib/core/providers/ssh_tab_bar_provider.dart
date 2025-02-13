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
            host: null, // 创建一个空的 HostInfo 对象
            terminal: const HostMainContent(),
          ),
        ]);

  void addTab(HostInfo host) {
    // 检查是否已存在相同的连接
    final id = DateTime.now().toString();
    final existingTab = state.firstWhere(
      (tab) => tab.host?.id == host.id,
      orElse: () => SSHTab(
        id: id,
        name: host.name,
        host: host,
        terminal: TerminalScreen(connection: host, connectId: id),
      ),
    );

    if (!state.contains(existingTab)) {
      state = [...state, existingTab];
    }
  }

  void removeTab(String tabId) {
    if (tabId != 'home' && state.length > 1) {
      state = state.where((tab) => tab.id != tabId).toList();
    }
  }
}

final sshTabsProvider =
    StateNotifierProvider<SSHTabsNotifier, List<SSHTab>>((ref) {
  return SSHTabsNotifier();
});
