import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:terminflow/core/database/database.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';
import 'package:terminflow/screens/public/card_x.dart';
import 'package:terminflow/screens/public/input_x.dart';

import 'private_key_select.dart';

class SSHInformationCard extends StatefulWidget {
  final TextEditingController portController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final ValueNotifier<int?> usePrivateKey;
  final ValueNotifier<PrivateKey?> privateKeyInfo;
  const SSHInformationCard({
    super.key,
    required this.portController,
    required this.usernameController,
    required this.passwordController,
    required this.usePrivateKey,
    required this.privateKeyInfo,
  });

  @override
  State<SSHInformationCard> createState() => _SSHInformationCardState();
}

class _SSHInformationCardState extends State<SSHInformationCard> {
  void _openSelectKeyDialog() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                child: PrivateKeySelect(widget.privateKeyInfo)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            'SSH',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        InputX(
          controller: widget.portController,
          type: TextInputType.number,
          label: AppLocalizations.of(context)?.port ?? 'Port',
          icon: Bootstrap.number_123,
          obscureText: false,
          autoCorrect: true,
          suggestion: true,
        ),
        InputX(
          controller: widget.usernameController,
          type: TextInputType.text,
          label: AppLocalizations.of(context)?.username ?? 'Username',
          icon: Bootstrap.person,
          obscureText: false,
          autoCorrect: true,
          suggestion: true,
        ),
        ListTile(
          title: Text(
              AppLocalizations.of(context)?.usePrivateKey ?? 'Use Private Key'),
          trailing: ListenableBuilder(
            listenable: widget.usePrivateKey,
            builder: (_, __) => Switch(
              value: widget.usePrivateKey.value != null,
              onChanged: (val) {
                if (val) {
                  widget.usePrivateKey.value = -1;
                } else {
                  widget.usePrivateKey.value = null;
                }
              },
            ),
          ),
        ),
        ValueListenableBuilder<int?>(
          valueListenable: widget.usePrivateKey,
          builder: (_, idx, __) {
            return AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: idx != null
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: CardX(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.vpn_key,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withAlpha(200)),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SelectPrivateKeyButton(
                          privateKeyInfo: widget.privateKeyInfo,
                          openSelectKeyDialog: _openSelectKeyDialog,
                        ),
                      )
                    ],
                  ),
                )),
                secondChild: InputX(
                  controller: widget.passwordController,
                  obscureText: true,
                  type: TextInputType.text,
                  label: AppLocalizations.of(context)?.password ?? 'Password',
                  icon: Icons.password,
                  hint: "",
                  suggestion: false,
                ));
          },
        ),
      ],
    );
  }
}

class SelectPrivateKeyButton extends StatelessWidget {
  final ValueNotifier<PrivateKey?> privateKeyInfo;
  final dynamic openSelectKeyDialog;
  const SelectPrivateKeyButton(
      {super.key, required this.privateKeyInfo, this.openSelectKeyDialog});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => openSelectKeyDialog(),
      child: ValueListenableBuilder(
        valueListenable: privateKeyInfo,
        builder: (context, value, child) => AnimatedCrossFade(
          firstChild: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(16),
            color:
                Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(200),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  AppLocalizations.of(context)?.selectPrivateKey ??
                      'Select Private Key',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withAlpha(200),
                  ),
                ),
              ),
            ),
          ),
          secondChild: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withAlpha(200),
              ),
            ),
            child: Center(
              child: Text(
                value?.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withAlpha(200),
                ),
              ),
            ),
          ),
          crossFadeState: value == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
