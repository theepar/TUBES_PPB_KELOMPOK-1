import 'package:flutter/material.dart';

import '../../../core/models/pesanan.dart';
import '../../../core/data/demo_store.dart';
import '../../../core/widgets/demo_ui.dart';
import '../../../core/widgets/choice_pill.dart';
import '../../../core/theme/app_colors.dart';

class PembayaranPage extends StatefulWidget {
  final Pesanan order;
  const PembayaranPage({super.key, required this.order});
  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  String? _pesan;
  bool _berhasil = true;
  void _bayar() {
    if (!_berhasil) {
      setState(
        () => _pesan = 'Pembayaran gagal. Pesanan tetap menunggu pembayaran dan dapat dicoba lagi.',
      );
      return;
    }
    if (jalankanAksi(context, () => DemoStore.instance.bayar(widget.order))) {
      setState(() => _pesan = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final lunas = [
      'dibayar',
      'dikirim',
      'menunggu_admin',
      'selesai',
    ].contains(order.status);
    final menunggu = order.status == 'menunggu_pembayaran';
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        lunas
                            ? Icons.check_circle_outline_rounded
                            : Icons.account_balance_wallet_outlined,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    lunas
                        ? 'Pembayaran berhasil'
                        : menunggu
                        ? 'Selesaikan pembayaran'
                        : 'Pembayaran ditutup',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    order.namaJasa,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paket ${order.paket} | ${order.metode}',
                    style: const TextStyle(color: AppColors.inkSoft),
                  ),
                  const Divider(height: 40),
                  const Text(
                    'Total pembayaran',
                    style: TextStyle(color: AppColors.inkSoft),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${order.total}',
                    style: const TextStyle(
                      fontSize: 32,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  StatusBadge(status: order.status),
                  if (_pesan != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF2EF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _pesan!,
                        style: const TextStyle(
                          color: Color(0xFFAD3232),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  if (menunggu) ...[
                    FilledButton(
                      onPressed: _bayar,
                      child: const Text('Bayar sekarang'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Kembali ke riwayat'),
                    ),
                  ] else
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Kembali ke riwayat'),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Simulasi pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pilih hasil untuk tombol Bayar sekarang. Tidak ada uang yang ditagih.',
                  style: TextStyle(color: AppColors.inkSoft, height: 1.5),
                ),
                if (menunggu) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ChoicePill(
                          label: 'Berhasil',
                          selected: _berhasil,
                          onPressed: () => setState(() => _berhasil = true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ChoicePill(
                          label: 'Gagal',
                          selected: !_berhasil,
                          onPressed: () => setState(() => _berhasil = false),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => lihatStatusPembayaran(context, order),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Cek status pembayaran'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
