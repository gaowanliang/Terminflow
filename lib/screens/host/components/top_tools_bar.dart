import 'package:flutter/material.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';

class TopToolsBar extends StatelessWidget {
  const TopToolsBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: HostsGroupDropdownMenu(),
        ),
        const SizedBox(width: 16),
        // 搜索
        Expanded(
          flex: 6,
          child: TextField(
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)?.search ?? 'Search',
              prefixIcon: const Icon(Icons.search),
              // 无边框
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              // 背景色
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}

class HostsGroupDropdownMenu extends StatelessWidget {
  const HostsGroupDropdownMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: MediaQuery.of(context).size.width * 0.5,
      label: Text(
        AppLocalizations.of(context)?.group ?? 'Group',
      ),
      dropdownMenuEntries: [
        DropdownMenuEntry(
            value: "all",
            label: AppLocalizations.of(context)?.allHosts ?? 'All Hosts'),
      ],
    );
  }
}
