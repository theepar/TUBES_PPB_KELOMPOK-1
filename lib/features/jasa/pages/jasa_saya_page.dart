import 'package:flutter/material.dart';

import '../../../app/app_route.dart';
import '../../../core/data/demo_store.dart';
import '../../../core/data/talent_data.dart';
import '../../../core/models/talent.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/danger_button.dart';
import '../../../core/widgets/demo_ui.dart';
import 'tambah_jasa_page.dart';

class JasaSayaPage extends StatelessWidget {
  const JasaSayaPage({super.key});
  Future<void> _hapus(BuildContext context, Talent talent) async {
    if (await konfirmasi(
          context,
          'Hapus jasa?',
          'Jasa, ulasan, dan favoritnya akan dihapus. Riwayat pesanan tetap tersimpan.',
          aksi: 'Hapus',
        ) &&
        context.mounted) {
      jalankanAksi(context, () => DemoStore.instance.hapusTalent(talent));
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Jasa saya')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          if (!store.isPenyedia) {
            return const Center(child: Text('Halaman khusus penyedia'));
          }
          final list = daftarTalent
              .where((t) => t.ownerId == store.pengguna?.id)
              .toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Text(
                '${list.length} jasa milikmu',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kelola layanan, pilihan paket, dan harga yang kamu tawarkan.',
                style: TextStyle(color: AppColors.inkSoft, height: 1.5),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  AppRoute(builder: (_) => const TambahJasaPage()),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Tambah jasa'),
              ),
              const SizedBox(height: 24),
              if (list.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(28),
                    child: Column(
                      children: [
                        Icon(
                          Icons.work_outline_rounded,
                          size: 40,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada jasa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tambahkan jasa pertama dan tentukan pilihan layananmu.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              for (final talent in list)
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          talent.bidang,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          talent.lokasi,
                          style: const TextStyle(color: AppColors.inkSoft),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          talent.tampil
                              ? 'Ditampilkan di katalog'
                              : 'Disembunyikan admin',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: talent.tampil
                                ? const Color(0xFF187449)
                                : const Color(0xFF825600),
                          ),
                        ),
                        const Divider(height: 32),
                        for (final paket in talent.paketLayanan)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text(paket.nama)),
                                const SizedBox(width: 16),
                                Text(
                                  'Rp ${paket.harga}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  AppRoute(
                                    builder: (_) =>
                                        TambahJasaPage(talent: talent),
                                  ),
                                ),
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Edit'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DangerButton(
                                onPressed: () => _hapus(context, talent),
                                icon: Icons.delete_outline_rounded,
                                label: 'Hapus',
                              ),
                            ),
                          ],
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
}
