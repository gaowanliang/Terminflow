import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

extension StringExtension on String {
  String get capitalize =>
      isEmpty ? this : this[0].toUpperCase() + substring(1);
}

/// Platforms
enum Pfs {
  android,
  ios,
  linux,
  macos,
  windows,
  web,
  fuchsia,
  unknown;

  static final type = () {
    if (kIsWeb) {
      return web;
    }
    if (Platform.isAndroid) {
      return android;
    }
    if (Platform.isIOS) {
      return ios;
    }
    if (Platform.isLinux) {
      return linux;
    }
    if (Platform.isMacOS) {
      return macos;
    }
    if (Platform.isWindows) {
      return windows;
    }
    if (Platform.isFuchsia) {
      return fuchsia;
    }
    return unknown;
  }();

  @override
  String toString() => switch (this) {
        macos => 'macOS',
        ios => 'iOS',
        final val => val.name.capitalize,
      };

  static final String seperator = isWindows ? '\\' : '/';

  /// Available only on desktop,
  /// return null on mobile
  static final String? homeDir = () {
    final envVars = Platform.environment;
    if (isMacOS || isLinux) {
      return envVars['HOME'];
    } else if (isWindows) {
      return envVars['UserProfile'];
    }
    return null;
  }();

  /// Open share sheet on mobile, reveal in file explorer on desktop.
  /// - [path] or [bytes] or [content] is required.
  static Future<void> share({
    String? path,
    Uint8List? bytes,
    String? content,
    String name = 'fl_lib_share',
    String? mime,
  }) async {
    if (path == null && bytes == null && content == null) {
      throw ArgumentError('path / bytes / content is required');
    }

    if (isDesktop) {
      if (path != null) {
        await revealPath(path);
      } else {
        final tempDir = Directory.systemTemp;
        var file = File('${tempDir.path}/$name');
        if (await file.exists()) {
          final nameWithoutExt = name.split('.').firstOrNull ?? name;
          final ext = name.split('.').lastOrNull ?? '';
          var i = 1;
          while (await file.exists()) {
            file = File('${tempDir.path}/$nameWithoutExt-$i.$ext');
            i++;
          }
        }
        if (bytes != null) {
          await file.writeAsBytes(bytes);
        } else if (content != null) {
          await file.writeAsString(content);
        }
        await revealPath(file.path);
      }
      return;
    }

    final XFile xfile;
    if (path != null) {
      xfile = XFile(path, name: name, mimeType: mime);
    } else if (bytes != null) {
      xfile = XFile.fromData(bytes, name: name, mimeType: mime);
    } else {
      xfile = XFile.fromData(utf8.encode(content!), name: name, mimeType: mime);
    }
    await Share.shareXFiles([xfile]);
  }

  static Future<void> shareStr(String name, String data, {String? mime}) async {
    await Share.shareXFiles(
      [XFile.fromData(utf8.encode(data), name: name, mimeType: mime)],
    );
  }

  static Future<PlatformFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    return result?.files.single;
  }

  static Future<String?> pickFilePath() async {
    final picked = await pickFile();
    return picked?.path;
  }

  static Future<String?> pickFileString() async {
    final picked = await pickFile();
    if (picked == null) return null;

    switch (Pfs.type) {
      case Pfs.web:
        final bytes = picked.bytes;
        if (bytes == null) return null;
        return utf8.decode(bytes);
      default:
        final path = picked.path;
        if (path == null) return null;
        return await File(path).readAsString();
    }
  }

  static void copy(dynamic data) => switch (data.runtimeType) {
        const (String) => Clipboard.setData(ClipboardData(text: data)),
        final val => throw UnimplementedError(
            'Not supported type: $val(${val.runtimeType})'),
      };

  static Future<String?> paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  /// Reveal file / dir in file app.
  ///
  /// **Only available on desktop**
  static Future<void> revealPath(String path) async {
    try {
      switch (type) {
        case Pfs.macos:
          await Process.run('open', ['--reveal', path]);
          break;
        case Pfs.windows:
          await Process.run(
              'explorer', ['/select,', path.replaceAll('"', '""')]);
          break;
        case Pfs.linux:
          await Process.run('xdg-open', [path]);
          break;
        default:
          throw UnimplementedError('Unsupported platform: $type');
      }
    } catch (e) {
      Logger.root.warning('reveal path: $path', e);
    }
  }
}

final isAndroid = Pfs.type == Pfs.android;
final isIOS = Pfs.type == Pfs.ios;
final isLinux = Pfs.type == Pfs.linux;
final isMacOS = Pfs.type == Pfs.macos;
final isWindows = Pfs.type == Pfs.windows;
final isWeb = Pfs.type == Pfs.web;
final isMobile = Pfs.type == Pfs.ios || Pfs.type == Pfs.android;
final isDesktop =
    Pfs.type == Pfs.linux || Pfs.type == Pfs.macos || Pfs.type == Pfs.windows;
