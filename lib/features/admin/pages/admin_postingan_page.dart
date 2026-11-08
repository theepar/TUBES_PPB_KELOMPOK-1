import 'package:flutter/material.dart';

import '../../../core/data/demo_store.dart';
import '../../../core/data/talent_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/danger_button.dart';
import '../../../core/widgets/demo_ui.dart';

class AdminPostinganPage extends StatefulWidget {
  const AdminPostinganPage({super.key});
  @override
  State<AdminPostinganPage> createState() => _AdminPostinganPageState();
}

class _AdminPostinganPageState extends State<AdminPostinganPage> {
  String _query = '';
  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Postingan')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          if (!store.isAdmin) {
            return const Center(child: Text('Halaman khusus admin'));
          }
          final list = daftarTalent
              .where(
                (t) => '${t.nama} ${t.bidang} ${t.lokasi}'
                    .toLowerCase()
                    .contains(_query.toLowerCase()),
              )
              .toList();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Cari postingan',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 20),
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Postingan tidak ditemukan'),
                ),
              for (final talent in list)
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          talent.bidang,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${talent.nama} | ${talent.lokasi}',
                          style: const TextStyle(color: AppColors.inkSoft),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          talent.tampil
                              ? 'Ditampilkan di katalog'
                              : 'Disembunyikan dari katalog',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          talent.deskripsi,
                          style: const TextStyle(height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            OutlinedButton(
                              onPressed: () => jalankanAksi(
                                context,
                                () => store.moderasiJasa(talent),
                              ),
                              child: Text(
                                talent.tampil ? 'Sembunyikan' : 'Tampilkan',
                              ),
                            ),
                            DangerButton(
                              onPressed: () async {
                                if (await konfirmasi(
                                      context,
                                      'Hapus postingan?',
                                      'Jasa beserta favorit dan ulasannya akan dihapus. Riwayat pesanan tetap tersimpan.',
                                      aksi: 'Hapus',
                                    ) &&
                                    context.mounted) {
                                  jalankanAksi(
                                    context,
                                    () =>
                                        store.moderasiJasa(talent, hapus: true),
                                  );
                                }
                              },
                              label: 'Hapus postingan',
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
