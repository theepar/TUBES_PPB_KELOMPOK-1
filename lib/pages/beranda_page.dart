import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animations/animasi.dart';
import '../components/navbar.dart';
import '../components/glass_card.dart';
import '../components/pill_tabs.dart';
import '../components/talent_card.dart';
import '../pengguna.dart';
import '../talent.dart';
import '../talent_data.dart';
import '../utils/app_colors.dart';
import '../utils/currency_formatter.dart';
import 'detail_jasa_page.dart';
import 'katalog_page.dart';
import 'order_page.dart';
import 'tambah_jasa_page.dart';

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
      const _BerandaView(),
      const KatalogPage(),
      if (firstTalent != null)
        OrderPage(talent: firstTalent)
      else
        const Scaffold(body: Center(child: Text('Data talent kosong'))),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        onAddTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TambahJasaPage()),
        ),
      ),
    );
  }
}

class _Kategori {
  final String label;
  final String? kata;
  final IconData icon;

  const _Kategori(this.label, this.kata, this.icon);
}

const _kategori = [
  _Kategori('Semua', null, Icons.apps_rounded),
  _Kategori('Video', 'Video', Icons.movie_creation_outlined),
  _Kategori('Desain', 'Desain', Icons.palette_outlined),
  _Kategori('Koding', 'Koding', Icons.code_rounded),
  _Kategori('Konten', 'Konten', Icons.edit_note_rounded),
];

class _BerandaView extends StatefulWidget {
  const _BerandaView();

  @override
  State<_BerandaView> createState() => _BerandaViewState();
}

class _BerandaViewState extends State<_BerandaView> {
  int _kategoriIndex = 0;
  int _heroTab = 0;
  int _urutTab = 0;

  List<Talent> get _terfilter {
    final kata = _kategori[_kategoriIndex].kata;
    return daftarTalent
        .where((t) => kata == null || t.bidang.contains(kata))
        .toList();
  }

  List<Talent> get _terurut {
    final list = _terfilter;
    switch (_urutTab) {
      case 1:
        list.sort((a, b) => a.hargaMulai.compareTo(b.hargaMulai));
      case 2:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      default:
        list.sort((a, b) => b.jumlahOrder.compareTo(a.jumlahOrder));
    }
    return list;
  }

  void _tampilkanNotifikasi() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Belum ada notifikasi baru'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final talents = _terurut;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Stack(
        children: [
          const Positioned.fill(child: _SkyBackground()),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              children: [
                BerandaHeader(
                  nama: penggunaLogin.nama,
                  lokasi: penggunaLogin.lokasi,
                  onBellTap: _tampilkanNotifikasi,
                ),
                const SizedBox(height: 24),
                Center(
                  child: PillTabs(
                    labels: const ['Harga', 'Rating'],
                    selectedIndex: _heroTab,
                    onChanged: (i) => setState(() => _heroTab = i),
                  ),
                ),
                const SizedBox(height: 14),
                _buildHero(),
                const SizedBox(height: 20),
                _buildStats(),
                const SizedBox(height: 28),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Daftar Talent',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    _KategoriDropdown(
                      selectedIndex: _kategoriIndex,
                      onChanged: (i) => setState(() => _kategoriIndex = i),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                PillTabs(
                  labels: const ['Terlaris', 'Termurah', 'Rating'],
                  selectedIndex: _urutTab,
                  onChanged: (i) => setState(() => _urutTab = i),
                  expand: true,
                ),
                const SizedBox(height: 14),
                _buildDaftar(talents),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaftar(List<Talent> talents) {
    if (talents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'Belum ada talent di kategori ini',
            style: TextStyle(color: AppColors.inkSoft),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < talents.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          TalentCard(
            talent: talents[i],
            onTap: () => _openDetail(context, talents[i]),
            onOrderTap: () => _openOrder(context, talents[i]),
          ),
        ],
      ],
    );
  }

  Widget _buildHero() {
    final list = _terfilter;
    const gaya = TextStyle(
      fontSize: 80,
      height: 1.1,
      fontWeight: FontWeight.w800,
      letterSpacing: -2,
      color: AppColors.primary,
      fontFeatures: [FontFeature.tabularFigures()],
    );

    Widget angka = const Text('–', style: gaya);
    String keterangan = 'Belum ada talent';

    if (list.isNotEmpty) {
      final bool harga = _heroTab == 0;
      final double nilai;
      if (harga) {
        nilai = list
            .map((t) => t.hargaMulai)
            .reduce((a, b) => a < b ? a : b)
            .toDouble();
        keterangan = 'Rupiah, harga mulai dari';
      } else {
        nilai = list.map((t) => t.rating).reduce((a, b) => a + b) / list.length;
        keterangan = 'Rating rata-rata';
      }

      angka = CountUp(
        key: ValueKey(_heroTab),
        nilai: nilai,
        builder: (context, v) => Text(
          harga
              ? formatRupiah(v).replaceFirst('Rp ', '')
              : v.toStringAsFixed(1),
          style: gaya,
        ),
      );
    }

    return Column(
      children: [
        FittedBox(fit: BoxFit.scaleDown, child: angka),
        Text(
          keterangan,
          style: const TextStyle(fontSize: 14.5, color: AppColors.inkSoft),
        ),
      ],
    );
  }

  Widget _buildStats() {
    final list = _terfilter;
    final order = list.fold<int>(0, (s, t) => s + t.jumlahOrder);
    final ulasan = list.fold<int>(0, (s, t) => s + t.jumlahUlasan);

    return Row(
      children: [
        Expanded(
          child: _StatCard(label: 'Talent', value: '${list.length}'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(label: 'Order', value: '$order'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(label: 'Ulasan', value: '$ulasan'),
        ),
      ],
    );
  }
}

class _SkyBackground extends StatelessWidget {
  const _SkyBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.skyHaze,
                AppColors.skyLight,
                AppColors.background,
              ],
              stops: [0, 0.32, 0.62],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.95, -0.85),
              radius: 0.7,
              colors: [
                Colors.white.withValues(alpha: 0.7),
                Colors.white.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _KategoriDropdown extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _KategoriDropdown({
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final terpilih = _kategori[selectedIndex];

    return PopupMenuButton<int>(
      tooltip: 'Pilih kategori',
      initialValue: selectedIndex,
      onSelected: onChanged,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 6),
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      shadowColor: const Color(0x331E3A6B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => [
        for (int i = 0; i < _kategori.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: Row(
              children: [
                Icon(
                  _kategori[i].icon,
                  size: 20,
                  color: i == selectedIndex
                      ? AppColors.primary
                      : AppColors.inkSoft,
                ),
                const SizedBox(width: 12),
                Text(
                  _kategori[i].label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: i == selectedIndex
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: i == selectedIndex
                        ? AppColors.primary
                        : AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Container(
        height: 36,
        padding: const EdgeInsets.only(left: 12, right: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x141E3A6B),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(terpilih.icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              terpilih.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: AppColors.inkSoft,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      opacity: 0.95,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.5, color: AppColors.inkSoft),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                height: 1.15,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BerandaHeader extends StatelessWidget {
  final String nama;
  final String lokasi;
  final VoidCallback? onBellTap;

  const BerandaHeader({
    super.key,
    required this.nama,
    required this.lokasi,
    this.onBellTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Hi, $nama',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 28,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            _BellButton(onTap: onBellTap),
          ],
        ),
        const SizedBox(height: 2),
        const Text(
          'Siap temukan talent terbaik hari ini?',
          style: TextStyle(fontSize: 14.5, color: AppColors.inkSoft),
        ),
        const SizedBox(height: 12),
        _LokasiChip(lokasi: lokasi),
      ],
    );
  }
}

class _BellButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _BellButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Notifikasi',
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x141E3A6B),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 24,
                  color: AppColors.ink,
                ),
                Positioned(
                  top: 11,
                  right: 12,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LokasiChip extends StatelessWidget {
  final String lokasi;

  const _LokasiChip({required this.lokasi});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Lokasi: $lokasi',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  lokasi,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13.5, color: AppColors.ink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
