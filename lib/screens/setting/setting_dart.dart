import 'package:flutter/material.dart';
import 'package:terminflow/data/common/responsive.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';
import 'package:terminflow/data/common/animation_class.dart';

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

class _SettingScreenState extends State<SettingScreen>
    with TickerProviderStateMixin {
  late List<ListInfo> listInfo;
  bool _initialized = false;
  late AnimationController _animationController;
  late CurvedAnimation _railAnimation;
  int _selectedIndex = 3; // 默认选择"同步管理"
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _railAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 1.0),
    );

    _tabController =
        TabController(length: 5, vsync: this, initialIndex: _selectedIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
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
      _updateAnimationState();
    }
  }

  void _updateAnimationState() {
    if (Responsive.isDesktop(context)) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 监听尺寸变化以更新动画状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAnimationState();
    });

    return Scaffold(
      appBar: !Responsive.isDesktop(context)
          ? AppBar(
              title: Text(AppLocalizations.of(context)?.settings ?? 'Settings'),
              bottom: TabBar(
                controller: _tabController,
                tabs: listInfo
                    .map((item) => Tab(
                          icon: Icon(item.icon),
                          text: item.title,
                        ))
                    .toList(),
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                labelColor: Theme.of(context).colorScheme.primary,
                indicatorColor: Theme.of(context).colorScheme.primary,
                dividerColor: Colors.transparent,
              ),
            )
          : null,
      body: Padding(
        padding: Responsive.isMobile(context)
            ? const EdgeInsets.symmetric(horizontal: 16)
            : const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _railAnimation,
              builder: (context, child) {
                return SettingSidebarTransition(
                  animation: _railAnimation,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: Container(
                    width: 250,
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
                            selected: _selectedIndex == index,
                            selectedTileColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            leading: Icon(listInfo[index].icon),
                            title: Text(listInfo[index].title),
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                                // 同步TabController的索引
                                _tabController.animateTo(index);
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: listInfo.length,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _buildSettingContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingContent() {
    // 根据选择的索引显示不同的内容
    switch (_selectedIndex) {
      case 0: // 偏好设置
        return Center(
            child: Text(
                AppLocalizations.of(context)?.preferences ?? 'Preferences'));
      case 1: // 外观
        return Center(
            child:
                Text(AppLocalizations.of(context)?.appearance ?? 'Appearance'));
      case 2: // 密钥管理
        return Center(
            child: Text(AppLocalizations.of(context)?.privateKeyManagement ??
                'Private Key Management'));
      case 3: // 同步管理
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)?.syncWords ?? 'Sync Words',
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
                      child: Text(AppLocalizations.of(context)
                              ?.selectRemoteServiceTip ??
                          'Start here to set up which service you want to connect to? Will support services such as S3, WebDAV, OneDrive, etc.')),
                  const SizedBox(width: 16),
                  DropdownMenu(
                    width: MediaQuery.of(context).size.width * 0.15,
                    label: Text(
                      AppLocalizations.of(context)?.remoteService ??
                          'Remote Service',
                    ),
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                          value: "s3",
                          label: AppLocalizations.of(context)?.s3OrCompatible ??
                              'S3 (or compatible S3 service)'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              S3SettingWidget(),
            ],
          ),
        );
      case 4: // 关于
        return Center(
            child: Text(AppLocalizations.of(context)?.about ?? 'About'));
      default:
        return const Center(child: Text('Unknown Setting'));
    }
  }
}

class SettingSidebarTransition extends StatefulWidget {
  const SettingSidebarTransition({
    Key? key,
    required this.animation,
    required this.backgroundColor,
    required this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final Widget child;
  final Color backgroundColor;

  @override
  State<SettingSidebarTransition> createState() =>
      _SettingSidebarTransitionState();
}

class _SettingSidebarTransitionState extends State<SettingSidebarTransition> {
  late Animation<Offset> offsetAnimation;
  late Animation<double> widthAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bool ltr = Directionality.of(context) == TextDirection.ltr;

    widthAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(SizeAnimation(widget.animation));

    offsetAnimation = Tween<Offset>(
      begin: ltr ? const Offset(-1, 0) : const Offset(1, 0),
      end: Offset.zero,
    ).animate(OffsetAnimation(widget.animation));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(color: widget.backgroundColor.withOpacity(0)),
        child: Align(
          alignment: Alignment.topLeft,
          widthFactor: widthAnimation.value,
          child: FractionalTranslation(
            translation: offsetAnimation.value,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
