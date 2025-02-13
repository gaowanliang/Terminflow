import 'package:flutter/material.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';

class JumpServerCard extends StatelessWidget {
  const JumpServerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)?.jumpServer ?? '跳板机',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              FilterChip(
                label: const Text('Server 1'),
                onSelected: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
