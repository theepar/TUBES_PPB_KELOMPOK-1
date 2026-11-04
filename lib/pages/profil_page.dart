import 'package:flutter/material.dart';

import '../models/pengguna.dart';
import '../utils/app_colors.dart';

class ProfilPage extends StatelessWidget {
  final Pengguna pengguna;

  const ProfilPage({super.key, required this.pengguna});

  static const _pemisah = Divider(height: 1, color: AppColors.track);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.track),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    pengguna.nama.isEmpty ? '?' : pengguna.nama[0],
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                title: Text(
                  pengguna.nama,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                subtitle: const Text('Akun SewaSkill'),
              ),
            ),
          ),
          _judul('Informasi pribadi'),
          _kartu([
            _info(Icons.person_outline_rounded, 'Nama', pengguna.nama),
            _pemisah,
            _info(Icons.email_outlined, 'Email', pengguna.email),
            _pemisah,
            _info(Icons.location_on_outlined, 'Lokasi', pengguna.lokasi),
          ]),
          _judul('Aktivitas'),
          _kartu([
            _menu(Icons.receipt_long_outlined, 'Pesanan saya'),
            _pemisah,
            _menu(Icons.bookmark_border_rounded, 'Jasa tersimpan'),
          ]),
          _judul('Pengaturan'),
          _kartu([
            _menu(Icons.manage_accounts_outlined, 'Pengaturan akun'),
            _pemisah,
            _menu(Icons.notifications_none_rounded, 'Notifikasi'),
          ]),
          _judul('Bantuan'),
          _kartu([
            _menu(Icons.help_outline_rounded, 'Pusat bantuan'),
            _pemisah,
            _menu(Icons.info_outline_rounded, 'Tentang SewaSkill'),
          ]),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _judul(String teks) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10, left: 4),
      child: Text(
        teks,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.inkSoft,
        ),
      ),
    );
  }

  Widget _kartu(List<Widget> baris) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.track),
      ),
      child: Column(children: baris),
    );
  }

  Widget _info(IconData icon, String label, String nilai) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: const TextStyle(fontSize: 13, color: AppColors.inkSoft),
      ),
      subtitle: Text(
        nilai,
        style: const TextStyle(fontSize: 14, color: AppColors.ink),
      ),
    );
  }

  Widget _menu(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, color: AppColors.ink),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.inkSoft,
      ),
      onTap: () {},
    );
  }
}
