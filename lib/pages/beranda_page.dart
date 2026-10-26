import 'package:flutter/material.dart';

import '../components/app_bottom_nav_bar.dart';
import '../talent.dart';
import '../talent_data.dart';
import 'detail_jasa_page.dart';
import 'katalog_page.dart';
import 'order_page.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstTalent = daftarTalent.isNotEmpty ? daftarTalent.first : null;

    final pages = [
      _BerandaView(
        onExploreTap: () => _onItemTapped(1),
        onOrderTap: () => _onItemTapped(2),
      ),
      const KatalogPage(),
      if (firstTalent != null)
        OrderPage(talent: firstTalent)
      else
        const Scaffold(body: Center(child: Text('Data talent kosong'))),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
    );
  }
}

class _BerandaView extends StatelessWidget {
  final VoidCallback onExploreTap;
  final VoidCallback onOrderTap;

  const _BerandaView({
    required this.onExploreTap,
    required this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.bolt_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SewaSkill',
                  style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Jasa Freelance Digital Mikro',
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifikasi',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            tooltip: 'Pesan',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _buildSearchBox(context, colorScheme),
          const SizedBox(height: 16),
          _buildPromoBanner(context, colorScheme),
          const SizedBox(height: 20),
          _buildCategorySection(context, colorScheme),
          const SizedBox(height: 20),
          _buildGuaranteesRow(colorScheme),
          const SizedBox(height: 24),
          _buildTalentSectionHeader(context),
          const SizedBox(height: 12),
          _buildTalentList(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context, ColorScheme colorScheme) {
    return Material(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: InkWell(
        onTap: onExploreTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: colorScheme.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Cari editor video, desainer, tutor koding...',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Icon(
                Icons.tune_rounded,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.primaryContainer.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'PROMO SPESIAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Solusi Kreatif Tanpa Ribet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pesan jasa mikro berkualitas mulai dari Rp 25.000 langsung ke talent terpercaya.',
            style: TextStyle(
              fontSize: 12.5,
              color: colorScheme.onPrimaryContainer,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onExploreTap,
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: const Text('Jelajahi Sekarang'),
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, ColorScheme colorScheme) {
    final categories = [
      _Category('Edit Video', Icons.movie_creation_outlined),
      _Category('Desain Grafis', Icons.palette_outlined),
      _Category('Tutor Koding', Icons.code_rounded),
      _Category('Tulis Konten', Icons.edit_note_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori Layanan',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories.map((cat) {
            return Expanded(
              child: GestureDetector(
                onTap: onExploreTap,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(cat.icon, color: colorScheme.primary, size: 22),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGuaranteesRow(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          _buildGuaranteeItem(
            colorScheme,
            Icons.speed_rounded,
            'Pengerjaan Cepat',
            'Mulai 24 jam',
          ),
          _buildGuaranteeDivider(colorScheme),
          _buildGuaranteeItem(
            colorScheme,
            Icons.verified_user_outlined,
            'Aman & Bergaransi',
            'Dana tertahan aman',
          ),
          _buildGuaranteeDivider(colorScheme),
          _buildGuaranteeItem(
            colorScheme,
            Icons.star_outline_rounded,
            'Talent Pilihan',
            'Rating transparan',
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeItem(
    ColorScheme colorScheme,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.5,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeDivider(ColorScheme colorScheme) {
    return Container(
      width: 1,
      height: 28,
      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }

  Widget _buildTalentSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Talent Terlaris',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onExploreTap,
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Text('Lihat Semua', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildTalentList(BuildContext context, ColorScheme colorScheme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daftarTalent.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final talent = daftarTalent[index];
        return _TalentCard(talent: talent);
      },
    );
  }
}

class _TalentCard extends StatelessWidget {
  final Talent talent;

  const _TalentCard({required this.talent});

  String _formatRupiah(int nominal) {
    final str = nominal.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp $buffer';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  talent.nama.substring(0, 1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      talent.nama,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      talent.bidang,
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      talent.rating.toString(),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            talent.deskripsi,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mulai dari',
                    style: TextStyle(
                      fontSize: 10,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _formatRupiah(talent.hargaMulai),
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailJasaPage(talent: talent),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                child: const Text('Detail', style: TextStyle(fontSize: 11.5)),
              ),
              const SizedBox(width: 6),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderPage(talent: talent),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Pesan', style: TextStyle(fontSize: 11.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Category {
  final String title;
  final IconData icon;

  const _Category(this.title, this.icon);
}
