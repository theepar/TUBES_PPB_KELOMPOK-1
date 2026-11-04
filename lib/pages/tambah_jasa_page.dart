import 'package:flutter/material.dart';

import '../talent_data.dart';
import '../talent.dart';
import '../utils/app_colors.dart';

class TambahJasaPage extends StatefulWidget {
  final Talent? talent;

  const TambahJasaPage({super.key, this.talent});

  @override
  State<TambahJasaPage> createState() => _TambahJasaPageState();
}

class _TambahJasaPageState extends State<TambahJasaPage> {
  final _formKey = GlobalKey<FormState>();
  late final _bidang = TextEditingController(text: widget.talent?.bidang);
  late final _harga = TextEditingController(
    text: widget.talent?.hargaMulai.toString(),
  );
  late final _deskripsi = TextEditingController(text: widget.talent?.deskripsi);
  late final _portfolio = TextEditingController(
    text: widget.talent?.portfolioUrl,
  );

  bool get _edit => widget.talent != null;

  @override
  void dispose() {
    _bidang.dispose();
    _harga.dispose();
    _deskripsi.dispose();
    _portfolio.dispose();
    super.dispose();
  }

  String? _wajib(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final link = _portfolio.text.trim();
    final harga = int.parse(_harga.text.trim());

    if (_edit) {
      final i = daftarTalent.indexWhere((x) => x.id == widget.talent!.id);
      daftarTalent[i] = widget.talent!.copyWith(
        bidang: _bidang.text.trim(),
        hargaMulai: harga,
        deskripsi: _deskripsi.text.trim(),
        portfolioUrl: link.isEmpty ? null : link,
      );
    } else {
      daftarTalent.add(
        Talent(
          id: 'baru-${DateTime.now().microsecondsSinceEpoch}',
          nama: 'Saya',
          bidang: _bidang.text.trim(),
          hargaMulai: harga,
          rating: 0,
          jumlahUlasan: 0,
          jumlahOrder: 0,
          deskripsi: _deskripsi.text.trim(),
          portfolioUrl: link.isEmpty ? null : link,
        ),
      );
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_edit ? 'Jasa diperbarui' : 'Jasa ditambahkan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_edit ? 'Edit Jasa' : 'Tambah Jasa')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _bidang,
                  decoration: const InputDecoration(
                    labelText: 'Nama jasa *',
                    hintText: 'Contoh: Edit Video Pendek',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _wajib(v, 'Nama jasa'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _harga,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Harga mulai (Basic) *',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final angka = int.tryParse((v ?? '').trim());
                    if (angka == null || angka <= 0) {
                      return 'Harga harus angka lebih dari 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _deskripsi,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi *',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _wajib(v, 'Deskripsi'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _portfolio,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Link portfolio (opsional)',
                    hintText: 'https://...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return null;
                    if (!t.startsWith('http://') && !t.startsWith('https://')) {
                      return 'Link harus diawali http:// atau https://';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _simpan,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
