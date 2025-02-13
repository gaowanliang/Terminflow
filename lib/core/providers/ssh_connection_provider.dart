import 'package:dartssh2/dartssh2.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<SSHKeyPair> loadIndentity(String key) {
  return SSHKeyPair.fromPem(key);
}

class SSHConnection {
  final String id;
  final SSHClient? client;
  final SSHSession? session;
  final bool isConnected;

  SSHConnection({
    required this.id,
    required this.client,
    required this.session,
    required this.isConnected,
  });
}

class SSHConnectionsNotifier extends StateNotifier<List<SSHConnection>> {
  SSHConnectionsNotifier()
      : super([
          SSHConnection(
            id: 'home',
            client: null,
            session: null,
            isConnected: false,
          ),
        ]);

  void addConnection(
      String id, SSHClient client, SSHSession session, bool isConnected) {
    // 检查是否已存在相同的连接
    final existingConnection = state.firstWhere(
      (connection) => connection.id == id,
      orElse: () => SSHConnection(
        id: id,
        client: client,
        session: session,
        isConnected: isConnected,
      ),
    );

    if (!state.contains(existingConnection)) {
      state = [...state, existingConnection];
    }
  }

  void removeConnection(String id) {
    if (id != 'home' && state.length > 1) {
      state = state.where((connection) => connection.id != id).toList();
    }
  }

  SSHConnection? getConnection(String id) {
    try {
      return state.firstWhere((connection) => connection.id == id);
    } catch (e) {
      return null;
    }
  }
}

final sshConnectionProvider =
    StateNotifierProvider<SSHConnectionsNotifier, List<SSHConnection>>((ref) {
  return SSHConnectionsNotifier();
});
