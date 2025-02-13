import 'package:flutter/material.dart';
import 'package:terminflow/core/database/database.dart';

class SSHTab {
  final String id;
  final String name;
  final HostInfo? host;
  final Widget? terminal;

  SSHTab({
    required this.id,
    required this.name,
    this.host,
    this.terminal,
  });

  SSHTab copyWith({
    String? id,
    String? name,
    HostInfo? host,
    Widget? terminal,
  }) {
    return SSHTab(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      terminal: terminal ?? this.terminal,
    );
  }
}
