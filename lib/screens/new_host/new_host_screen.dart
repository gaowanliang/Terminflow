import 'dart:math';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:terminflow/core/database/database.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';

import 'components/basic_information_card.dart';
import 'components/ssh_information_card.dart';

class NewHostScreen extends ConsumerStatefulWidget {
  final HostInfo? hostInfo;
  const NewHostScreen(this.hostInfo, {super.key});

  @override
  ConsumerState<NewHostScreen> createState() => _NewHostScreenState();
}

class _NewHostScreenState extends ConsumerState<NewHostScreen> {
  final _nameController = TextEditingController();
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _commentController = TextEditingController();
  final _tagController = TextEditingController();
  var usePrivateKey = ValueNotifier<int?>(null);
  final privateKeyInfo = ValueNotifier<PrivateKey?>(null);
  int _type = 0;

  @override
  void initState() {
    super.initState();
    _loadInitData();
  }

  _loadInitData() async {
    debugPrint('init data');
    if (widget.hostInfo != null) {
      _nameController.text = widget.hostInfo!.name;
      _hostController.text = widget.hostInfo!.host;
      _portController.text = widget.hostInfo!.port.toString();
      _usernameController.text = widget.hostInfo!.username;
      if (widget.hostInfo?.comment != null) {
        _commentController.text = widget.hostInfo!.comment!;
      }

      //TODO _tagController.text = widget.hostInfo!.tagNum.toString();
      usePrivateKey.value = widget.hostInfo!.passwordType == 1 ? 1 : null;
      if (widget.hostInfo!.username.isNotEmpty) {
        _usernameController.text = widget.hostInfo!.username;
      }

      if (usePrivateKey.value != null) {
        final database = ref.read(AppDatabase.provider);
        final privateKey =
            await database.getPrivateKeyById(widget.hostInfo!.privateKeyId!);
        privateKeyInfo.value = privateKey;
      } else {
        if (widget.hostInfo?.password != null) {
          _passwordController.text = widget.hostInfo!.password!;
        }
      }

      _type = widget.hostInfo!.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _commentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _saveHost() async {
    // final dir = await getApplicationSupportDirectory();
    // debugPrint('dir: $dir');
    if (_nameController.text.isEmpty || _hostController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('名称和地址不能为空')),
      );
      return;
    }
    final port = _portController.text.isEmpty ? '22' : _portController.text;

    debugPrint('name: ${_nameController.text}');
    debugPrint('host: ${_hostController.text}');
    debugPrint('port: $port');
    debugPrint('username: ${_usernameController.text}');
    debugPrint('password: ${_passwordController.text}');
    debugPrint('comment: ${_commentController.text}');
    debugPrint('tag: ${_tagController.text}');

    EasyLoading.show(status: 'loading...');

    try {
      final connection = HostInfosCompanion.insert(
        name: _nameController.text,
        host: _hostController.text,
        type: Value(_type),
        port: Value(int.parse(port)),
        username: _usernameController.text,
        passwordType: usePrivateKey.value != null ? Value(1) : Value(0),
        password: Value(_passwordController.text),
        comment: Value(_commentController.text),
        tagNum: [1],
        lastLoginTime: const Value(null),
        privateKeyId: usePrivateKey.value != null
            ? Value(privateKeyInfo.value?.id)
            : const Value(null),
      );

      final database = ref.read(AppDatabase.provider);
      if (widget.hostInfo != null) {
        database.hostInfos.update()
          ..where((t) => t.id.equals(widget.hostInfo!.id))
          ..write(connection);
      } else {
        await database.hostInfos.insertOne(connection);
      }

      //debugPrint(privateKeyInfo.value?.name ?? 'Error');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存成功')),
        );
        Navigator.of(context).pop();
      }
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败: $e')),
      );
      debugPrintStack(label: e.toString(), stackTrace: s);
    } finally {
      if (mounted) {
        EasyLoading.dismiss();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 添加关闭按钮
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        title: Text(AppLocalizations.of(context)?.newHost ?? '新建主机'),
        actions: [
          IconButton(
              onPressed: () {
                _saveHost();
              },
              icon: const Icon(Icons.save)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            children: [
              BasicInfomationCard(
                nameController: _nameController,
                addressController: _hostController,
                tagController: _tagController,
                commentController: _commentController,
              ),
              const SizedBox(height: 16),
              SSHInformationCard(
                portController: _portController,
                usernameController: _usernameController,
                passwordController: _passwordController,
                usePrivateKey: usePrivateKey,
                privateKeyInfo: privateKeyInfo,
              ),
              const SizedBox(height: 16),
              // widget Name: Jump Server
              // JumpServerCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
