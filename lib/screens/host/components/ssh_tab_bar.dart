import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:terminflow/core/providers/ssh_tab_bar_provider.dart';
import 'package:terminflow/data/models/ssh_tab_entity.dart';
import 'package:terminflow/screens/public/card_x.dart';

class SSHTabBarItem {
  const SSHTabBarItem(this.name, this.widget);

  final String name;
  final Widget widget;
}

class SSHTabBar extends ConsumerStatefulWidget {
  final List<SSHTab> tabs;
  const SSHTabBar({super.key, required this.tabs});

  @override
  ConsumerState<SSHTabBar> createState() => _SSHTabBarState();
}

class _SSHTabBarState extends ConsumerState<SSHTabBar>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  // 获取可见标签对应的原始索引
  List<int> _getVisibleToOriginalIndices() {
    return widget.tabs
        .asMap()
        .entries
        .where((entry) => !entry.value.isHidden.value)
        .map((entry) => entry.key)
        .toList();
  }

  void _handleTabClose(SSHTab tab) {
    final originalIndices = _getVisibleToOriginalIndices();
    final closingTabIndex = widget.tabs.indexWhere((t) => t.id == tab.id);
    final visibleIndex = originalIndices.indexOf(closingTabIndex);
    final isClosingCurrent =
        originalIndices[_currentIndex.value] == closingTabIndex;

    // 计算新的可见索引
    int newVisibleIndex = _currentIndex.value;
    if (isClosingCurrent) {
      if (visibleIndex == originalIndices.length - 1) {
        newVisibleIndex = visibleIndex - 1;
      } else {
        newVisibleIndex = visibleIndex;
      }
    } else if (visibleIndex < _currentIndex.value) {
      newVisibleIndex = _currentIndex.value - 1;
    }

    // 隐藏标签
    ref.read(sshTabsProvider.notifier).hideTab(tab.id);

    // 更新索引
    _currentIndex.value = newVisibleIndex;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final visibleTabs =
        widget.tabs.where((tab) => !tab.isHidden.value).toList();
    final originalIndices = _getVisibleToOriginalIndices();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CardX(
            child: ValueListenableBuilder<int>(
              valueListenable: _currentIndex,
              builder: (context, currentIndex, _) {
                return CustomTabBar(
                  currentIndex: currentIndex,
                  tabs: visibleTabs,
                  onTap: (index) {
                    _currentIndex.value = index;
                  },
                  onClose: _handleTabClose,
                );
              },
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _currentIndex,
        builder: (context, currentIndex, _) {
          return IndexedStack(
            index: originalIndices[currentIndex], // 使用映射后的原始索引
            children: widget.tabs.map((tab) {
              return KeyedSubtree(
                key: ValueKey(tab.id),
                child: tab.terminal ?? const SizedBox(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
    required this.onClose,
  });

  final int currentIndex;
  final List<SSHTab> tabs;
  final void Function(int index) onTap;
  final void Function(SSHTab tab) onClose;

  static const kWideWidth = 90.0;
  static const kNarrowWidth = 60.0;

  Color _getStatusColor(int idx) {
    switch (idx) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      itemCount: tabs.length,
      itemBuilder: (_, idx) => _buildItem(idx),
      separatorBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Theme.of(context).dividerColor.withAlpha(50),
          ),
          width: 4,
        ),
      ),
    );
  }

  Widget _buildItem(int idx) {
    final item = tabs[idx];
    final selected = currentIndex == idx;
    final color = selected ? null : Colors.grey;

    final Widget child;
    if (idx == 0) {
      child = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Icon(Icons.home, size: 17, color: color),
      );
    } else {
      final text = Text(
        item.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color),
        softWrap: false,
        textAlign: TextAlign.right,
        textWidthBasis: TextWidthBasis.parent,
      );
      final Widget btn;
      if (selected) {
        btn = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.close, color: color, size: 17),
              onPressed: () => onClose(item),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            SizedBox(width: kNarrowWidth - 15, child: text),
          ],
        );
      } else {
        btn = ValueListenableBuilder<int>(
          valueListenable: item.connectionState,
          builder: (_, status, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                text,
                Container(
                  height: 2,
                  color: _getStatusColor(status),
                )
              ],
            );
          },
        );
      }
      child = AnimatedContainer(
        width: selected ? kWideWidth : kNarrowWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastEaseInToSlowEaseOut,
        child: OverflowBox(
          maxWidth: selected ? kWideWidth : null,
          child: btn,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () => onTap(idx),
        child: GestureDetector(
          onTertiaryTapUp: (details) {
            if (idx > 0 && idx < tabs.length) {
              onClose(tabs[idx]);
            }
          },
          child: child,
        ),
      ),
    );
  }
}
