import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:terminflow/core/database/database.dart';
import 'package:terminflow/data/common/misc.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';
import 'package:terminflow/core/providers/private_key_provider.dart';
import 'package:terminflow/screens/public/card_x.dart';
import 'package:terminflow/screens/public/input_x.dart';
import 'package:terminflow/utils/file_picker.dart';

class PrivateKeySelect extends ConsumerStatefulWidget {
  const PrivateKeySelect(this.privateKeyInfo, {super.key});
  final ValueNotifier<PrivateKey?> privateKeyInfo;

  @override
  ConsumerState<PrivateKeySelect> createState() => _PrivateKeySelectState();
}

class _PrivateKeySelectState extends ConsumerState<PrivateKeySelect>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _keyController = TextEditingController();
  final _pwdController = TextEditingController();
  final _commentController = TextEditingController();
  final _nameNode = FocusNode();
  final _keyNode = FocusNode();
  final _pwdNode = FocusNode();
  final _commentNode = FocusNode();

  late FocusScopeNode _focusScope;

  final _loading = ValueNotifier<Widget?>(null);
  final _tabModel = ValueNotifier<int>(0);
  final _privateKeySelected = ValueNotifier<int?>(null);

  late TabController _tabController;
  late List<String> _tabs;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _keyController.dispose();
    _pwdController.dispose();
    _commentController.dispose();
    _nameNode.dispose();
    _keyNode.dispose();
    _pwdNode.dispose();
    _commentNode.dispose();
    _loading.dispose();
    _tabController.dispose();
    _tabModel.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabs = ['Select from exist', 'Create new']; // 默认值
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabs = [
      AppLocalizations.of(context)?.selectFromExistPK ?? 'Select from exist',
      AppLocalizations.of(context)?.createNewPK ?? 'Create new',
    ];
  }

  List<String> getTabs() => _tabs;

  void _savePrivateKey() async {
    if (_nameController.text.isEmpty || _keyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)?.nameAndPrivateKeyCannotBeEmpty ??
                    'Name and private key cannot be empty')),
      );
      return;
    }

    EasyLoading.show(status: 'loading...');

    try {
      final database = ref.read(AppDatabase.provider);
      final connection = PrivateKeysCompanion.insert(
        name: _nameController.text,
        privateKey: _keyController.text,
        password: Value(_pwdController.text),
        comment: Value(_commentController.text),
      );

      await database.privateKeys.insertOne(connection);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)?.saveSuccess ?? 'Save success')),
        );
        _tabModel.value = 0;
        _tabController.animateTo(0);
      }
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${AppLocalizations.of(context)?.saveFailed ?? "Save failed"}: $e')),
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
    final _allPrivateKeys = ref.watch(privateKeyStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.selectPrivateKey ??
            'Select private key'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ValueListenableBuilder(
              valueListenable: _tabModel,
              builder: (BuildContext context, dynamic value, Widget? child) {
                return AnimatedCrossFade(
                  firstChild: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.check_circle)),
                  secondChild: IconButton(
                      onPressed: () => _savePrivateKey(),
                      icon: Icon(Icons.save)),
                  crossFadeState: value == 0
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 300),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildTableBarView(_allPrivateKeys)),
        ],
      ),
    );
  }

  String _standardizeLineSeparators(String value) {
    return value.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  }

  Widget _buildTabBar() => TabBar(
        onTap: (tab) {
          _tabModel.value = tab;
          widget.privateKeyInfo.value = null;
        },
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 16),
        // isScrollable: true,
        controller: _tabController,
        // labelColor: Colors.blue,
        indicatorWeight: 3,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
        unselectedLabelColor: Colors.grey,
        // indicatorColor: Colors.orangeAccent,
        tabs: getTabs().map((e) => Tab(text: e)).toList(),
      );

  void _importFromFile() async {
    final path = await Pfs.pickFilePath();
    if (path == null) return;

    final file = File(path);

    if (!file.existsSync()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.pathIsNotExists(path) ??
                '$path is not exists'),
          ),
        );
      }
      return;
    }
    final size = (await file.stat()).size;
    if (size > Miscs.privateKeyMaxSize) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.fileSizeIsTooLarge ??
                'File size is too large'),
          ),
        );
      }
      return;
    }

    final content = await file.readAsString();
    // dartssh2 accepts only LF (but not CRLF or CR)
    _keyController.text = _standardizeLineSeparators(content.trim());
  }

  Widget _buildTableBarView(AsyncValue<List<PrivateKey>> allPrivateKeys) =>
      TabBarView(controller: _tabController, children: [
        allPrivateKeys.when(
          data: (privateKeys) => ValueListenableBuilder(
              valueListenable: _privateKeySelected,
              builder: (context, value, child) {
                return ListView.builder(
                  itemCount: privateKeys.length,
                  itemBuilder: (context, index) {
                    final privateKey = privateKeys[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: CardX(
                        child: CheckboxListTile(
                          value: _privateKeySelected.value == index,
                          onChanged: (value) {
                            _privateKeySelected.value = value! ? index : null;
                            widget.privateKeyInfo.value =
                                value ? privateKeys[index] : null;
                          },
                          title: Text(privateKey.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            privateKey.comment ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(150),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InputX(
                  autoFocus: true,
                  controller: _nameController,
                  type: TextInputType.text,
                  label: "${AppLocalizations.of(context)?.name ?? 'Name'}*",
                  icon: Icons.title,
                  node: _nameNode,
                  onSubmitted: (_) => _focusScope.requestFocus(_keyNode),
                  obscureText: false,
                  autoCorrect: true,
                  suggestion: true,
                ),
                CardX(
                  child: Column(
                    children: [
                      InputX(
                        controller: _keyController,
                        backgroundColor: Colors.transparent,
                        type: TextInputType.text,
                        label:
                            "${AppLocalizations.of(context)?.privateKeyText ?? 'Private key text'}*",
                        icon: Icons.vpn_key,
                        node: _keyNode,
                        onSubmitted: (_) => _focusScope.requestFocus(_pwdNode),
                        minLines: 3,
                        maxLines: 10,
                        suggestion: false,
                      ),
                      InkWell(
                        onTap: () => _importFromFile(),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              AppLocalizations.of(context)?.importFromFile ??
                                  'Import from file',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                InputX(
                  controller: _pwdController,
                  type: TextInputType.text,
                  label: AppLocalizations.of(context)?.password ?? 'Password',
                  icon: Icons.password,
                  node: _pwdNode,
                  onSubmitted: (_) => _focusScope.requestFocus(_commentNode),
                  obscureText: true,
                  autoCorrect: true,
                  suggestion: true,
                ),
                InputX(
                  controller: _commentController,
                  type: TextInputType.text,
                  label: AppLocalizations.of(context)?.comment ?? 'Comment',
                  icon: Icons.message,
                  node: _commentNode,
                  onSubmitted: (_) => _focusScope.unfocus(),
                  obscureText: false,
                  autoCorrect: true,
                  suggestion: true,
                ),
              ],
            ),
          ),
        )
      ]);
}
