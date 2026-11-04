import 'package:flutter/material.dart';

import '../services/app_session.dart';
import '../utils/app_colors.dart';

class NavTujuan {
  final String label;
  final IconData icon;

  const NavTujuan(this.label, this.icon);
}

/// Navbar bawah dengan dua mode. Mode dibaca dari `AppSession.isAdminMode`:
/// 5 tab untuk pengguna biasa, 3 tab untuk Mode Admin.
class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  static const tujuanBiasa = [
    NavTujuan('Beranda', Icons.home_rounded),
    NavTujuan('Katalog', Icons.search_rounded),
    NavTujuan('Riwayat', Icons.receipt_long_rounded),
    NavTujuan('Favorit', Icons.favorite_border_rounded),
    NavTujuan('Profil', Icons.person_outline_rounded),
  ];

  static const tujuanAdmin = [
    NavTujuan('Pembelian', Icons.payments_outlined),
    NavTujuan('Akun', Icons.manage_accounts_outlined),
    NavTujuan('Profil', Icons.person_outline_rounded),
  ];

  static List<NavTujuan> tujuanUntuk(bool modeAdmin) =>
      modeAdmin ? tujuanAdmin : tujuanBiasa;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppSession.instance,
      builder: (context, _) {
        final items = tujuanUntuk(AppSession.instance.isAdminMode);
        final aktif = selectedIndex < items.length ? selectedIndex : 0;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.track)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  for (int i = 0; i < items.length; i++)
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
                                items[i].icon,
                                size: 22,
                                color: i == aktif
                                    ? AppColors.primary
                                    : AppColors.inkSoft,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                items[i].label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: i == aktif
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: i == aktif
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
      },
    );
  }
}
