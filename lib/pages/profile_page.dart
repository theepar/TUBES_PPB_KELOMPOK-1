import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.6),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    'DG',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'I Putu Gede Deva Gundhala',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@theepar • Kelompok 1 PPB',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Tugas Besar I (UTS) - PPB',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Informasi Akun & Aktivitas',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.6),
              ),
            ),
            child: Column(
              children: [
                _buildListTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profil',
                  subtitle: 'Nama, email, dan biodata',
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  indent: 56,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                ),
                _buildListTile(
                  icon: Icons.history_rounded,
                  title: 'Riwayat Pesanan',
                  subtitle: 'Daftar transaksi jasa aktif',
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  indent: 56,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                ),
                _buildListTile(
                  icon: Icons.favorite_border_rounded,
                  title: 'Talent Favorit',
                  subtitle: 'Daftar freelancer tersimpan',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Aplikasi',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.6),
              ),
            ),
            child: Column(
              children: [
                _buildListTile(
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang SewaSkill',
                  subtitle: 'Versi 0.1.0 • Material 3',
                  onTap: () {},
                ),
                Divider(
                  height: 1,
                  indent: 56,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                ),
                _buildListTile(
                  icon: Icons.logout_rounded,
                  title: 'Keluar',
                  titleColor: Colors.red,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 11.5),
            )
          : null,
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }
}
