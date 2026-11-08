import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'admin_dashboard_page.dart';
import 'admin_akun_page.dart';
import 'admin_postingan_page.dart';
import 'admin_keamanan_page.dart';

class AdminShellPage extends StatefulWidget {
  const AdminShellPage({super.key});
  @override
  State<AdminShellPage> createState() => _AdminShellPageState();
}

class _AdminShellPageState extends State<AdminShellPage> {
  int _index = 0;
  void _pilih(int index) => setState(() => _index = index);
  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: _index,
      children: [
        AdminDashboardPage(
          onAkun: () => _pilih(1),
          onPostingan: () => _pilih(2),
          onKeamanan: () => _pilih(3),
        ),
        const AdminAkunPage(),
        const AdminPostinganPage(),
        const AdminKeamananPage(),
      ],
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _pilih,
            backgroundColor: Colors.white,
            indicatorColor: AppColors.primary.withValues(alpha: 0.12),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Ringkasan',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: 'Akun',
              ),
              NavigationDestination(
                icon: Icon(Icons.article_outlined),
                selectedIcon: Icon(Icons.article),
                label: 'Postingan',
              ),
              NavigationDestination(
                icon: Icon(Icons.shield_outlined),
                selectedIcon: Icon(Icons.shield),
                label: 'Keamanan',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
