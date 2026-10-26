import 'package:flutter/material.dart';
import '../talent.dart';

class OrderPage extends StatefulWidget {
  final Talent talent;

  const OrderPage({super.key, required this.talent});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  String _paket = 'Standard';
  String _metode = 'BCA';
  bool _setuju = false;

  // Perhitungan biaya. Harga paket dari Talent, sama dengan halaman Detail.
  int get _harga => widget.talent.hargaPaket(_paket);
  int get _biayaLayanan => (_harga * 0.05).round();
  int get _total => _harga + _biayaLayanan;

  String? _wajib(String? nilai) {
    if (nilai == null || nilai.trim().isEmpty) {
      return 'Kolom ini wajib diisi';
    }
    return null;
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  void _kirim() {
    if (!_formKey.currentState!.validate()) return;

    if (!_setuju) {
      _tampilkanPesan('Centang persetujuan untuk melanjutkan.');
      return;
    }

    _tampilkanPesan(
        'Pesanan ${widget.talent.nama} (Paket $_paket) berhasil dikirim. Total Rp $_total.');
  }

  // Satu baris rincian biaya: label di kiri, nilai di kanan
  Widget _baris(String label, String nilai, {bool tebal = false}) {
    final gaya = tebal ? const TextStyle(fontWeight: FontWeight.bold) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: gaya)),
          Text(nilai, style: gaya),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    final talent = widget.talent;

    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Konfirmasi & Pesan Jasa', style: tema.headlineSmall),
          const SizedBox(height: 16),

          // ── Ringkasan pesanan ──
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ringkasan Pesanan', style: tema.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(child: Text(talent.nama[0])),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Talent: ${talent.nama}'),
                            Text('Jasa: ${talent.bidang}'),
                            Text('Paket: $_paket'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _baris('Jasa Paket $_paket', 'Rp $_harga'),
                  _baris('Biaya Layanan Platform (5%)', 'Rp $_biayaLayanan'),
                  const Divider(),
                  _baris('Total Pembayaran', 'Rp $_total', tebal: true),
                  const SizedBox(height: 8),
                  const Text('Estimasi selesai: 2 hari kerja setelah brief diterima'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Form ──
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Data Pemesan', style: tema.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap *',
                    hintText: 'Contoh: Dinda Rahayu',
                    border: OutlineInputBorder(),
                  ),
                  validator: _wajib,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Email *',
                    hintText: 'Contoh: dinda@email.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: (nilai) {
                    if (nilai == null || nilai.trim().isEmpty) {
                      return 'Email wajib diisi';
                    }
                    if (!nilai.contains('@')) {
                      return 'Format email belum benar';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Nomor WhatsApp *',
                    hintText: 'Contoh: 08123456789',
                    border: OutlineInputBorder(),
                  ),
                  validator: _wajib,
                ),

                const SizedBox(height: 24),
                Text('Detail Pesanan', style: tema.titleMedium),
                const SizedBox(height: 8),
                const Text('Pilih Paket *'),
                DropdownButton<String>(
                  value: _paket,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'Basic', child: Text('Paket Basic')),
                    DropdownMenuItem(value: 'Standard', child: Text('Paket Standard')),
                    DropdownMenuItem(value: 'Premium', child: Text('Paket Premium')),
                  ],
                  onChanged: (nilai) {
                    if (nilai != null) {
                      setState(() {
                        _paket = nilai;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Brief Proyek / Catatan untuk Talent *',
                    hintText: 'Jelaskan tema, gaya yang diinginkan, dan referensi.',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: _wajib,
                ),

                const SizedBox(height: 24),
                Text('Metode Pembayaran', style: tema.titleMedium),
                RadioGroup<String>(
                  groupValue: _metode,
                  onChanged: (nilai) {
                    if (nilai != null) {
                      setState(() {
                        _metode = nilai;
                      });
                    }
                  },
                  child: const Column(
                    children: [
                      RadioListTile<String>(
                        value: 'BCA',
                        title: Text('Transfer Bank BCA'),
                      ),
                      RadioListTile<String>(
                        value: 'GoPay',
                        title: Text('GoPay'),
                      ),
                      RadioListTile<String>(
                        value: 'DANA',
                        title: Text('DANA'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _setuju,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                      'Saya menyetujui Syarat & Ketentuan layanan ini, termasuk kebijakan revisi dan refund *'),
                  onChanged: (nilai) {
                    setState(() {
                      _setuju = nilai ?? false;
                    });
                  },
                ),

                const SizedBox(height: 16),
                Text(
                  'Total yang akan dibayar: Rp $_total',
                  style: tema.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _kirim,
                  child: const Text('Konfirmasi & Bayar Sekarang'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Kembali ke Halaman Jasa'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
