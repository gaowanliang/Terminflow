import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:terminflow/data/common/responsive.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';
import 'package:terminflow/screens/public/card_x.dart';
import 'package:word_generator/word_generator.dart';

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

  static List<ListInfo> listInfo = [
    ListInfo(
      icon: Icons.tune,
      title: '偏好设定',
    ),
    ListInfo(
      icon: Icons.color_lens,
      title: '外观',
    ),
    ListInfo(
      icon: Icons.key,
      title: '私钥管理',
    ),
    ListInfo(
      icon: Icons.cloud_sync,
      title: '同步管理',
    ),
    ListInfo(
      icon: Icons.help,
      title: "关于",
    ),
  ];

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
                  color:
                      Theme.of(context).colorScheme.onPrimary.withAlpha(50),
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
                        leading: Icon(SettingScreen.listInfo[index].icon),
                        title: Text(SettingScreen.listInfo[index].title),
                        onTap: () {},
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: SettingScreen.listInfo.length,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('同步短语',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(
                      '您的同步短语可以保护您的数据，当您在新设备上同步时，您可以使用同步短语来解密您的数据。将其保存在安全的地方。在同步时，您的数据将被加密并上传到对端，但此同步短语将不会上传。点击显示：',
                    ),
                    const SizedBox(height: 16),
                    SyncWordsWidget(),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text('选择远程服务',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    CardX(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Text(
                                  "从这里开始设置，你想连接到哪个服务？将会支持S3、WebDAV、OneDrive等服务。")),
                          const SizedBox(width: 16),
                          DropdownMenu(
                            width: MediaQuery.of(context).size.width * 0.15,
                            label: Text(
                              AppLocalizations.of(context)?.group ?? '分组',
                            ),
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                  value: "s3", label: "S3 (或兼容S3的服务)"),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class SyncWordsWidget extends StatefulWidget {
  const SyncWordsWidget({super.key});

  @override
  State<SyncWordsWidget> createState() => _SyncWordsWidgetState();
}

class _SyncWordsWidgetState extends State<SyncWordsWidget> {
  final storage = FlutterSecureStorage();
  static List<Color> colors = [
    Colors.red,
    Colors.deepOrange,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
    Colors.lime,
    Colors.amber,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  bool _isBlurred = true;

  Future<String> getSyncWords() async {
    debugPrint('getSyncWords');

    try {
      String? value = await storage.read(key: 'syncWords');
      debugPrint('value: $value');
      if (value != null) {
        return value;
      } else {
        final wordGenerator = WordGenerator();
        final words = wordGenerator.randomSentence(16);
        await storage.write(key: 'syncWords', value: words);
        return words;
      }
    } catch (e) {
      debugPrint('error: $e');
      return '123 456 789 123 456 789 123 456 789 123 456 789 123 456 789 123 456 789';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ImageFiltered(
                imageFilter: _isBlurred
                    ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
                    : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() {
                      _isBlurred = !_isBlurred;
                    });
                  },
                  child: FutureBuilder(
                      future: getSyncWords(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final wordsList = snapshot.data.toString().split(' ');
                        return Wrap(
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            wordsList.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Text(
                                wordsList[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colors[index % colors.length],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                  _isBlurred ? Icons.remove_red_eye : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isBlurred = !_isBlurred;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
