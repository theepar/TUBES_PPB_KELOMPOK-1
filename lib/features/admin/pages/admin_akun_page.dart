import 'package:flutter/material.dart';

import '../../../app/app_route.dart';
import '../../../core/data/demo_store.dart';
import '../../../core/models/pengguna.dart';
import '../../../core/widgets/danger_button.dart';
import '../../../core/widgets/demo_ui.dart';
import '../../../core/theme/app_colors.dart';
import 'admin_form_akun_page.dart';

class AdminAkunPage extends StatefulWidget {
  const AdminAkunPage({super.key});
  @override
  State<AdminAkunPage> createState() => _AdminAkunPageState();
}

class _AdminAkunPageState extends State<AdminAkunPage> {
  String _cari = '';
  Future<void> _detail(Pengguna user) async {
    await showModalBottomSheet<void>(
      sheetAnimationStyle: AnimationStyle.noAnimation,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => ListenableBuilder(
        listenable: DemoStore.instance,
        builder: (context, _) {
          final store = DemoStore.instance;
          final current = store.users.where((u) => u.id == user.id).firstOrNull;
          if (current == null) return const SizedBox.shrink();
          final bisaUbah =
              current.id != store.pengguna?.id && current.role != 'admin';
          return Padding(
            padding: EdgeInsets.fromLTRB(
              28,
              28,
              28,
              MediaQuery.viewInsetsOf(context).bottom +
                  MediaQuery.paddingOf(context).bottom +
                  32,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    current.nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(current.email),
                  const SizedBox(height: 8),
                  Text(current.lokasi),
                  const SizedBox(height: 8),
                  Text('Role: ${current.role} | ${current.status}'),
                  const SizedBox(height: 8),
                  Text('Saldo demo: Rp ${current.saldo}'),
                  const SizedBox(height: 32),
                  if (bisaUbah) ...[
                    FilledButton(
                      onPressed: () => Navigator.push(
                        context,
                        AppRoute(
                          builder: (_) => AdminFormAkunPage(akun: current),
                        ),
                      ),
                      child: const Text('Edit data akun'),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () async {
                        final blokir = current.status == 'aktif';
                        if (blokir &&
                            !await konfirmasi(
                              context,
                              'Blokir akun?',
                              'Akun ini tidak akan bisa login selama diblokir.',
                            )) {
                          return;
                        }
                        if (context.mounted) {
                          jalankanAksi(
                            context,
                            () => store.ubahAkun(
                              current,
                              status: blokir ? 'diblokir' : 'aktif',
                            ),
                          );
                        }
                      },
                      child: Text(
                        current.status == 'aktif'
                            ? 'Blokir akun'
                            : 'Aktifkan akun',
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () async {
                        final role = current.role == 'pencari'
                            ? 'penyedia'
                            : 'pencari';
                        if (await konfirmasi(
                              context,
                              'Ubah role?',
                              'Ubah role akun menjadi $role?',
                            ) &&
                            context.mounted) {
                          jalankanAksi(
                            context,
                            () => store.ubahAkun(current, role: role),
                          );
                        }
                      },
                      child: Text(
                        'Ubah ke ${current.role == 'pencari' ? 'penyedia' : 'pencari'}',
                      ),
                    ),
                    const SizedBox(height: 20),
                    DangerButton(
                      onPressed: () async {
                        if (await konfirmasi(
                              context,
                              'Hapus akun?',
                              'Akun, jasa, ulasan, dan favoritnya akan dihapus. Riwayat pesanan tetap tersimpan.',
                              aksi: 'Hapus',
                            ) &&
                            context.mounted) {
                          final berhasil = jalankanAksi(
                            context,
                            () => store.hapusAkun(current),
                          );
                          if (berhasil && context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      icon: Icons.delete_outline_rounded,
                      label: 'Hapus akun',
                    ),
                  ] else
                    const Text('Akun admin tidak dapat diubah.'),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Akun')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          if (!store.isAdmin) {
            return const Center(child: Text('Halaman khusus admin'));
          }
          final users = store.users
              .where((u) => u.nama.toLowerCase().contains(_cari.toLowerCase()))
              .toList();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Cari akun',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _cari = v),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  AppRoute(builder: (_) => const AdminFormAkunPage()),
                ),
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: const Text('Tambah akun'),
              ),
              const SizedBox(height: 20),
              if (users.isEmpty)
                const Center(child: Text('Akun tidak ditemukan')),
              for (final user in users)
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    onTap: () => _detail(user),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Color(user.warnaAvatar),
                      foregroundColor: Colors.white,
                      child: Text(user.nama[0]),
                    ),
                    title: Text(user.nama),
                    subtitle: Text(
                      '${user.role} | ${user.status}',
                      style: const TextStyle(color: AppColors.inkSoft),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
