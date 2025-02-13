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
  int _currentIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CardX(
            child: CustomTabBar(
              currentIndex: _currentIndex,
              tabs: widget.tabs,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              onClose: (tab) {
                ref.read(sshTabsProvider.notifier).removeTab(tab.id);
                if (_currentIndex >= widget.tabs.length) {
                  _currentIndex = widget.tabs.length - 1;
                }
              },
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children:
            widget.tabs.map((tab) => tab.terminal ?? const SizedBox()).toList(),
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
        btn = Center(child: text);
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
        child: child,
      ),
    );
  }
}
