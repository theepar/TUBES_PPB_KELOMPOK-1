import 'package:flutter/material.dart';

import '../../../app/app_route.dart';
import '../../../core/data/demo_store.dart';
import '../../../core/data/talent_data.dart';
import '../../../core/theme/app_colors.dart';
import 'admin_pembelian_page.dart';

class AdminDashboardPage extends StatelessWidget {
  final VoidCallback onAkun, onPostingan, onKeamanan;
  const AdminDashboardPage({
    super.key,
    required this.onAkun,
    required this.onPostingan,
    required this.onKeamanan,
  });
  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Admin')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final pending = store.orders
              .where((o) => o.status == 'menunggu_admin')
              .length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              const Text(
                'Kelola SewaSkill',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Akun, postingan, dan aktivitas keamanan dalam satu tempat.',
                style: const TextStyle(color: AppColors.inkSoft, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _stat('${store.users.length}', 'Akun terdaftar'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _stat(
                      '${daftarTalent.where((t) => t.tampil).length}',
                      'Postingan aktif',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _menu(
                Icons.people_outline,
                'Manajemen akun',
                'Cari akun, ubah role, blokir, atau aktifkan kembali.',
                onAkun,
              ),
              _menu(
                Icons.article_outlined,
                'Moderasi postingan',
                'Tinjau jasa dan atur postingan yang ditampilkan.',
                onPostingan,
              ),
              _menu(
                Icons.shield_outlined,
                'Keamanan',
                'Lihat akun diblokir dan aktivitas pengelolaan.',
                onKeamanan,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Perlu ditinjau',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('$pending pesanan menunggu persetujuan admin.'),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          AppRoute(builder: (_) => const AdminPembelianPage()),
                        ),
                        child: const Text('Tinjau pesanan'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _stat(String value, String label) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: AppColors.inkSoft)),
        ],
      ),
    ),
  );
  Widget _menu(
    IconData icon,
    String title,
    String text,
    VoidCallback onTap,
  ) => Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(text),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}
