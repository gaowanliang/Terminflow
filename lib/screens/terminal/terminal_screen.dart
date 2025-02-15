import 'dart:convert';
import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:terminflow/core/database/database.dart';
import 'package:xterm/xterm.dart';

import 'components/virtual_keyboard.dart';

List<SSHKeyPair> loadIndentity(String key) {
  return SSHKeyPair.fromPem(key);
}

class TerminalScreen extends StatefulWidget {
  final HostInfo? connection;
  final String connectId;
  final ValueNotifier<int> connectionState;
  final ValueNotifier<bool> isHidden;
  const TerminalScreen(
      {super.key,
      this.connection,
      required this.connectId,
      required this.connectionState,
      required this.isHidden});

  @override
  // ignore: library_private_types_in_public_api
  _TerminalScreenState createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  GlobalKey<__TerminalBodyState> terminalKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    // 监听隐藏状态
    widget.isHidden.addListener(_onHiddenChanged);
  }

  void _onHiddenChanged() {
    if (widget.isHidden.value) {
      terminalKey.currentState?._cleanupConnection();
      _disposeTerminal();
    }
  }

  void _disposeTerminal() {
    if (mounted) {
      widget.connectionState.value = 0;
    }
  }

  @override
  void dispose() {
    widget.isHidden.removeListener(_onHiddenChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.connection == null) {
      return const Center(
        child: Text('Please select a connection first'),
      );
    } else {
      // 正常显示终端界面
      return _buildTerminal(context);
    }
  }

  Widget _buildTerminal(BuildContext context) {
    // 具体的终端界面实现
    return _TerminalBody(
      key: terminalKey,
      connection: widget.connection!,
      connectId: widget.connectId,
      connectionState: widget.connectionState,
    );
  }
}

class _TerminalBody extends ConsumerStatefulWidget {
  final HostInfo connection;
  final String connectId;
  final ValueNotifier<int> connectionState;
  const _TerminalBody(
      {super.key,
      required this.connectId,
      required this.connection,
      required this.connectionState});

  @override
  // ignore: library_private_types_in_public_api
  __TerminalBodyState createState() => __TerminalBodyState();
}

class __TerminalBodyState extends ConsumerState<_TerminalBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final terminal = Terminal(inputHandler: keyboard);
  final keyboard = VirtualKeyboard(defaultInputHandler);
  late String title;
  // 添加这些变量来存储连接实例
  SSHClient? _client;
  SSHSession? _session;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    title = widget.connection.name;
    initTerminal();
  }

  @override
  void dispose() {
    // 清理资源
    _cleanupConnection();
    debugPrint('Terminal disposed, connection id is ${widget.connectId}');
    super.dispose();
  }

  void _cleanupConnection() {
    try {
      if (_session != null) {
        _session!.toString();

        _session!.close();

        _session = null;
      }
      if (_client != null) {
        _client!.close();

        _client = null;
      }
      _isConnected = false;
    } catch (e) {
      debugPrint('Error closing SSH connection: $e');
    }
  }

  Future<void> initTerminal() async {
    if (_isConnected) return; // 如果已经连接，直接返回

    terminal.write('Connecting...\r\n');
    widget.connectionState.value = 1; // 设置连接状态为连接中

    try {
      if (widget.connection.passwordType == 0) {
        _client = SSHClient(
          await SSHSocket.connect(
              widget.connection.host, widget.connection.port),
          username: widget.connection.username,
          onPasswordRequest: () => widget.connection.password,
        );
      } else {
        final database = ref.read(AppDatabase.provider);
        final privateKey = await database
            .getPrivateKeyById(widget.connection.privateKeyId ?? 0);
        _client = SSHClient(
          await SSHSocket.connect(
              widget.connection.host, widget.connection.port),
          username: widget.connection.username,
          identities:
              await compute(loadIndentity, privateKey?.privateKey ?? ''),
        );
      }

      terminal.write('Connected\r\n');
      widget.connectionState.value = 2; // 设置连接状态为已连接但未进入
      _isConnected = true;

      // 获取系统版本信息
      String systemVersion = '';
      try {
        final result = await _client?.run('uname -a');
        systemVersion = utf8.decode(result ?? []);
      } catch (e) {
        // 静默处理错误，不影响主流程
      }

      // 将type写入数据库
      const typeList = ['Debian', 'Ubuntu', 'CentOS', 'Arch Linux'];
      var typeNum = 0;
      for (var i = 0; i < typeList.length; i++) {
        if (systemVersion.contains(typeList[i])) {
          typeNum = i + 1;
          break;
        }
      }

      // 在 initTerminal 函数中替换数据库实例化代码
      try {
        final database = ref.read(AppDatabase.provider); // 使用 provider 获取实例
        await database.updateConnectionTypeAndLastLoginTime(
          widget.connection.id,
          typeNum,
        );
      } catch (e) {
        debugPrint('Failed to update connection type: $e');
      }

      debugPrint('System version: $systemVersion');
      _session = await _client!.shell(
        pty: SSHPtyConfig(
          width: terminal.viewWidth,
          height: terminal.viewHeight,
        ),
      );

      terminal.buffer.clear();
      terminal.buffer.setCursor(0, 0);

      terminal.onTitleChange = (title) {
        if (mounted) {
          setState(() => this.title = title);
        }
      };

      terminal.onResize = (width, height, pixelWidth, pixelHeight) {
        _session?.resizeTerminal(width, height, pixelWidth, pixelHeight);
      };

      terminal.onOutput = (data) {
        _session?.write(utf8.encode(data));
      };

      _session?.stdout
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(terminal.write);

      _session?.stderr
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(terminal.write);
      widget.connectionState.value = 3; // 设置连接状态为连接成功
    } catch (e) {
      if (mounted) {
        terminal.write('Connection failed: $e\r\n');
        widget.connectionState.value = 4; // 设置连接状态为连接失败
        _cleanupConnection();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          // AppBar(
          //   title: Text(widget.connectId),
          // ),
          Expanded(
            child: TerminalView(terminal),
          ),
          if (Platform.isIOS || Platform.isAndroid)
            VirtualKeyboardView(keyboard)
        ],
      ),
    );
  }
}
