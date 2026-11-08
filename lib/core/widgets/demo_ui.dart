import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../models/pesanan.dart';
import '../data/demo_store.dart';

const statusLabels = {
  'menunggu_pembayaran': 'Menunggu pembayaran',
  'dibayar': 'Dibayar',
  'dikirim': 'Selesai dikerjakan',
  'menunggu_admin': 'Menunggu admin',
  'selesai': 'Selesai',
  'direfund': 'Direfund',
  'dibatalkan': 'Dibatalkan',
};

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});
  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'selesai' => const Color(0xFF187449),
      'direfund' || 'dibatalkan' => const Color(0xFFAD3232),
      'dibayar' => AppColors.primary,
      'dikirim' => const Color(0xFF7442A6),
      _ => const Color(0xFF825600),
    };
    final icon = switch (status) {
      'selesai' => Icons.check_circle_outline_rounded,
      'direfund' => Icons.undo_rounded,
      'dibatalkan' => Icons.cancel_outlined,
      'dibayar' => Icons.verified_outlined,
      'dikirim' => Icons.task_alt_rounded,
      _ => Icons.schedule_rounded,
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                statusLabels[status] ?? status,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void pesanInfo(BuildContext context, String pesan) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
}

bool jalankanAksi(BuildContext context, VoidCallback aksi) {
  try {
    aksi();
    return true;
  } on StateError catch (e) {
    pesanInfo(context, e.message);
    return false;
  }
}

Future<bool> konfirmasi(
  BuildContext context,
  String judul,
  String pesan, {
  String aksi = 'Lanjutkan',
}) async {
  return await showDialog<bool>(
        animationStyle: AnimationStyle.noAnimation,
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(judul),
          content: Text(pesan),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(aksi),
            ),
          ],
        ),
      ) ??
      false;
}

Future<String?> mintaTeks(
  BuildContext context,
  String judul, {
  bool wajib = false,
  String nilaiAwal = '',
}) {
  var nilai = nilaiAwal;
  final form = GlobalKey<FormState>();
  return showDialog<String>(
    animationStyle: AnimationStyle.noAnimation,
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(judul),
      content: Form(
        key: form,
        child: TextFormField(
          initialValue: nilaiAwal,
          maxLines: 3,
          onChanged: (v) => nilai = v,
          validator: (v) => wajib && (v == null || v.trim().isEmpty)
              ? 'Kolom ini wajib diisi'
              : null,
          decoration: const InputDecoration(labelText: 'Catatan'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            if (form.currentState!.validate()) Navigator.pop(ctx, nilai);
          },
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
}

Future<void> lihatStatusPembayaran(BuildContext context, Pesanan order) async {
  String status;
  try {
    status = DemoStore.instance.cekPembayaran(order);
  } on StateError catch (e) {
    pesanInfo(context, e.message);
    return;
  }
  final diterima = status == 'dibayar';
  await showDialog<void>(
    animationStyle: AnimationStyle.noAnimation,
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      constraints: const BoxConstraints(maxWidth: 520),
      title: const Text('Status pembayaran'),
      content: SizedBox(
        width: 472,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusBadge(status: status),
            const SizedBox(height: 20),
            Text(
              diterima
                  ? 'Pembayaran sudah diterima.'
                  : status == 'menunggu_pembayaran'
                  ? 'Pembayaran belum diterima. Silakan lanjutkan pembayaran.'
                  : 'Status pembayaran telah diperbarui.',
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              order.namaJasa,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Total: Rp ${order.total}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
}
