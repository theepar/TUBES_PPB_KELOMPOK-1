import 'app_route.dart';

import 'package:flutter/material.dart';

import 'widgets/navbar.dart';
import '../core/models/pengguna.dart';
import '../core/theme/app_colors.dart';
import '../features/beranda/pages/beranda_page.dart';
import '../features/katalog/pages/katalog_page.dart';
import '../features/profil/pages/profil_page.dart';
import '../features/jasa/pages/tambah_jasa_page.dart';
import '../features/order/pages/riwayat_order_page.dart';
import '../features/favorit/pages/favorit_page.dart';
import '../core/data/demo_store.dart';

class MainPage extends StatefulWidget {
  final Pengguna pengguna;

  const MainPage({super.key, this.pengguna = penggunaDefault});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _bukaTambahJasa() async {
    await Navigator.push(
      context,
      AppRoute(builder: (_) => const TambahJasaPage()),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    final pengguna = store.pengguna ?? widget.pengguna;
    final pages = <Widget>[
      BerandaPage(pengguna: pengguna, onBukaKatalog: () => _onItemTapped(1)),
      const KatalogPage(),
      const RiwayatOrderPage(),
      const FavoritPage(),
      ProfilPage(pengguna: pengguna),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
      floatingActionButton: store.isPenyedia && _selectedIndex < 2
          ? FloatingActionButton.extended(
              onPressed: _bukaTambahJasa,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              tooltip: 'Tambah Jasa',
              icon: const Icon(Icons.add),
              label: const Text('Tambah jasa'),
            )
          : null,
    );
  }
}
