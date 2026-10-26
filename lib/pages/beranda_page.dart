import 'package:flutter/material.dart';

import '../talent_data.dart';
import 'detail_jasa_page.dart';
import 'katalog_page.dart';
import 'order_page.dart';
import 'tambah_jasa_page.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.work_outline_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'SewaSkill',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Kelompok 1',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          _buildHeroCard(context, colorScheme),
          const SizedBox(height: 20),
          _buildSectionTitle(context, 'Navigasi Modul', Icons.explore_rounded),
          const SizedBox(height: 12),
          _buildQuickActions(context, colorScheme),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Tentang Proyek', Icons.info_outline_rounded),
          const SizedBox(height: 12),
          _buildProjectOverview(context, colorScheme),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Tim Pengembang', Icons.group_rounded),
          const SizedBox(height: 12),
          _buildTeamList(colorScheme),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Status Modul Aplikasi', Icons.layers_rounded),
          const SizedBox(height: 12),
          _buildModuleStatusList(colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'TUGAS BESAR I (UTS)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'SewaSkill Mobile',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Platform digital pemesanan jasa freelance mikro (video editing, desain grafis, tutor koding, dan kepenulisan) berbasis mobile.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.45,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildPill(colorScheme, 'Flutter'),
              _buildPill(colorScheme, 'Dart'),
              _buildPill(colorScheme, 'Material 3'),
              _buildPill(colorScheme, 'Pemrograman Perangkat Bergerak'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill(ColorScheme colorScheme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, ColorScheme colorScheme) {
    final firstTalent = daftarTalent.isNotEmpty ? daftarTalent.first : null;

    final actions = [
      _ActionItem(
        title: 'Katalog Jasa',
        subtitle: 'Cari & telusuri talent',
        icon: Icons.search_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KatalogPage()),
          );
        },
      ),
      _ActionItem(
        title: 'Form Order',
        subtitle: 'Kalkulasi & checkout',
        icon: Icons.receipt_long_rounded,
        onTap: () {
          if (firstTalent != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderPage(talent: firstTalent),
              ),
            );
          }
        },
      ),
      _ActionItem(
        title: 'Daftar Jasa',
        subtitle: 'Form pendaftaran talent',
        icon: Icons.add_circle_outline_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahJasaPage()),
          );
        },
      ),
      _ActionItem(
        title: 'Detail Talent',
        subtitle: 'Profil & paket jasa',
        icon: Icons.badge_outlined,
        onTap: () {
          if (firstTalent != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailJasaPage(talent: firstTalent),
              ),
            );
          }
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, index) {
        final item = actions[index];
        return Material(
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
          child: InkWell(
            onTap: item.onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: colorScheme.primary, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectOverview(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aplikasi SewaSkill dirancang untuk mempermudah transaksi jasa freelance digital berskala mikro secara cepat, transparan, dan terstruktur.',
            style: TextStyle(fontSize: 13, height: 1.45),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _buildInfoRow('Mata Kuliah', 'Pemrograman Perangkat Bergerak (PPB)'),
          const SizedBox(height: 8),
          _buildInfoRow('Tipe Tugas', 'Tugas Besar I (UTS) - Semester Genap'),
          const SizedBox(height: 8),
          _buildInfoRow('Kelompok', 'Kelompok 1'),
          const SizedBox(height: 8),
          _buildInfoRow('Teknologi', 'Flutter SDK 3 & Material Design 3'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        const Text(': ', style: TextStyle(fontSize: 12, color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamList(ColorScheme colorScheme) {
    const members = [
      _Member('Fadhil R.', '@fadhilr2', 'FR'),
      _Member('I Putu Gede Deva Gundhala', '@theepar', 'DG'),
      _Member('Adita R.', '@aditarhm', 'AR'),
      _Member('Jeni', '@ejeniamutiara', 'JN'),
      _Member('Abdurrahman Saleh', '@JustAHermit', 'AS'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: members.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: 64,
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        itemBuilder: (context, index) {
          final m = members[index];
          return ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: -1),
            leading: CircleAvatar(
              radius: 17,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                m.initials,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
            title: Text(
              m.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                m.github,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModuleStatusList(ColorScheme colorScheme) {
    const modules = [
      _ModuleStatus(
        name: 'Beranda & Informasi Proyek',
        page: 'beranda_page.dart',
        isReady: true,
      ),
      _ModuleStatus(
        name: 'Formulir Pemesanan & Kalkulasi Biaya',
        page: 'order_page.dart',
        isReady: true,
      ),
      _ModuleStatus(
        name: 'Katalog & Pencarian Talent',
        page: 'katalog_page.dart',
        isReady: false,
      ),
      _ModuleStatus(
        name: 'Detail Talent & Pilihan Paket',
        page: 'detail_jasa_page.dart',
        isReady: false,
      ),
      _ModuleStatus(
        name: 'Pendaftaran Jasa Baru',
        page: 'tambah_jasa_page.dart',
        isReady: false,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: modules.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: 52,
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
        itemBuilder: (context, index) {
          final mod = modules[index];
          return ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: -1),
            leading: Icon(
              mod.isReady ? Icons.check_circle_rounded : Icons.pending_outlined,
              size: 20,
              color: mod.isReady ? Colors.green : Colors.orange,
            ),
            title: Text(
              mod.name,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              mod.page,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Text(
              mod.isReady ? 'Siap' : 'Progres',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: mod.isReady ? Colors.green : Colors.orange,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ActionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

class _Member {
  final String name;
  final String github;
  final String initials;

  const _Member(this.name, this.github, this.initials);
}

class _ModuleStatus {
  final String name;
  final String page;
  final bool isReady;

  const _ModuleStatus({
    required this.name,
    required this.page,
    required this.isReady,
  });
}
