import '../../../app/app_route.dart';

import 'package:flutter/material.dart';

import '../../../core/widgets/talent_card.dart';
import '../../../core/data/talent_data.dart';
import '../../../core/models/talent.dart';
import '../../../core/theme/app_colors.dart';
import '../../jasa/pages/detail_jasa_page.dart';
import '../../order/pages/order_page.dart';
import '../../jasa/pages/tambah_jasa_page.dart';
import '../../../core/data/demo_store.dart';
import '../../../core/widgets/demo_ui.dart';
import '../../../core/widgets/app_select.dart';

class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key});

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  String _kata = '';
  String _daerah = 'semua';
  String _urut = 'rekomendasi';
  int? _minimum;
  int? _maksimum;

  int get _jumlahFilter =>
      (_daerah == 'semua' ? 0 : 1) +
      (_minimum == null && _maksimum == null ? 0 : 1) +
      (_urut == 'rekomendasi' ? 0 : 1);

  List<Talent> get _terfilter {
    final q = _kata.trim().toLowerCase();
    final list = daftarTalent.where((t) {
      if (!t.tampil && t.ownerId != DemoStore.instance.pengguna?.id) {
        return false;
      }
      if (_daerah != 'semua' &&
          t.lokasi.split(',').first.trim().toLowerCase() !=
              _daerah.toLowerCase()) {
        return false;
      }
      if (_minimum != null && t.hargaMulai < _minimum!) return false;
      if (_maksimum != null && t.hargaMulai > _maksimum!) return false;
      return q.isEmpty ||
          t.nama.toLowerCase().contains(q) ||
          t.bidang.toLowerCase().contains(q) ||
          t.lokasi.toLowerCase().contains(q);
    }).toList();
    if (_urut == 'termurah') {
      list.sort((a, b) => a.hargaMulai.compareTo(b.hargaMulai));
    }
    if (_urut == 'termahal') {
      list.sort((a, b) => b.hargaMulai.compareTo(a.hargaMulai));
    }
    if (_urut == 'nama') {
      list.sort(
        (a, b) => a.bidang.toLowerCase().compareTo(b.bidang.toLowerCase()),
      );
    }
    return list;
  }

  Future<void> _bukaFilter() async {
    var daerah = _daerah;
    var urut = _urut;
    var minimum = _minimum?.toString() ?? '';
    var maksimum = _maksimum?.toString() ?? '';
    final form = GlobalKey<FormState>();
    final kota =
        daftarTalent
            .where(
              (t) => t.tampil || t.ownerId == DemoStore.instance.pengguna?.id,
            )
            .map((t) => t.lokasi.split(',').first.trim())
            .toSet()
            .toList()
          ..sort();
    final daerahOptions = {
      'semua': 'Semua daerah',
      for (final item in kota) item: item,
    };
    if (!daerahOptions.containsKey(daerah)) daerahOptions[daerah] = daerah;
    await showDialog<void>(
      animationStyle: AnimationStyle.noAnimation,
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 560),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.all(24),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          title: const Text('Filter jasa'),
          content: SizedBox(
            width: 512,
            child: SingleChildScrollView(
              child: Form(
                key: form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSelectField(
                      key: const ValueKey('filter-daerah'),
                      label: 'Daerah',
                      value: daerah,
                      options: daerahOptions,
                      onChanged: (v) => setDialogState(() => daerah = v),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Rentang harga mulai',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Berdasarkan pilihan layanan termurah pada setiap jasa.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.inkSoft,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('filter-minimum'),
                      initialValue: minimum,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga minimum (opsional)',
                        prefixText: 'Rp ',
                      ),
                      onChanged: (v) => minimum = v,
                      validator: (v) =>
                          v == null ||
                              v.trim().isEmpty ||
                              (int.tryParse(v.trim()) != null &&
                                  int.parse(v.trim()) >= 0)
                          ? null
                          : 'Isi angka 0 atau lebih',
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey('filter-maksimum'),
                      initialValue: maksimum,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga maksimum (opsional)',
                        prefixText: 'Rp ',
                      ),
                      onChanged: (v) => maksimum = v,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        final angka = int.tryParse(v.trim());
                        if (angka == null || angka < 0) {
                          return 'Isi angka 0 atau lebih';
                        }
                        if (angka < (int.tryParse(minimum.trim()) ?? 0)) {
                          return 'Maksimum harus sama atau lebih dari minimum';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    AppSelectField(
                      key: const ValueKey('filter-urut'),
                      label: 'Urutkan',
                      value: urut,
                      options: const {
                        'rekomendasi': 'Urutan awal',
                        'nama': 'Nama jasa (A-Z)',
                        'termurah': 'Harga terendah',
                        'termahal': 'Harga tertinggi',
                      },
                      onChanged: (v) => setDialogState(() => urut = v),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _daerah = 'semua';
                        _minimum = null;
                        _maksimum = null;
                        _urut = 'rekomendasi';
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text('Reset filter'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (!form.currentState!.validate()) return;
                      setState(() {
                        _daerah = daerah;
                        _urut = urut;
                        _minimum = int.tryParse(minimum.trim());
                        _maksimum = int.tryParse(maksimum.trim());
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text('Terapkan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _hapus(Talent talent) async {
    if (await konfirmasi(
          context,
          'Hapus jasa?',
          'Jasa beserta ulasan dan favoritnya akan dihapus.',
          aksi: 'Hapus',
        ) &&
        mounted) {
      jalankanAksi(context, () => DemoStore.instance.hapusTalent(talent));
    }
  }

  Widget _menu(Talent t) {
    return AppActionMenu(
      options: const {'edit': 'Edit jasa', 'hapus': 'Hapus jasa'},
      onSelected: (v) {
        if (v == 'edit') {
          Navigator.push(
            context,
            AppRoute(builder: (_) => TambahJasaPage(talent: t)),
          ).then((_) => setState(() {}));
        } else {
          _hapus(t);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: DemoStore.instance,
    builder: (context, _) => _buildPage(context),
  );

  Widget _buildPage(BuildContext context) {
    final talents = _terfilter;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Katalog')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          TextField(
            onChanged: (v) => setState(() => _kata = v),
            decoration: const InputDecoration(
              hintText: 'Cari jasa, talent, atau lokasi',
              prefixIcon: Icon(Icons.search_rounded),

              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${talents.length} jasa ditemukan',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _bukaFilter,
                icon: const Icon(Icons.tune_rounded),
                label: Text(
                  _jumlahFilter == 0 ? 'Filter' : 'Filter ($_jumlahFilter)',
                ),
              ),
            ],
          ),
          if (_jumlahFilter > 0) ...[
            const SizedBox(height: 12),
            Text(
              [
                if (_daerah != 'semua') _daerah,
                if (_minimum != null) 'Mulai Rp $_minimum',
                if (_maksimum != null) 'Maks. Rp $_maksimum',
                if (_urut != 'rekomendasi')
                  _urut == 'termurah'
                      ? 'Harga terendah'
                      : _urut == 'termahal'
                      ? 'Harga tertinggi'
                      : 'Nama jasa (A-Z)',
              ].join(' | '),
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Column(
            key: ValueKey('$_kata-${talents.map((t) => t.id).join(',')}'),
            children: [
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
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TalentCard(
                      talent: t,
                      menu:
                          DemoStore.instance.isPenyedia &&
                              t.ownerId == DemoStore.instance.pengguna?.id
                          ? _menu(t)
                          : null,
                      isFavorit: DemoStore.instance.favorit.contains(t.id),
                      onToggleFavorit: () =>
                          DemoStore.instance.toggleFavorit(t.id),
                      onTap: () => Navigator.push(
                        context,
                        AppRoute(builder: (_) => DetailJasaPage(talent: t)),
                      ),
                      onOrderTap: DemoStore.instance.isPencari
                          ? () => Navigator.push(
                              context,
                              AppRoute(builder: (_) => OrderPage(talent: t)),
                            )
                          : null,
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
