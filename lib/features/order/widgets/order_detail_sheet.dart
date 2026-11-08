import 'package:flutter/material.dart';

import '../../../app/app_route.dart';
import '../../../core/data/demo_store.dart';
import '../../../core/models/pesanan.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/danger_button.dart';
import '../../../core/widgets/demo_ui.dart';
import '../pages/pembayaran_page.dart';

class OrderDetailSheet extends StatelessWidget {
  final Pesanan order;
  final bool admin;
  const OrderDetailSheet({super.key, required this.order, this.admin = false});

  Future<void> _konfirmasiAksi(
    BuildContext context,
    String judul,
    String pesan,
    VoidCallback aksi,
  ) async {
    if (!await konfirmasi(context, judul, pesan)) return;
    if (!context.mounted) return;
    if (jalankanAksi(context, aksi)) Navigator.pop(context);
  }

  Widget _info(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppColors.inkSoft),
      ),
      const SizedBox(height: 8),
      Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );

  Widget _biaya(String label, String value, {bool total = false}) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 3,
        child: Text(
          label,
          style: TextStyle(
            color: total ? AppColors.ink : AppColors.inkSoft,
            fontWeight: total ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        flex: 2,
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: total ? 20 : 15,
            fontWeight: FontWeight.bold,
            color: total ? AppColors.primary : AppColors.ink,
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final buyer = order.buyerId == store.pengguna?.id;
        final seller = order.sellerId == store.pengguna?.id;
        final actions = <Widget>[
          if (buyer && order.status == 'menunggu_pembayaran' && !admin) ...[
            FilledButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  AppRoute(builder: (_) => PembayaranPage(order: order)),
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Bayar sekarang'),
            ),
            TextButton(
              onPressed: () => lihatStatusPembayaran(context, order),
              child: const Text('Cek status pembayaran'),
            ),
            OutlinedButton(
              onPressed: () => _konfirmasiAksi(
                context,
                'Batalkan pesanan?',
                'Pesanan yang belum dibayar akan dibatalkan.',
                () => store.batalkan(order),
              ),
              child: const Text('Batalkan pesanan'),
            ),
          ],
          if (seller && order.status == 'dibayar' && !admin)
            FilledButton(
              onPressed: () async {
                final hasil = await mintaTeks(
                  context,
                  'Tandai selesai (catatan opsional)',
                );
                if (hasil != null &&
                    context.mounted &&
                    jalankanAksi(
                      context,
                      () => store.kirimHasil(order, hasil),
                    )) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Tandai selesai'),
            ),
          if (buyer && order.status == 'dikirim' && !admin) ...[
            FilledButton(
              onPressed: () => _konfirmasiAksi(
                context,
                'Terima hasil pekerjaan?',
                'Pesanan akan diteruskan ke admin untuk persetujuan.',
                () => store.keputusanBuyer(order, true, ''),
              ),
              child: const Text('Pekerjaan diterima'),
            ),
            OutlinedButton(
              onPressed: () async {
                final alasan = await mintaTeks(
                  context,
                  'Alasan komplain',
                  wajib: true,
                );
                if (alasan != null &&
                    context.mounted &&
                    jalankanAksi(
                      context,
                      () => store.keputusanBuyer(order, false, alasan),
                    )) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Ajukan komplain'),
            ),
          ],
          if (order.status == 'menunggu_admin')
            const Text(
              'Menunggu peninjauan admin.',
              style: TextStyle(color: AppColors.inkSoft),
            ),
          if (buyer && order.sudahAkhir && !admin)
            DangerButton(
              onPressed: () => _konfirmasiAksi(
                context,
                'Hapus riwayat?',
                'Riwayat pesanan ini akan dihapus.',
                () => store.hapusOrder(order),
              ),
              label: 'Hapus riwayat',
            ),
          if (admin && store.isAdmin && order.status == 'menunggu_admin') ...[
            FilledButton(
              onPressed: () => _konfirmasiAksi(
                context,
                'Approve pesanan?',
                'Saldo demo Rp ${order.harga} akan masuk ke penyedia.',
                () => store.putuskanOrder(order, true),
              ),
              child: const Text('Approve'),
            ),
            OutlinedButton(
              onPressed: () => _konfirmasiAksi(
                context,
                'Reject pesanan?',
                'Saldo demo Rp ${order.total} akan dikembalikan ke pembeli.',
                () => store.putuskanOrder(order, false),
              ),
              child: const Text('Reject / Refund'),
            ),
          ],
        ];
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Detail pesanan',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              order.id,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.inkSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        tooltip: 'Tutup',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: StatusBadge(status: order.status),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        order.namaJasa,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Paket ${order.paket}',
                        style: const TextStyle(color: AppColors.inkSoft),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _info(
                              'Pembeli',
                              store.namaUser(order.buyerId),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _info(
                              'Penyedia',
                              store.namaUser(order.sellerId),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rincian pembayaran',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _biaya('Harga jasa', 'Rp ${order.harga}'),
                            const SizedBox(height: 14),
                            _biaya(
                              'Biaya layanan (5%)',
                              'Rp ${order.biayaLayanan}',
                            ),
                            const Divider(height: 32),
                            _biaya(
                              'Total pembayaran',
                              'Rp ${order.total}',
                              total: true,
                            ),
                            const SizedBox(height: 20),
                            _info('Metode pembayaran', order.metode),
                            if (order.dibayarPada != null) ...[
                              const SizedBox(height: 16),
                              _info(
                                'Tanggal pembayaran',
                                '${order.dibayarPada!.day}/${order.dibayarPada!.month}/${order.dibayarPada!.year}',
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      _info(
                        'Catatan pesanan',
                        order.catatan.isEmpty
                            ? 'Tidak ada catatan.'
                            : order.catatan,
                      ),
                      if (order.hasil.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _info('Hasil pekerjaan', order.hasil),
                      ],
                      if (order.keputusan.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _info(
                          'Keputusan pembeli',
                          order.keputusan == 'diterima'
                              ? 'Pekerjaan diterima'
                              : 'Mengajukan komplain',
                        ),
                      ],
                      if (order.alasan.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _info('Alasan komplain', order.alasan),
                      ],
                    ],
                  ),
                ),
                if (actions.isNotEmpty) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < actions.length; i++) ...[
                          if (i > 0) const SizedBox(height: 16),
                          actions[i],
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
