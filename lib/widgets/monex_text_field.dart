import 'package:flutter/material.dart';

class MonexTextField extends StatefulWidget {
  const MonexTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.controller,
  });

  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;

  @override
  State<MonexTextField> createState() => _MonexTextFieldState();
}

class _MonexTextFieldState extends State<MonexTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final outline = colorScheme.outlineVariant;
    final surfaceVariant = colorScheme.surfaceContainerHighest;
    final bool isDark = theme.brightness == Brightness.dark;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: outline),
    );

    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword ? _obscure : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(widget.icon, color: colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: isDark
            ? surfaceVariant.withOpacity(0.35)
            : surfaceVariant.withOpacity(0.9),
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}
