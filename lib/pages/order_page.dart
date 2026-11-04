import 'dart:math';

import 'package:flutter/material.dart';

import '../models/order_item.dart';
import '../talent.dart';
import '../utils/app_colors.dart';
import '../utils/currency_formatter.dart';
import 'pembayaran_page.dart';

final List<OrderItem> daftarOrder = [];

class OrderPage extends StatefulWidget {
  final Talent talent;
  final VoidCallback? onKembali;

  const OrderPage({super.key, required this.talent, this.onKembali});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String _paketTerpilih = 'Basic';
  final _catatanController = TextEditingController();

  static const _paketList = ['Basic', 'Standard', 'Premium'];

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  int get _hargaTerpilih => widget.talent.hargaPaket(_paketTerpilih);

  void _pesan() {
    if (_catatanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi catatan / instruksi kebutuhan Anda'),
        ),
      );
      return;
    }

    final order = OrderItem(
      id: 'ORD-${Random().nextInt(90000) + 10000}',
      talent: widget.talent,
      namaJasa: widget.talent.bidang,
      buyerName: 'Saya',
      sellerName: widget.talent.nama,
      paket: _paketTerpilih,
      total: _hargaTerpilih,
      catatan: _catatanController.text.trim(),
    );
    daftarOrder.insert(0, order);

    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PembayaranPage(
          total: order.total,
          namaJasa: order.namaJasa,
          paket: order.paket,
        ),
      ),
    ).then((bayarBerhasil) {
      if (bayarBerhasil == true) {
        order.status = 'dibayar';
        order.metodeBayar = 'QRIS (Simulasi)';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            bayarBerhasil == true
                ? 'Pembayaran berhasil! Pesanan sedang diproses.'
                : 'Pesanan tersimpan. Selesaikan pembayaran dari Riwayat Order.',
          ),
        ),
      );

      if (widget.onKembali != null) {
        widget.onKembali!();
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pesan Jasa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.ink,
          ),
        ),
        centerTitle: true,
        leading: widget.onKembali != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.ink),
                onPressed: widget.onKembali,
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.track),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.skyLight,
                    child: Text(
                      widget.talent.nama[0],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.talent.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.talent.bidang,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.inkSoft,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: AppColors.star,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${widget.talent.rating}  •  ${widget.talent.jumlahOrder} order',
                              style: const TextStyle(
                                fontSize: 12,
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
            ),
            const SizedBox(height: 20),

            const Text(
              'Pilih Paket',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            ..._paketList.map((paket) {
              final harga = widget.talent.hargaPaket(paket);
              final terpilih = _paketTerpilih == paket;
              return GestureDetector(
                onTap: () => setState(() => _paketTerpilih = paket),
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
                        terpilih
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: terpilih ? AppColors.primary : AppColors.inkSoft,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Paket $paket',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: terpilih
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: terpilih ? AppColors.primary : AppColors.ink,
                          ),
                        ),
                      ),
                      Text(
                        formatRupiah(harga),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: terpilih
                              ? AppColors.primary
                              : AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            const Text(
              'Catatan / Instruksi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _catatanController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Tuliskan kebutuhan atau instruksi khusus Anda di sini...',
                hintStyle: const TextStyle(
                  color: AppColors.inkSoft,
                  fontSize: 13,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.track),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.track),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.skyLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.skyHaze),
              ),
              child: Row(
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
                    formatRupiah(_hargaTerpilih),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _pesan,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Pesan dan Bayar',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
