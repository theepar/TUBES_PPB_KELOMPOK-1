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
      body: IndexedStack(index: _selectedIndex, children: pages),
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

  const _BerandaView({required this.onExploreTap, required this.onOrderTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _buildHeader(colorScheme),
            const SizedBox(height: 20),
            _buildSearchBox(colorScheme),
            const SizedBox(height: 20),
            _buildHeroBanner(context, colorScheme),
            const SizedBox(height: 28),
            _SectionHeader(title: 'Kategori', onActionTap: onExploreTap),
            const SizedBox(height: 14),
            _buildCategories(colorScheme),
            const SizedBox(height: 28),
            _SectionHeader(title: 'Talent Terlaris', onActionTap: onExploreTap),
            const SizedBox(height: 14),
            _buildFeaturedTalents(),
            const SizedBox(height: 28),
            _buildGuarantees(colorScheme),
            const SizedBox(height: 28),
            const _SectionHeader(title: 'Rekomendasi untukmu'),
            const SizedBox(height: 14),
            for (int i = 0; i < daftarTalent.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _TalentTile(talent: daftarTalent[i], accent: _accentFor(i)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _brandBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            'SS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, selamat datang 👋',
                style: TextStyle(
                  fontSize: 12.5,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'SewaSkill',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBox(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: onExploreTap,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 22,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Cari editor, desainer, tutor...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onExploreTap,
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Icon(Icons.tune_rounded, color: colorScheme.onPrimary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner(BuildContext context, ColorScheme colorScheme) {
    final dark = Color.lerp(colorScheme.primary, Colors.black, 0.35)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, dark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -40,
              top: -40,
              child: _DecorCircle(size: 160, opacity: 0.10),
            ),
            Positioned(
              right: 36,
              bottom: -56,
              child: _DecorCircle(size: 120, opacity: 0.08),
            ),
            Positioned(
              right: 22,
              top: 26,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 56,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Mulai Rp 25.000',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Solusi kreatif\ntanpa ribet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pesan jasa mikro langsung ke\ntalent terpercaya.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: onExploreTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: dark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Jelajahi Sekarang',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(ColorScheme colorScheme) {
    return Row(
      children: [
        for (final cat in _categories)
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onExploreTap,
              child: Column(
                children: [
                  Material(
                    color: cat.accent.background,
                    borderRadius: BorderRadius.circular(20),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onExploreTap,
                      hoverColor: Colors.transparent,
                      child: SizedBox(
                        width: 62,
                        height: 62,
                        child: Icon(
                          cat.accent.icon,
                          size: 28,
                          color: cat.accent.foreground,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeaturedTalents() {
    return SizedBox(
      height: 214,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: daftarTalent.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) => _FeaturedTalentCard(
          talent: daftarTalent[index],
          accent: _accentFor(index),
        ),
      ),
    );
  }

  Widget _buildGuarantees(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildGuaranteeItem(
            colorScheme,
            Icons.bolt_rounded,
            'Cepat',
            'Mulai 24 jam',
          ),
          _buildGuaranteeItem(
            colorScheme,
            Icons.verified_user_rounded,
            'Aman',
            'Dana tertahan',
          ),
          _buildGuaranteeItem(
            colorScheme,
            Icons.star_rounded,
            'Terpilih',
            'Rating jelas',
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onActionTap;

  const _SectionHeader({required this.title, this.onActionTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ),
        if (onActionTap != null)
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DecorCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  final double rating;
  final bool onDark;

  const _RatingChip({required this.rating, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: onDark
            ? Colors.white.withValues(alpha: 0.9)
            : Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
          const SizedBox(width: 3),
          Text(
            rating.toString(),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: onDark ? Colors.black87 : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedTalentCard extends StatelessWidget {
  final Talent talent;
  final _Accent accent;

  const _FeaturedTalentCard({required this.talent, required this.accent});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 224,
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _openDetail(context, talent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 96,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent.foreground, accent.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -14,
                      bottom: -18,
                      child: Icon(
                        accent.icon,
                        size: 92,
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: _RatingChip(rating: talent.rating, onDark: true),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      talent.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      talent.bidang,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatRupiah(talent.hargaMulai),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: accent.background,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_outward_rounded,
                            size: 16,
                            color: accent.foreground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TalentTile extends StatelessWidget {
  final Talent talent;
  final _Accent accent;

  const _TalentTile({required this.talent, required this.accent});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: () => _openDetail(context, talent),
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: accent.background,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  talent.nama.substring(0, 1),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: accent.foreground,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      talent.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      talent.bidang,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _RatingChip(rating: talent.rating),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${talent.jumlahOrder} order',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => _openOrder(context, talent),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    child: const Text('Pesan', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _brandBlue = Color(0xFF1C7ED6);

class _Category {
  final String title;
  final _Accent accent;

  const _Category(this.title, this.accent);
}

class _Accent {
  final Color background;
  final Color foreground;
  final Color gradientEnd;
  final IconData icon;

  const _Accent({
    required this.background,
    required this.foreground,
    required this.gradientEnd,
    required this.icon,
  });
}

// Urutan accent mengikuti urutan kategori dan urutan daftarTalent.
const _accents = [
  _Accent(
    background: Color(0xFFFFE9D6),
    foreground: Color(0xFFE8590C),
    gradientEnd: Color(0xFFFFA45B),
    icon: Icons.movie_creation_rounded,
  ),
  _Accent(
    background: Color(0xFFE7E1FF),
    foreground: Color(0xFF6B4EE6),
    gradientEnd: Color(0xFFA48BFF),
    icon: Icons.palette_rounded,
  ),
  _Accent(
    background: Color(0xFFDCEBFF),
    foreground: Color(0xFF1C7ED6),
    gradientEnd: Color(0xFF63B3FF),
    icon: Icons.code_rounded,
  ),
  _Accent(
    background: Color(0xFFFFE0EA),
    foreground: Color(0xFFD6336C),
    gradientEnd: Color(0xFFFF8AB0),
    icon: Icons.edit_note_rounded,
  ),
];

final _categories = [
  _Category('Edit Video', _accents[0]),
  _Category('Desain', _accents[1]),
  _Category('Koding', _accents[2]),
  _Category('Konten', _accents[3]),
];

_Accent _accentFor(int index) => _accents[index % _accents.length];

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

void _openDetail(BuildContext context, Talent talent) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => DetailJasaPage(talent: talent)),
  );
}

void _openOrder(BuildContext context, Talent talent) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => OrderPage(talent: talent)),
  );
}
