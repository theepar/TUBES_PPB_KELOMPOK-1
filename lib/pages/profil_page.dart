import 'package:flutter/material.dart';

import '../pengguna.dart';
import '../utils/app_colors.dart';

class ProfilPage extends StatelessWidget {
  final Pengguna pengguna;

  const ProfilPage({super.key, required this.pengguna});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.track),
            ),
            child: Column(
              children: [
                _Baris(
                  icon: Icons.person_outline_rounded,
                  label: 'Nama',
                  nilai: pengguna.nama,
                ),
                const Divider(height: 1, color: AppColors.track),
                _Baris(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  nilai: pengguna.email,
                ),
                const Divider(height: 1, color: AppColors.track),
                _Baris(
                  icon: Icons.location_on_outlined,
                  label: 'Lokasi',
                  nilai: pengguna.lokasi,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Baris extends StatelessWidget {
  final IconData icon;
  final String label;
  final String nilai;

  const _Baris({required this.icon, required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppColors.inkSoft),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              nilai,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
