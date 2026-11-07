import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

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
    _NavItem('Riwayat', Icons.receipt_long_outlined),
    _NavItem('Favorit', Icons.favorite_border),
    _NavItem('Profil', Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120B1B3A),
            blurRadius: 24,
            offset: Offset(0, 6),
          ),
        ],
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
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: i == selectedIndex
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _items[i].icon,
                            size: 22,
                            color: i == selectedIndex
                                ? Colors.white
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
                                  ? Colors.white
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
