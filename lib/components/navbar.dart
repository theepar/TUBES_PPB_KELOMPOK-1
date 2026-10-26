import 'package:flutter/material.dart';

import '../animations/animasi.dart';
import '../utils/app_colors.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback? onAddTap;

  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.onAddTap,
  });

  static const _items = [
    _NavItem('Beranda', Icons.home_rounded),
    _NavItem('Katalog', Icons.search_rounded),
    _NavItem('Order', Icons.receipt_long_rounded),
  ];

  static const _tambah = _NavItem('Tambah', Icons.add_circle_outline_rounded);

  @override
  Widget build(BuildContext context) {
    final jumlah = _items.length + (onAddTap != null ? 1 : 0);

    return Container(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
          child: Container(
            height: 64,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A1E3A6B),
                  blurRadius: 20,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final lebarSlot = constraints.maxWidth / jumlah;

                return Stack(
                  children: [
                    SlidingIndicator(
                      index: selectedIndex,
                      lebarSlot: lebarSlot,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < _items.length; i++)
                          Expanded(
                            child: _NavButton(
                              item: _items[i],
                              selected: i == selectedIndex,
                              onTap: () => onDestinationSelected(i),
                            ),
                          ),
                        if (onAddTap != null)
                          Expanded(
                            child: _NavButton(
                              item: _tambah,
                              selected: false,
                              onTap: onAddTap!,
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedTint(
            aktif: selected,
            warnaAktif: Colors.white,
            warnaNonaktif: AppColors.inkSoft,
            builder: (context, color) => Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.icon, size: 22, color: color),
                      const SizedBox(width: 4),
                      Text(
                        item.label,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;

  const _NavItem(this.label, this.icon);
}
