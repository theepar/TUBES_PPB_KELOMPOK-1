import 'package:flutter/material.dart';

import '../../../core/models/talent.dart';
import '../../../core/models/paket_jasa.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/demo_store.dart';
import '../../../core/widgets/demo_ui.dart';

class TambahJasaPage extends StatefulWidget {
  final Talent? talent;
  const TambahJasaPage({super.key, this.talent});
  @override
  State<TambahJasaPage> createState() => _TambahJasaPageState();
}

class _PaketInput {
  final TextEditingController nama;
  final TextEditingController harga;
  _PaketInput({PaketJasa? paket})
    : nama = TextEditingController(text: paket?.nama),
      harga = TextEditingController(text: paket?.harga.toString());
  void dispose() {
    nama.dispose();
    harga.dispose();
  }
}

class _TambahJasaPageState extends State<TambahJasaPage> {
  final _formKey = GlobalKey<FormState>();
  late final _bidang = TextEditingController(text: widget.talent?.bidang);
  late final _deskripsi = TextEditingController(text: widget.talent?.deskripsi);
  late final _portfolio = TextEditingController(
    text: widget.talent?.portfolioUrl,
  );
  late final List<_PaketInput> _paket = widget.talent == null
      ? [_PaketInput()]
      : widget.talent!.paketLayanan.map((p) => _PaketInput(paket: p)).toList();
  bool get _edit => widget.talent != null;

  @override
  void dispose() {
    _bidang.dispose();
    _deskripsi.dispose();
    _portfolio.dispose();
    for (final input in _paket) {
      input.dispose();
    }
    super.dispose();
  }

  String? _wajib(String? value, String label) =>
      value == null || value.trim().isEmpty ? '$label wajib diisi' : null;

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    final store = DemoStore.instance;
    final link = _portfolio.text.trim();
    final pilihan = List<PaketJasa>.unmodifiable(
      _paket.map(
        (p) => PaketJasa(
          nama: p.nama.text.trim(),
          harga: int.parse(p.harga.text.trim()),
        ),
      ),
    );
    final talent = _edit
        ? widget.talent!.copyWith(
            bidang: _bidang.text.trim(),
            lokasi: store.pengguna!.lokasi,
            deskripsi: _deskripsi.text.trim(),
            paketLayanan: pilihan,
            portfolioUrl: link.isEmpty ? null : link,
            hapusPortfolio: link.isEmpty,
          )
        : Talent(
            id: store.idBaru('jasa'),
            ownerId: store.pengguna!.id,
            nama: store.pengguna!.nama,
            bidang: _bidang.text.trim(),
            lokasi: store.pengguna!.lokasi,
            paketLayanan: pilihan,
            rating: 0,
            jumlahUlasan: 0,
            jumlahOrder: 0,
            deskripsi: _deskripsi.text.trim(),
            portfolioUrl: link.isEmpty ? null : link,
          );
    if (!jalankanAksi(context, () => store.simpanTalent(talent))) return;
    Navigator.pop(context);
    pesanInfo(context, _edit ? 'Jasa diperbarui' : 'Jasa ditambahkan');
  }

  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    if (!store.isPenyedia ||
        (_edit && widget.talent!.ownerId != store.pengguna?.id)) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kelola Jasa')),
        body: const Center(child: Text('Halaman khusus penyedia pemilik jasa')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(_edit ? 'Edit Jasa' : 'Tambah Jasa')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Informasi layanan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        key: const ValueKey('jasa-nama'),
                        controller: _bidang,
                        decoration: const InputDecoration(
                          labelText: 'Nama jasa',
                          hintText: 'Contoh: Tutor bahasa Inggris',
                        ),
                        validator: (v) => _wajib(v, 'Nama jasa'),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    store.pengguna!.lokasi,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Mengikuti lokasi profilmu',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.inkSoft,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const ValueKey('jasa-deskripsi'),
                        controller: _deskripsi,
                        minLines: 4,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                          alignLabelWithHint: true,
                        ),
                        validator: (v) => _wajib(v, 'Deskripsi'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const ValueKey('jasa-portfolio'),
                        controller: _portfolio,
                        keyboardType: TextInputType.url,
                        decoration: const InputDecoration(
                          labelText: 'Link portfolio (opsional)',
                          hintText: 'https://...',
                        ),
                        validator: (value) {
                          final text = (value ?? '').trim();
                          if (text.isEmpty) return null;
                          final uri = Uri.tryParse(text);
                          return uri == null ||
                                  !['http', 'https'].contains(uri.scheme) ||
                                  uri.host.isEmpty
                              ? 'Isi alamat http:// atau https:// yang valid'
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Pilihan layanan & harga',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tambahkan satu atau beberapa pilihan layanan. Nama dan harga kamu tentukan sendiri.',
                        style: TextStyle(color: AppColors.inkSoft, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      for (var i = 0; i < _paket.length; i++)
                        Padding(
                          key: ObjectKey(_paket[i]),
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Pilihan ${i + 1}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Hapus pilihan ${i + 1}',
                                      onPressed: _paket.length == 1
                                          ? null
                                          : () {
                                              final input = _paket[i];
                                              setState(
                                                () => _paket.remove(input),
                                              );
                                              input.dispose();
                                            },
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  key: ValueKey('paket-nama-$i'),
                                  controller: _paket[i].nama,
                                  decoration: const InputDecoration(
                                    labelText: 'Nama pilihan layanan',
                                    hintText: 'Contoh: Sesi 60 menit',
                                  ),
                                  validator: (value) {
                                    final wajib = _wajib(value, 'Nama pilihan');
                                    if (wajib != null) return wajib;
                                    return _paket
                                                .where(
                                                  (p) =>
                                                      p.nama.text
                                                          .trim()
                                                          .toLowerCase() ==
                                                      value!
                                                          .trim()
                                                          .toLowerCase(),
                                                )
                                                .length >
                                            1
                                        ? 'Nama pilihan tidak boleh sama'
                                        : null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  key: ValueKey('paket-harga-$i'),
                                  controller: _paket[i].harga,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Harga',
                                    prefixText: 'Rp ',
                                  ),
                                  validator: (value) {
                                    final harga = int.tryParse(
                                      (value ?? '').trim(),
                                    );
                                    return harga == null || harga <= 0
                                        ? 'Harga harus angka lebih dari 0'
                                        : null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: () =>
                            setState(() => _paket.add(_PaketInput())),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah pilihan layanan'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _simpan, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
