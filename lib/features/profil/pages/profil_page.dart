import '../../../app/app_route.dart';

import 'package:flutter/material.dart';

import '../../../core/models/pengguna.dart';
import '../../../core/data/demo_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/danger_button.dart';
import '../../../core/widgets/demo_ui.dart';
import '../../order/pages/riwayat_order_page.dart';
import '../../favorit/pages/favorit_page.dart';
import '../../jasa/pages/jasa_saya_page.dart';
import 'daftar_penyedia_page.dart';

class ProfilPage extends StatelessWidget {
  final Pengguna pengguna;
  const ProfilPage({super.key, required this.pengguna});

  Future<void> _edit(BuildContext context, Pengguna user) async {
    var nama = user.nama;
    var lokasi = user.lokasi;
    final form = GlobalKey<FormState>();
    await showDialog<void>(
      animationStyle: AnimationStyle.noAnimation,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        constraints: const BoxConstraints(maxWidth: 560),
        titlePadding: const EdgeInsets.fromLTRB(28, 28, 28, 8),
        contentPadding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
        actionsPadding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
        title: const Text('Edit profil'),
        content: SizedBox(
          width: 504,
          child: SingleChildScrollView(
            child: Form(
              key: form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: nama,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    onChanged: (v) => nama = v,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Nama wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: lokasi,
                    decoration: const InputDecoration(labelText: 'Lokasi'),
                    onChanged: (v) => lokasi = v,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Lokasi wajib diisi'
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    if (form.currentState!.validate()) {
                      DemoStore.instance.editProfil(
                        nama,
                        lokasi,
                        user.warnaAvatar,
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text(
                    'Simpan profil',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _tentang(BuildContext context) {
    showDialog<void>(
      animationStyle: AnimationStyle.noAnimation,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        title: const Text('Tentang SewaSkill'),
        content: const SizedBox(
          width: 480,
          child: Text(
            'SewaSkill menghubungkan pencari jasa dengan talent untuk berbagai kebutuhan digital, mulai dari desain, video, penulisan, hingga belajar koding.\n\nTemukan jasa sesuai kebutuhanmu, pilih paket layanan, dan pantau proses pengerjaannya dalam satu aplikasi.',
            style: TextStyle(height: 1.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final user = store.pengguna ?? pengguna;
        return Scaffold(
          appBar: AppBar(title: const Text('Profil')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Color(user.warnaAvatar),
                        foregroundColor: Colors.white,
                        child: Text(
                          user.nama[0],
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.nama,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(user.email),
                      Text(user.lokasi),
                      const SizedBox(height: 8),
                      Text('Role: ${user.role}'),
                      const Divider(height: 32),
                      const Text('Saldo demo'),
                      Text(
                        'Rp ${user.saldo}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _edit(context, user),
                          child: const Text('Edit profil'),
                        ),
                      ),
                      if (store.isPenyedia) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              AppRoute(builder: (_) => const JasaSayaPage()),
                            ),
                            icon: const Icon(Icons.work_outline_rounded),
                            label: const Text('Jasa saya'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (store.isPencari) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Punya keahlian untuk ditawarkan?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Daftar menjadi penyedia dan mulai tawarkan jasamu di SewaSkill.',
                          style: TextStyle(
                            color: AppColors.inkSoft,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            AppRoute(
                              builder: (_) => const DaftarPenyediaPage(),
                            ),
                          ),
                          icon: const Icon(Icons.work_outline_rounded),
                          label: const Text('Daftar menjadi penyedia'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.receipt_long_outlined),
                      title: const Text('Pesanan saya'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        AppRoute(builder: (_) => const RiwayatOrderPage()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.favorite_border),
                      title: const Text('Jasa tersimpan'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        AppRoute(builder: (_) => const FavoritPage()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Tentang SewaSkill'),
                      onTap: () => _tentang(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  if (await konfirmasi(
                    context,
                    'Keluar dari akun?',
                    'Data demo tetap ada selama aplikasi belum dimulai ulang.',
                    aksi: 'Keluar',
                  )) {
                    store.logout();
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
              const SizedBox(height: 12),
              DangerButton(
                onPressed: () async {
                  if (await konfirmasi(
                        context,
                        'Hapus akun?',
                        'Akun, jasa, ulasan, dan favoritmu akan dihapus permanen. Riwayat pesanan tetap tersimpan.',
                        aksi: 'Hapus',
                      ) &&
                      context.mounted) {
                    jalankanAksi(context, store.hapusAkunSendiri);
                  }
                },
                icon: Icons.delete_outline_rounded,
                label: 'Hapus akun',
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
