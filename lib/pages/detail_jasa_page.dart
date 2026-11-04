import 'package:flutter/material.dart';

import '../models/talent.dart';
import '../utils/app_colors.dart';
import '../utils/currency_formatter.dart';
import 'order_page.dart';

class DetailJasaPage extends StatelessWidget {
  final Talent talent;

  const DetailJasaPage({super.key, required this.talent});

  void _lihatPortfolio(BuildContext context, String url) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Portfolio'),
        content: SelectableText(url),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = talent;
    final punyaPortfolio = t.portfolioUrl != null && t.portfolioUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.ink,
        elevation: 0,
        title: const Text(
          'Detail Jasa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.ink,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            t.bidang,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  t.nama.isNotEmpty ? t.nama.substring(0, 1) : '',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  t.nama,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: AppColors.star),
              const SizedBox(width: 4),
              Text(
                '${t.rating} · ${t.jumlahUlasan} ulasan · ${t.jumlahOrder} order',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.inkSoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            t.deskripsi,
            style: const TextStyle(fontSize: 14, color: AppColors.ink),
          ),
          if (punyaPortfolio) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () => _lihatPortfolio(context, t.portfolioUrl!),
                icon: const Icon(Icons.link_rounded),
                label: const Text('Lihat Portfolio'),
              ),
            ),
          ],
          const SizedBox(height: 20),
          const Text(
            'Harga Paket',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.track),
            ),
            child: Column(
              children: [
                for (final paket in const ['Basic', 'Standard', 'Premium'])
                  ListTile(
                    dense: true,
                    title: Text(paket),
                    trailing: Text(
                      formatRupiah(t.hargaPaket(paket)),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OrderPage(talent: t)),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Pesan',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
