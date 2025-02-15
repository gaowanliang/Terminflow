import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:terminflow/core/crypto/crypto_data.dart';
import 'package:terminflow/core/s3/s3_api.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';
import 'package:terminflow/screens/public/input_x.dart';

class S3SettingWidget extends StatefulWidget {
  const S3SettingWidget({
    super.key,
  });

  @override
  State<S3SettingWidget> createState() => _S3SettingWidgetState();
}

class _S3SettingWidgetState extends State<S3SettingWidget> {
  final TextEditingController endpointController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController accessKeyController = TextEditingController();
  final TextEditingController secretAccessKeyController =
      TextEditingController();
  final TextEditingController bucketNameController = TextEditingController();
  final storage = FlutterSecureStorage();

  void upload() async {
    final appDir = await getApplicationSupportDirectory();
    final path = p.join(appDir.path, 'Terminflow.sqlite');
    debugPrint('path: $path');

    try {
      // 读取文件内容
      final file = File(path);
      if (!await file.exists()) {
        debugPrint('文件不存在: $path');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    AppLocalizations.of(context)?.pathIsNotExists(path) ??
                        '$path is not exists')),
          );
        }
        return;
      }

      // 将文件内容读取为List<int>
      final List<int> fileBytes = await file.readAsBytes();

      S3Api.init(
        endpoint: endpointController.text,
        region: regionController.text,
        accessKeyId: accessKeyController.text,
        secretAccessKey: secretAccessKeyController.text,
      );

      await S3Api.putObject(
        bucket: bucketNameController.text,
        objectName: 'Terminflow.sqlite',
        objectBytes: fileBytes, // 传入读取的字节数据
      );

      // 可选：显示上传成功消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)?.fileUploadSuccess ??
                  'File upload success')),
        );
      }
    } catch (e) {
      debugPrint('error: $e');
      // 可选：显示错误消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)
                      ?.fileUploadFailed(e.toString()) ??
                  'File upload failed: ${e.toString()}')),
        );
      }
    }
  }

  void pull() async {
    final appDir = await getApplicationSupportDirectory();
    final path = p.join(appDir.path, 'Terminflow.sqlite');

    debugPrint('path: $path');

    try {
      S3Api.init(
        endpoint: endpointController.text,
        region: regionController.text,
        accessKeyId: accessKeyController.text,
        secretAccessKey: secretAccessKeyController.text,
      );

      final fileBytes = await S3Api.getObject(
        bucket: bucketNameController.text,
        objectName: 'Terminflow.sqlite',
      );

      final file = File(path);
      await file.writeAsBytes(fileBytes);

      // 可选：显示下载成功消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)?.fileDownloadSuccess ??
                  'File download success')),
        );
      }
    } catch (e) {
      debugPrint('error: $e');
      // 可选：显示错误消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)
                      ?.fileDownloadFailed(e.toString()) ??
                  'File download failed: ${e.toString()}')),
        );
      }
    }
  }

  void copy() async {
    final allInfo = {
      'endpoint': endpointController.text,
      'region': regionController.text,
      'accessKeyId': accessKeyController.text,
      'secretAccessKey': secretAccessKeyController.text,
      'bucketName': bucketNameController.text,
    };

    // 转换为 JSON 字符串，再转为 Uint8List
    final jsonString = jsonEncode(allInfo);
    final data = Uint8List.fromList(utf8.encode(jsonString));

    try {
      String? mnemonic = await storage.read(key: 'syncWords');
      debugPrint('value: $mnemonic');
      if (mnemonic != null) {
        // 加密数据
        final encrypted = CryptoData.encryptWithMnemonic(data, mnemonic);

        // 转换为 base64 编码
        final base64Data = {
          'cipherText': base64.encode(encrypted['cipherText']!),
          'authTag': base64.encode(encrypted['authTag']!),
          'nonce': base64.encode(encrypted['nonce']!),
        };

        // 转换为 JSON 字符串
        final encryptedString = jsonEncode(base64Data);

        // 复制到剪贴板
        await Clipboard.setData(
            ClipboardData(text: base64.encode(utf8.encode(encryptedString))));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)
                        ?.configAlreadyPasteToClipboard ??
                    'Config already paste to clipboard')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)?.syncWordsNotSet ??
                  'Sync words not set')));
        }
        debugPrint('value is null');
      }
    } catch (e) {
      debugPrint('error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)
                      ?.configPasteToClipboardFailed(e.toString()) ??
                  'Config paste to clipboard failed: ${e.toString()}')),
        );
      }
    }
  }

  void paste() async {
    try {
      // 从剪贴板获取数据
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text == null) {
        throw Exception('剪贴板为空');
      }
      debugPrint('clipboardData: ${clipboardData?.text}');

      // 解码 base64 并解析 JSON
      final String decodedString =
          utf8.decode(base64.decode(clipboardData?.text ?? ''));
      final encryptedData = jsonDecode(decodedString);
      debugPrint('encryptedData: $encryptedData');
      debugPrint('cipherText: ${encryptedData['cipherText']}');
      debugPrint('authTag: ${encryptedData['authTag']}');
      debugPrint('nonce: ${encryptedData['nonce']}');

      // 转换回 Uint8List
      final encrypted = {
        'cipherText': base64.decode(encryptedData['cipherText']!),
        'authTag': base64.decode(encryptedData['authTag']!),
        'nonce': base64.decode(encryptedData['nonce']!),
      };

      debugPrint('encrypted: $encrypted');

      // 获取助记词
      String? mnemonic = await storage.read(key: 'syncWords');
      if (mnemonic == null) {
        throw Exception('同步密钥未设置');
      }

      // 解密数据
      final decrypted = CryptoData.decryptWithMnemonic(
        encrypted['cipherText']!,
        encrypted['authTag']!,
        encrypted['nonce']!,
        mnemonic,
      );

      // 解析 JSON
      final Map<String, dynamic> config = jsonDecode(utf8.decode(decrypted));

      // 更新控制器
      setState(() {
        endpointController.text = config['endpoint'];
        regionController.text = config['region'];
        accessKeyController.text = config['accessKeyId'];
        secretAccessKeyController.text = config['secretAccessKey'];
        bucketNameController.text = config['bucketName'];
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)?.configAlreadyRestore ??
                      'Config already restore')),
        );
      }
    } catch (e) {
      debugPrint('error: $e');
      if (mounted) {
        if (e.toString().contains('InvalidCipherTextException')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)?.syncWordsError ??
                    'Sync words error')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)
                        ?.configRestoreFailed(e.toString()) ??
                    'Config restore failed: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton(
                  iconSize: 14, onPressed: copy, icon: Icon(Icons.copy)),
            ),
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton(
                  iconSize: 14, onPressed: paste, icon: Icon(Icons.paste)),
            ),
          ],
        ),
        InputX(
          autoFocus: true,
          controller: endpointController,
          type: TextInputType.text,
          label: "Endpoint",
          icon: Icons.cloud,
          obscureText: false,
          autoCorrect: true,
          suggestion: true,
        ),
        InputX(
          autoFocus: true,
          controller: regionController,
          type: TextInputType.text,
          label: "Region",
          icon: Icons.location_on,
          obscureText: false,
          autoCorrect: true,
          suggestion: true,
        ),
        InputX(
          autoFocus: true,
          controller: accessKeyController,
          type: TextInputType.text,
          label: "Access Key ID",
          icon: Icons.key,
          obscureText: false,
          autoCorrect: true,
          suggestion: true,
        ),
        InputX(
          autoFocus: true,
          controller: secretAccessKeyController,
          type: TextInputType.text,
          label: "Secret Access Key",
          icon: Icons.fingerprint,
          obscureText: true,
          autoCorrect: true,
          suggestion: true,
        ),
        InputX(
          autoFocus: true,
          controller: bucketNameController,
          type: TextInputType.text,
          label: "Bucket Name",
          icon: MingCute.server_2_fill,
          obscureText: false,
          autoCorrect: true,
          suggestion: true,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: upload,
              child: Text(AppLocalizations.of(context)?.manualUpload ??
                  'Manual Upload'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: pull,
              child: Text(
                  AppLocalizations.of(context)?.manualPull ?? 'Manual Pull'),
            ),
          ],
        ),
      ],
    );
  }
}
