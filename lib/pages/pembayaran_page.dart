import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/currency_formatter.dart';

class PembayaranPage extends StatefulWidget {
  final int total;
  final String namaJasa;
  final String paket;

  const PembayaranPage({
    super.key,
    required this.total,
    required this.namaJasa,
    required this.paket,
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  int _metodeTerpilih = 0;

  static const _metode = [
    _MetodeBayar('QRIS', Icons.qr_code_2_rounded),
    _MetodeBayar(
      'Virtual Account / Transfer Bank',
      Icons.account_balance_rounded,
    ),
    _MetodeBayar('E-Wallet (GoPay / OVO / Dana)', Icons.wallet_rounded),
  ];

  void _simulasiBayar() {
    Navigator.pop(context, true);
  }

  void _tutupPembayaran() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari pembayaran?'),
        content: const Text(
          'Pesanan Anda akan tetap tersimpan di status Menunggu Pembayaran dan bisa dibayar lagi nanti.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Ya, Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ).then((keluar) {
      if (keluar == true && mounted) {
        Navigator.pop(context, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _tutupPembayaran();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _tutupPembayaran,
          ),
          title: const Text(
            'Pembayaran',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.ink,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.track),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rincian Tagihan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _barisPesanan('Jasa', widget.namaJasa),
                    const SizedBox(height: 4),
                    _barisPesanan('Paket', widget.paket),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: AppColors.track),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          formatRupiah(widget.total),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 10),
              ...List.generate(_metode.length, (i) {
                final m = _metode[i];
                final terpilih = _metodeTerpilih == i;
                return GestureDetector(
                  onTap: () => setState(() => _metodeTerpilih = i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: terpilih ? AppColors.skyLight : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: terpilih ? AppColors.primary : AppColors.track,
                        width: terpilih ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          m.icon,
                          size: 22,
                          color: terpilih
                              ? AppColors.primary
                              : AppColors.inkSoft,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            m.label,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: terpilih
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: terpilih
                                  ? AppColors.primary
                                  : AppColors.ink,
                            ),
                          ),
                        ),
                        if (terpilih)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ini adalah simulasi pembayaran. Tekan tombol di bawah untuk menyelesaikan pembayaran.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _simulasiBayar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Bayar Sekarang',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _barisPesanan(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.inkSoft),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class _MetodeBayar {
  final String label;
  final IconData icon;
  const _MetodeBayar(this.label, this.icon);
}
