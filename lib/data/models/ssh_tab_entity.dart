import 'package:flutter/material.dart';
import 'package:terminflow/core/database/database.dart';

class SSHTab {
  final String id;
  final String name;
  final HostInfo? host;
  final ValueNotifier<int>
      connectionState; // 0: 未连接 1: 连接中 2: 已连接但未进入 3: 连接成功 4: 连接失败
  final Widget? terminal;
  final ValueNotifier<bool> isHidden; // 新增隐藏状态

  SSHTab({
    required this.id,
    required this.name,
    required this.connectionState,
    this.host,
    this.terminal,
    required this.isHidden,
  });

  SSHTab copyWith({Widget? terminal}) {
    return SSHTab(
        id: id,
        name: name,
        connectionState: connectionState,
        host: host,
        terminal: terminal ?? this.terminal,
        isHidden: isHidden);
  }
}
