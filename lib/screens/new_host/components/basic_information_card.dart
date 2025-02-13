import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:terminflow/data/l10n/generated/l10n.dart';
import 'package:terminflow/screens/public/input_x.dart';

class BasicInfomationCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController tagController;
  final TextEditingController commentController;

  const BasicInfomationCard({
    super.key,
    required this.nameController,
    required this.addressController,
    required this.tagController,
    required this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            AppLocalizations.of(context)?.basicInfo ?? 'Basic Information',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        InputX(
          autoFocus: true,
          controller: nameController,
          type: TextInputType.text,
          label: "${AppLocalizations.of(context)?.name ?? 'Name'}*",
          icon: BoxIcons.bx_rename,
          obscureText: false,
          autoCorrect: true,
          suggestion: true,
        ),
        InputX(
          controller: addressController,
          type: TextInputType.url,
          label: "${AppLocalizations.of(context)?.address ?? 'Address'}*",
          icon: BoxIcons.bx_world,
          obscureText: false,
          autoCorrect: true,
          suggestion: true,
        ),
        InputX(
          controller: tagController,
          type: TextInputType.text,
          label: AppLocalizations.of(context)?.addTag ?? 'Add Tag',
          icon: BoxIcons.bx_tag,
          obscureText: false,
          autoCorrect: true,
          suggestion: true,
        ),
        InputX(
          controller: commentController,
          type: TextInputType.text,
          label: AppLocalizations.of(context)?.comment ?? 'Comment',
          icon: BoxIcons.bx_message,
          obscureText: false,
          autoCorrect: true,
          suggestion: true,
        ),
      ],
    );
  }
}
