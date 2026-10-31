import 'package:flutter/material.dart';

import '../components/navbar.dart';
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
        OrderPage(talent: firstTalent, onKembali: () => _onItemTapped(0))
      else
        const Scaffold(body: Center(child: Text('Data talent kosong'))),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TambahJasaPage()),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Jasa',
        child: const Icon(Icons.add),
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

const _opsiUrut = ['Terlaris', 'Termurah', 'Rating'];

class _BerandaView extends StatefulWidget {
  const _BerandaView();

  @override
  State<_BerandaView> createState() => _BerandaViewState();
}

class _BerandaViewState extends State<_BerandaView> {
  int _kategoriIndex = 0;
  int _heroTab = 0; // 0 = Harga, 1 = Rating
  int _urutTab = 0; // 0 = Terlaris, 1 = Termurah, 2 = Rating

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

  @override
  Widget build(BuildContext context) {
    final talents = _terurut;
    final terpilih = _kategori[_kategoriIndex];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Sapaan & Lokasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${penggunaLogin.nama}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Siap temukan talent terbaik hari ini?',
                      style: TextStyle(fontSize: 13, color: AppColors.inkSoft),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 15,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          penggunaLogin.lokasi,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Belum ada notifikasi baru')),
                  );
                },
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Hero Ringkasan Card
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.track),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('Harga'),
                        selected: _heroTab == 0,
                        showCheckmark: false,
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: _heroTab == 0 ? AppColors.primary : AppColors.track,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: _heroTab == 0 ? FontWeight.bold : FontWeight.w500,
                          color: _heroTab == 0 ? Colors.white : AppColors.ink,
                        ),
                        onSelected: (_) => setState(() => _heroTab = 0),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Rating'),
                        selected: _heroTab == 1,
                        showCheckmark: false,
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: _heroTab == 1 ? AppColors.primary : AppColors.track,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: _heroTab == 1 ? FontWeight.bold : FontWeight.w500,
                          color: _heroTab == 1 ? Colors.white : AppColors.ink,
                        ),
                        onSelected: (_) => setState(() => _heroTab = 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildHeroAngka(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 3 Kotak Statistik
          _buildStatsRow(),
          const SizedBox(height: 20),

          // Kategori Chips (Sesuai Desain Screenshot)
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Kategori Layanan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
              ),
              PopupMenuButton<int>(
                tooltip: 'Pilih kategori',
                initialValue: _kategoriIndex,
                onSelected: (i) => setState(() => _kategoriIndex = i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        terpilih.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context) => [
                  for (int i = 0; i < _kategori.length; i++)
                    PopupMenuItem<int>(
                      value: i,
                      child: Text(_kategori[i].label),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Horizontal Chips Kategori (Rounded 8px, tanpa centang)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < _kategori.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_kategori[i].label),
                      selected: _kategoriIndex == i,
                      showCheckmark: false,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: _kategoriIndex == i
                            ? AppColors.primary
                            : AppColors.track,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: _kategoriIndex == i
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: _kategoriIndex == i
                            ? Colors.white
                            : AppColors.ink,
                      ),
                      onSelected: (_) => setState(() => _kategoriIndex = i),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Urutan Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < _opsiUrut.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_opsiUrut[i]),
                      selected: _urutTab == i,
                      showCheckmark: false,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: _urutTab == i
                            ? AppColors.primary
                            : AppColors.track,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: _urutTab == i
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _urutTab == i ? Colors.white : AppColors.ink,
                      ),
                      onSelected: (_) => setState(() => _urutTab = i),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Daftar Card Talent
          if (talents.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'Belum ada talent di kategori ini',
                  style: TextStyle(color: AppColors.inkSoft),
                ),
              ),
            )
          else
            for (final talent in talents)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TalentCard(
                  talent: talent,
                  onTap: () => _openDetail(context, talent),
                  onOrderTap: () => _openOrder(context, talent),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildHeroAngka() {
    final list = _terfilter;
    const gaya = TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      color: AppColors.primary,
      height: 1.1,
    );

    if (list.isEmpty) {
      return const Column(
        children: [
          Text('–', style: gaya),
          Text(
            'Belum ada talent',
            style: TextStyle(fontSize: 13, color: AppColors.inkSoft),
          ),
        ],
      );
    }

    final bool isHarga = _heroTab == 0;
    final String nilaiStr;
    final String keterangan;

    if (isHarga) {
      final minHarga = list
          .map((t) => t.hargaMulai)
          .reduce((a, b) => a < b ? a : b);
      nilaiStr = formatRupiah(minHarga).replaceFirst('Rp ', '');
      keterangan = 'Rupiah, harga mulai dari';
    } else {
      final avgRating =
          list.map((t) => t.rating).reduce((a, b) => a + b) / list.length;
      nilaiStr = avgRating.toStringAsFixed(1);
      keterangan = 'Rating rata-rata';
    }

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(nilaiStr, style: gaya),
        ),
        const SizedBox(height: 2),
        Text(
          keterangan,
          style: const TextStyle(fontSize: 13, color: AppColors.inkSoft),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final list = _terfilter;
    final order = list.fold<int>(0, (s, t) => s + t.jumlahOrder);
    final ulasan = list.fold<int>(0, (s, t) => s + t.jumlahUlasan);

    return Row(
      children: [
        Expanded(child: _buildStatItem('Talent', '${list.length}')),
        const SizedBox(width: 8),
        Expanded(child: _buildStatItem('Order', '$order')),
        const SizedBox(width: 8),
        Expanded(child: _buildStatItem('Ulasan', '$ulasan')),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.track),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11.5, color: AppColors.inkSoft),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
