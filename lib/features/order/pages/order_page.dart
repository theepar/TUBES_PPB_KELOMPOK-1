import '../../../app/app_route.dart';

import 'package:flutter/material.dart';

import '../../../core/models/talent.dart';
import '../../../core/data/demo_store.dart';
import '../../../core/widgets/demo_ui.dart';
import '../../../core/widgets/app_select.dart';
import 'pembayaran_page.dart';
import 'riwayat_order_page.dart';

class OrderPage extends StatefulWidget {
  final Talent talent;
  final String? paket;

  const OrderPage({super.key, required this.talent, this.paket});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  late String _paket = widget.paket ?? widget.talent.paketLayanan.first.nama;
  String _metode = 'BCA';
  String _catatan = '';

  int get _harga => widget.talent.hargaPaket(_paket);
  int get _biayaLayanan => (_harga * 0.05).round();
  int get _total => _harga + _biayaLayanan;

  String? _wajib(String? nilai) {
    if (nilai == null || nilai.trim().isEmpty) {
      return 'Kolom ini wajib diisi';
    }
    return null;
  }

  Future<void> _kirim() async {
    if (!_formKey.currentState!.validate()) return;
    final store = DemoStore.instance;
    try {
      final order = store.buatOrder(widget.talent, _paket, _catatan, _metode);
      await Navigator.push(
        context,
        AppRoute(builder: (_) => PembayaranPage(order: order)),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        AppRoute(builder: (_) => const RiwayatOrderPage()),
      );
    } on StateError catch (e) {
      if (mounted) pesanInfo(context, e.message);
    }
  }

  Widget _baris(String label, String nilai, {bool tebal = false}) {
    final gaya = tebal ? const TextStyle(fontWeight: FontWeight.bold) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: gaya)),
          Text(nilai, key: ValueKey(nilai), style: gaya),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;
    final talent = widget.talent;

    if (!DemoStore.instance.isPencari) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order')),
        body: const Center(child: Text('Hanya pencari bisa memesan jasa')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Text('Konfirmasi & Pesan Jasa', style: tema.headlineSmall),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                  const Text(
                    'Estimasi selesai: 2 hari kerja setelah brief diterima',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Data Pemesan', style: tema.titleMedium),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: DemoStore.instance.pengguna?.nama,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap *',
                        hintText: 'Contoh: Dinda Rahayu',
                      ),
                      validator: _wajib,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: DemoStore.instance.pengguna?.email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Alamat Email *',
                        hintText: 'Contoh: dinda@email.com',
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
                      ),
                      validator: _wajib,
                    ),
                    const SizedBox(height: 24),
                    Text('Detail Pesanan', style: tema.titleMedium),
                    const SizedBox(height: 8),
                    const Text('Pilih Paket *'),
                    AppSelectField(
                      label: 'Paket layanan',
                      value: _paket,
                      options: {
                        for (final paket in talent.paketLayanan)
                          paket.nama: paket.nama,
                      },
                      onChanged: (value) => setState(() => _paket = value),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: (v) => _catatan = v,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Brief Proyek / Catatan untuk Talent *',
                        hintText: 'Jelaskan tema, gaya yang diinginkan, dan referensi.',
                        alignLabelWithHint: true,
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kembali ke Halaman Jasa'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
