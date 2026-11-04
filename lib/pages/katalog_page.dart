import 'package:flutter/material.dart';

import '../components/talent_card.dart';
import '../talent_data.dart';
import '../models/talent.dart';
import '../utils/app_colors.dart';
import 'detail_jasa_page.dart';
import 'order_page.dart';
import 'tambah_jasa_page.dart';

class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key});

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  String _kata = '';

  List<Talent> get _terfilter {
    final q = _kata.trim().toLowerCase();
    return daftarTalent.where((t) {
      return q.isEmpty ||
          t.nama.toLowerCase().contains(q) ||
          t.bidang.toLowerCase().contains(q);
    }).toList();
  }

  void _hapus(Talent t) {
    setState(() => daftarTalent.removeWhere((x) => x.id == t.id));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Jasa dihapus')));
  }

  Widget _menu(Talent t) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert, size: 20, color: AppColors.inkSoft),
      onSelected: (v) {
        if (v == 'edit') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahJasaPage(talent: t)),
          ).then((_) => setState(() {}));
        } else {
          _hapus(t);
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'edit', child: Text('Edit')),
        PopupMenuItem(value: 'hapus', child: Text('Hapus')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final talents = _terfilter;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Katalog')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            onChanged: (v) => setState(() => _kata = v),
            decoration: const InputDecoration(
              hintText: 'Cari nama atau bidang',
              prefixIcon: Icon(Icons.search_rounded),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          if (talents.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'Belum ada jasa',
                  style: TextStyle(color: AppColors.inkSoft),
                ),
              ),
            )
          else
            for (final t in talents)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TalentCard(
                  talent: t,
                  menu: _menu(t),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailJasaPage(talent: t)),
                  ),
                  onOrderTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrderPage(talent: t)),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
