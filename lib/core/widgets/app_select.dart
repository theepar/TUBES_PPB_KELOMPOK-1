import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

MenuStyle _panelStyle(double width) => MenuStyle(
  backgroundColor: const WidgetStatePropertyAll(Colors.white),
  surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
  shadowColor: const WidgetStatePropertyAll(Colors.transparent),
  elevation: const WidgetStatePropertyAll(0),
  padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
  minimumSize: WidgetStatePropertyAll(Size(width, 0)),
  maximumSize: WidgetStatePropertyAll(Size(width, 360)),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  side: const WidgetStatePropertyAll(BorderSide(color: AppColors.track)),
);

ButtonStyle _itemStyle({bool selected = false}) => ButtonStyle(
  minimumSize: const WidgetStatePropertyAll(Size(0, 52)),
  padding: const WidgetStatePropertyAll(
    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  backgroundColor: WidgetStateProperty.resolveWith(
    (states) =>
        selected ||
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)
        ? AppColors.background
        : Colors.white,
  ),
  overlayColor: const WidgetStatePropertyAll(Colors.transparent),
);

class AppSelectField extends StatefulWidget {
  final String label, value;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;
  const AppSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });
  @override
  State<AppSelectField> createState() => _AppSelectFieldState();
}

class _AppSelectFieldState extends State<AppSelectField> {
  bool _open = false;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => MenuAnchor(
      style: _panelStyle(constraints.maxWidth.clamp(0, 480).toDouble()),
      reservedPadding: const EdgeInsets.all(20),
      alignmentOffset: const Offset(0, 8),
      onOpen: () => setState(() => _open = true),
      onClose: () => setState(() => _open = false),
      menuChildren: [
        for (final option in widget.options.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: MenuItemButton(
              style: _itemStyle(selected: widget.value == option.key),
              onPressed: () => widget.onChanged(option.key),
              trailingIcon: widget.value == option.key
                  ? const Icon(
                      Icons.check_rounded,
                      size: 20,
                      color: AppColors.primary,
                    )
                  : null,
              child: Text(option.value),
            ),
          ),
      ],
      builder: (context, controller, child) => Semantics(
        button: true,
        label: widget.label,
        value: widget.options[widget.value],
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () =>
              controller.isOpen ? controller.close() : controller.open(),
          child: InputDecorator(
            isFocused: _open,
            decoration: InputDecoration(labelText: widget.label),
            child: Row(
              children: [
                Expanded(child: Text(widget.options[widget.value] ?? 'Pilih')),
                Icon(
                  _open
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.inkSoft,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class AppActionMenu extends StatelessWidget {
  final Map<String, String> options;
  final ValueChanged<String> onSelected;
  const AppActionMenu({
    super.key,
    required this.options,
    required this.onSelected,
  });
  @override
  Widget build(BuildContext context) => MenuAnchor(
    style: _panelStyle(228),
    alignmentOffset: const Offset(0, 8),
    reservedPadding: const EdgeInsets.all(20),
    menuChildren: [
      for (final item in options.entries)
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: MenuItemButton(
            style: _itemStyle(),
            leadingIcon: Icon(
              item.key == 'hapus'
                  ? Icons.delete_outline_rounded
                  : Icons.edit_outlined,
              size: 20,
            ),
            onPressed: () => onSelected(item.key),
            child: Text(item.value),
          ),
        ),
    ],
    builder: (context, controller, child) => IconButton(
      tooltip: 'Opsi lainnya',
      onPressed: () =>
          controller.isOpen ? controller.close() : controller.open(),
      icon: const Icon(Icons.more_horiz_rounded, color: AppColors.inkSoft),
    ),
  );
}
