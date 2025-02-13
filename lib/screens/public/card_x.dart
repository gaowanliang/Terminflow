import 'package:flutter/material.dart';

class CardX extends StatelessWidget {
  final Widget child;
  final Color? color;
  final BorderRadius? radius;

  const CardX({super.key, required this.child, this.color, this.radius});

  static const borderRadius = BorderRadius.all(Radius.circular(13));

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      clipBehavior: Clip.antiAlias,
      color: color ?? Theme.of(context).colorScheme.primaryContainer.withAlpha(60),
      shape: RoundedRectangleBorder(
        borderRadius: radius ?? borderRadius,
      ),
      elevation: 0,
      child: child,
    );
  }
}
