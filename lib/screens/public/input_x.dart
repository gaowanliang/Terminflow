import 'package:flutter/material.dart';

import 'card_x.dart';

/// Value notifier extensions
extension ValueListenX<T> on ValueNotifier<T> {
  /// Listens to value changes and rebuilds using builder
  Widget listenVal(Widget Function(T value) builder) {
    return ValueListenableBuilder<T>(
      valueListenable: this,
      builder: (_, value, __) => builder(value),
    );
  }
}

/// Value notifier extensions
extension ValueNotifierX<T> on T {
  /// Creates a [ValueNotifier] with the current value
  ValueNotifier<T> get vn => ValueNotifier<T>(this);
}

class InputX extends StatefulWidget {
  final TextEditingController? controller;

  /// Default is `1`.
  final int maxLines;
  final int? minLines;
  final String? hint;
  final String? label;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;

  /// {@template concurrent_obscure_suffix}
  /// Can't use both [obscureText] and [suffix] at the same time.
  /// {@endtemplate}
  final bool obscureText;

  /// {@macro concurrent_obscure_suffix}
  final Widget? suffix;

  /// The leading icon of the input.
  final IconData? icon;
  final TextInputType? type;
  final TextInputAction? action;
  final FocusNode? node;

  /// Default is `false`.
  final bool autoCorrect;

  /// By default, it uses the value of [PrefProps.imeSuggestions] or `true`.
  final bool? suggestion;

  /// Works on [TextField.decoration]
  final String? errorText;

  /// Default is `false`.
  final bool autoFocus;
  final void Function(bool)? onViewPwdTap;

  /// If true, the input will not be wrapped in a [Card] and [Padding].
  ///
  /// Default is `false`.
  final bool noWrap;
  final InputCounterWidgetBuilder? counterBuilder;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;

  /// If null, it uses the [AdaptiveTextSelectionToolbar.editableText].
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final int? maxLength;
  final Color? backgroundColor;

  const InputX({
    super.key,
    this.controller,
    this.maxLines = 1,
    this.minLines,
    this.hint,
    this.label,
    this.onSubmitted,
    this.onChanged,
    this.obscureText = false,
    this.icon,
    this.type,
    this.action,
    this.node,
    this.autoCorrect = false,
    this.suggestion,
    this.errorText,
    this.autoFocus = false,
    this.onViewPwdTap,
    this.noWrap = false,
    this.suffix,
    this.counterBuilder,
    this.onTap,
    this.onTapOutside,
    this.contextMenuBuilder,
    this.maxLength,
    this.backgroundColor,
  }) : assert(
          !(obscureText && suffix != null),
          'suffix != null && obscureText',
        );

  @override
  State<StatefulWidget> createState() => _InputXState();
}

class _InputXState extends State<InputX> {
  late final _obscureText = widget.obscureText.vn;

  @override
  Widget build(BuildContext context) {
    final icon = widget.icon != null ? Icon(widget.icon) : null;
    final child = _buildField(icon);

    if (widget.noWrap) return child;

    return CardX(
      color: widget.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
        child: child,
      ),
    );
  }

  Widget _buildField(Widget? icon) {
    return _obscureText.listenVal((obscureText) {
      return TextField(
        controller: widget.controller,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,
          errorText: widget.errorText,
          border: InputBorder.none,
          icon: icon,
          suffixIcon: _buildSuffix(obscureText),
        ),
        keyboardType: widget.type,
        textInputAction: widget.action,
        focusNode: widget.node,
        autocorrect: widget.autoCorrect,
        enableSuggestions: widget.suggestion ?? true,
        autofocus: widget.autoFocus,
        onSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        buildCounter: widget.counterBuilder,
        onTap: widget.onTap,
        onTapOutside: widget.onTapOutside,
        maxLength: widget.maxLength,
        contextMenuBuilder: widget.contextMenuBuilder ?? _ctxMenuBuilder,
      );
    });
  }

  Widget? _buildSuffix(bool obscureText) {
    if (widget.suffix != null) return widget.suffix!;
    if (!widget.obscureText) return null;

    return IconButton(
      icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
      onPressed: () {
        _obscureText.value = !obscureText;
        widget.onViewPwdTap?.call(obscureText);
      },
    );
  }

  Widget _ctxMenuBuilder(BuildContext context, EditableTextState state) =>
      AdaptiveTextSelectionToolbar.editableText(editableTextState: state);
}
