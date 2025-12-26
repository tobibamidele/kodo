import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kodo/utils/theme/border_theme.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final VoidCallback onSubmitted;
  final Function(String) onChanged;
  final double borderRadius;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final EdgeInsetsGeometry contentPadding;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;
  final Size? size;
  final bool expands;
  final int? minLines;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool obscureText;

  const InputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.onSubmitted,
    required this.onChanged,
    this.labelStyle,
    this.floatingLabelStyle,
    this.textInputAction,
    this.borderRadius = 16,
    this.textInputType = TextInputType.text,
    this.inputFormatters = const [],
    this.contentPadding = const EdgeInsets.only(
      left: 16,
      bottom: 8,
      top: 8,
      right: 8,
    ),
    this.enabledBorder,
    this.minLines,
    this.maxLines,
    this.focusedBorder,
    this.size,
    this.suffixIcon,
    this.expands = false,
    this.obscureText = false,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;

    final defaultFocusedBorder = (brightness == Brightness.light)
        ? KodoBorderTheme.lightOutlineInputBorderTheme
        : KodoBorderTheme.darkOutlineInputBorderTheme;

    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      expands: widget.expands,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      onSubmitted: (_) => widget.onSubmitted(),
      onChanged: (value) => widget.onChanged(value),
      keyboardType: widget.textInputType,
      obscureText: widget.obscureText,
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(width: 2),
        ),
        hintText: widget.labelText,
        filled: true,
        //       fillColor: Theme.of(context).cardTheme.color,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        focusedBorder: widget.focusedBorder ?? defaultFocusedBorder,
        contentPadding: widget.contentPadding,
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
