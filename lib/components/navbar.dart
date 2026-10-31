import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  static const _items = [
    _NavItem('Beranda', Icons.home_rounded),
    _NavItem('Katalog', Icons.search_rounded),
    _NavItem('Order', Icons.receipt_long_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.track)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              for (int i = 0; i < _items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onDestinationSelected(i),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _items[i].icon,
                            size: 22,
                            color: i == selectedIndex
                                ? AppColors.primary
                                : AppColors.inkSoft,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _items[i].label,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: i == selectedIndex
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: i == selectedIndex
                                  ? AppColors.primary
                                  : AppColors.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
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
