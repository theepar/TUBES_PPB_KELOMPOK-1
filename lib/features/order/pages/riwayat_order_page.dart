import 'package:flutter/material.dart';

import '../../../core/widgets/demo_ui.dart';
import '../../../core/widgets/choice_pill.dart';
import '../../../core/data/demo_store.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/order_detail_sheet.dart';

class RiwayatOrderPage extends StatefulWidget {
  final bool admin;
  const RiwayatOrderPage({super.key, this.admin = false});
  @override
  State<RiwayatOrderPage> createState() => _RiwayatOrderPageState();
}

class _RiwayatOrderPageState extends State<RiwayatOrderPage> {
  late String _filter = widget.admin ? 'menunggu_admin' : 'semua';
  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.admin ? 'Manajemen Pembelian' : 'Riwayat Order'),
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          if (widget.admin && !store.isAdmin) {
            return const Center(child: Text('Halaman khusus admin'));
          }
          final orders = store.orders.where((o) {
            final milik =
                widget.admin ||
                (store.isPencari && o.buyerId == store.pengguna?.id) ||
                (store.isPenyedia && o.sellerId == store.pengguna?.id);
            return milik &&
                !(store.isPencari && o.disembunyikanBuyer && !widget.admin) &&
                (_filter == 'semua' || o.status == _filter);
          }).toList();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                widget.admin
                    ? 'Tinjau hasil pekerjaan dan keputusan pembeli.'
                    : store.isPenyedia
                    ? 'Pesanan masuk untuk jasamu.'
                    : 'Pantau pesanan dan pembayaranmu.',
                style: const TextStyle(color: AppColors.inkSoft),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final status in ['semua', ...statusLabels.keys])
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ChoicePill(
                          label: status == 'semua'
                              ? 'Semua'
                              : statusLabels[status]!,
                          selected: _filter == status,
                          onPressed: () => setState(() => _filter = status),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (orders.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('Tidak ada pesanan')),
                ),
              for (final order in orders)
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => showModalBottomSheet<void>(
                      sheetAnimationStyle: AnimationStyle.noAnimation,
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (_) =>
                          OrderDetailSheet(order: order, admin: widget.admin),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.namaJasa,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${order.paket} | Rp ${order.total}',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                          Text(
                            '${order.tanggal.day}/${order.tanggal.month}/${order.tanggal.year}',
                            style: const TextStyle(
                              color: AppColors.inkSoft,
                              fontSize: 12,
                            ),
                          ),
                          if (widget.admin)
                            Text(
                              '${store.namaUser(order.buyerId)} - ${store.namaUser(order.sellerId)}',
                            ),
                          const SizedBox(height: 12),
                          StatusBadge(status: order.status),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
