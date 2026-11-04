import 'package:flutter/material.dart';

import '../components/navbar.dart';
import '../components/ringkasan_beranda.dart';
import '../components/talent_card.dart';
import '../models/pengguna.dart';
import '../models/talent.dart';
import '../talent_data.dart';
import '../utils/app_colors.dart';
import 'detail_jasa_page.dart';
import 'katalog_page.dart';
import 'order_page.dart';
import 'profil_page.dart';
import 'tambah_jasa_page.dart';

class BerandaPage extends StatefulWidget {
  final Pengguna pengguna;

  const BerandaPage({super.key, this.pengguna = penggunaDefault});

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
    final pages = [
      _BerandaView(pengguna: widget.pengguna),
      KatalogPage(key: ValueKey(daftarTalent.length)),
      ProfilPage(pengguna: widget.pengguna),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahJasaPage()),
          );
          setState(() {});
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Jasa',
        child: const Icon(Icons.add),
      ),
    );
  }
}

const _opsiUrut = ['Terlaris', 'Termurah', 'Rating'];

class _BerandaView extends StatefulWidget {
  final Pengguna pengguna;

  const _BerandaView({required this.pengguna});

  @override
  State<_BerandaView> createState() => _BerandaViewState();
}

class _BerandaViewState extends State<_BerandaView> {
  int _urutTab = 0; // 0 = Terlaris, 1 = Termurah, 2 = Rating

  List<Talent> get _terurut {
    final list = daftarTalent.toList();
    if (_urutTab == 1) {
      list.sort((a, b) => a.hargaMulai.compareTo(b.hargaMulai));
    } else if (_urutTab == 2) {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
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
    final talents = _terurut.take(4).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${widget.pengguna.nama}',
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
                          widget.pengguna.lokasi,
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
            ],
          ),
          const SizedBox(height: 16),

          RingkasanBeranda(talents: daftarTalent),
          const SizedBox(height: 20),

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

          if (talents.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'Belum ada talent',
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
}
