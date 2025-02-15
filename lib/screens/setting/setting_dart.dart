import 'package:flutter/material.dart';
import 'package:terminflow/data/common/responsive.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';

import 'components/s3_setting_widget.dart';
import 'components/sync_words_widget.dart';

class ListInfo {
  final IconData icon;
  final String title;

  ListInfo({
    required this.icon,
    required this.title,
  });
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late List<ListInfo> listInfo;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // 移除这里的初始化代码
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      listInfo = [
        ListInfo(
          icon: Icons.tune,
          title: AppLocalizations.of(context)?.preferences ?? 'Preferences',
        ),
        ListInfo(
          icon: Icons.color_lens,
          title: AppLocalizations.of(context)?.appearance ?? 'Appearance',
        ),
        ListInfo(
          icon: Icons.key,
          title: AppLocalizations.of(context)?.privateKeyManagement ??
              'Private Key Management',
        ),
        ListInfo(
          icon: Icons.cloud_sync,
          title:
              AppLocalizations.of(context)?.syncManagement ?? 'Sync Management',
        ),
        ListInfo(
          icon: Icons.help,
          title: AppLocalizations.of(context)?.about ?? 'About',
        ),
      ];
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Responsive.isMobile(context)
            ? const EdgeInsets.symmetric(horizontal: 16)
            : const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(listInfo[index].icon),
                        title: Text(listInfo[index].title),
                        onTap: () {},
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: listInfo.length,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          AppLocalizations.of(context)?.syncWords ??
                              'Sync Words',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context)?.syncWordsTip ??
                          'Your sync words can protect your data, when you sync on a new device, you can use the sync words to decrypt your data. Keep it in a safe place. During sync, your data will be encrypted and uploaded to the peer, but this sync words will not be uploaded. Click to show:'),
                      const SizedBox(height: 16),
                      SyncWordsWidget(),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                          AppLocalizations.of(context)?.selectRemoteService ??
                              'Select Remote Service',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Text(
                                  AppLocalizations.of(context)?.selectRemoteServiceTip ??
                                      'Start here to set up which service you want to connect to? Will support services such as S3, WebDAV, OneDrive, etc.')),
                          const SizedBox(width: 16),
                          DropdownMenu(
                            width: MediaQuery.of(context).size.width * 0.15,
                            label: Text(
                              AppLocalizations.of(context)
                                      ?.remoteService ??
                                  'Remote Service',
                            ),
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                  value: "s3",
                                  label: AppLocalizations.of(context)
                                          ?.s3OrCompatible ??
                                      'S3 (or compatible S3 service)'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      S3SettingWidget(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
