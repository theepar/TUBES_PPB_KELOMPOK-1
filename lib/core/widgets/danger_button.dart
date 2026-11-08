import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Outlined button for destructive actions. Red border and label when
/// enabled, softened red when disabled.
class DangerButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;

  const DangerButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  static const _disabled = Color(0x61B3261E);
  static const _disabledBorder = Color(0x3DB3261E);

  @override
  Widget build(BuildContext context) {
    final style =
        OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          disabledForegroundColor: _disabled,
        ).copyWith(
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return const BorderSide(color: _disabledBorder);
            }
            if (states.contains(WidgetState.focused)) {
              return const BorderSide(color: AppColors.danger, width: 2);
            }
            return const BorderSide(color: AppColors.danger);
          }),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.focused)) {
              return AppColors.danger.withValues(alpha: 0.12);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppColors.danger.withValues(alpha: 0.08);
            }
            return null;
          }),
        );
    return icon == null
        ? OutlinedButton(style: style, onPressed: onPressed, child: Text(label))
        : OutlinedButton.icon(
            style: style,
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
          );
  }
}
