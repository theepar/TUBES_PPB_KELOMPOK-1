import 'package:flutter/material.dart';

import '../../../core/data/demo_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/demo_ui.dart';

class AdminKeamananPage extends StatelessWidget {
  const AdminKeamananPage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Keamanan')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.admin_panel_settings_outlined,
                      color: AppColors.primary,
                      size: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      store.pengguna?.nama ?? 'Admin',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      store.pengguna?.email ?? '',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '${store.users.where((u) => u.status == 'diblokir').length} akun diblokir',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Akun admin dilindungi dari perubahan role dan pemblokiran.',
                      style: TextStyle(color: AppColors.inkSoft, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Aktivitas sesi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Catatan perubahan pada data contoh di sesi aplikasi ini.',
              style: TextStyle(color: AppColors.inkSoft),
            ),
            const SizedBox(height: 16),
            for (final log in store.aktivitasKeamanan)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(20),
                  leading: const Icon(Icons.history),
                  title: Text(
                    log,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () async {
                if (await konfirmasi(
                  context,
                  'Keluar dari akun admin?',
                  'Sesi admin akan ditutup.',
                  aksi: 'Keluar',
                )) {
                  store.logout();
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
