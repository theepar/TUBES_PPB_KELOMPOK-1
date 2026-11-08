import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ChoicePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    child: FilledButton(
      style:
          FilledButton.styleFrom(
            backgroundColor: selected ? AppColors.primary : Colors.white,
            foregroundColor: selected ? Colors.white : AppColors.ink,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ).copyWith(
            elevation: const WidgetStatePropertyAll(0),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            side: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.focused)
                  ? const BorderSide(color: AppColors.inkSoft)
                  : BorderSide.none,
            ),
          ),
      onPressed: onPressed,
      child: Text(label),
    ),
  );
}
