import 'package:flutter/material.dart';

import '../../../core/data/demo_store.dart';
import '../../../core/models/statistik_penyedia.dart';
import '../../../core/theme/app_colors.dart';

/// Ringkasan usaha untuk akun penyedia. Tidak menampilkan apa pun untuk role lain.
class DashboardPenyedia extends StatelessWidget {
  const DashboardPenyedia({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        if (!store.isPenyedia) return const SizedBox.shrink();
        final data = store.statistikPenyedia();
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'USAHAMU',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.4,
                      color: AppColors.inkSoft,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Performa jasamu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _ringkasan(data),
                  const SizedBox(height: 28),
                  _judul('Pembelian per jasa'),
                  _pembelianPerJasa(data),
                  const SizedBox(height: 28),
                  _judul('Sebaran rating'),
                  _sebaranRating(data),
                  const SizedBox(height: 28),
                  _judul('Ulasan terbaru'),
                  _ulasanTerbaru(store, data),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _judul(String teks) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(teks, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  Widget _ringkasan(StatistikPenyedia data) => Row(
    children: [
      Expanded(child: _angka('${data.totalDibeli}', 'Kali dibeli')),
      const SizedBox(width: 12),
      Expanded(
        child: _angka(
          data.jumlahUlasan == 0 ? '-' : data.rating.toStringAsFixed(1),
          'Rating rata-rata',
          bintang: data.jumlahUlasan > 0,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(child: _angka('${data.jumlahUlasan}', 'Ulasan')),
    ],
  );

  Widget _angka(String nilai, String label, {bool bintang = false}) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    nilai,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (bintang) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: AppColors.star,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.inkSoft),
            ),
          ],
        ),
      );

  Widget _pembelianPerJasa(StatistikPenyedia data) {
    if (data.perJasa.isEmpty) {
      return const _Kosong(
        'Belum ada jasa. Tambahkan jasa untuk mulai dibeli.',
      );
    }
    final terbanyak = data.perJasa.fold<int>(
      0,
      (m, j) => j.terbeli > m ? j.terbeli : m,
    );
    return Column(
      children: [
        for (final j in data.perJasa)
          _Batang(
            label: j.talent.bidang,
            nilai: j.terbeli,
            maksimum: terbanyak,
            lebarLabel: 128,
          ),
      ],
    );
  }

  Widget _sebaranRating(StatistikPenyedia data) {
    if (data.jumlahUlasan == 0) {
      return const _Kosong('Belum ada ulasan.');
    }
    final terbanyak = data.sebaranBintang.fold<int>(0, (m, n) => n > m ? n : m);
    return Column(
      children: [
        for (var bintang = 5; bintang >= 1; bintang--)
          _Batang(
            label: '$bintang bintang',
            nilai: data.sebaranBintang[bintang - 1],
            maksimum: terbanyak,
            lebarLabel: 72,
          ),
      ],
    );
  }

  Widget _ulasanTerbaru(DemoStore store, StatistikPenyedia data) {
    if (data.ulasanTerbaru.isEmpty) {
      return const _Kosong('Belum ada ulasan.');
    }
    return Column(
      children: [
        for (final r in data.ulasanTerbaru)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: AppColors.star,
                    ),
                    Text(
                      '${r.rating}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.namaUser(r.userId),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        r.komentar,
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Kosong extends StatelessWidget {
  final String teks;
  const _Kosong(this.teks);
  @override
  Widget build(BuildContext context) =>
      Text(teks, style: const TextStyle(color: AppColors.inkSoft));
}

/// Batang horizontal satu warna. Angka selalu tertulis di ujung batang.
class _Batang extends StatelessWidget {
  final String label;
  final int nilai;
  final int maksimum;
  final double lebarLabel;
  const _Batang({
    required this.label,
    required this.nilai,
    required this.maksimum,
    required this.lebarLabel,
  });

  @override
  Widget build(BuildContext context) {
    final rasio = maksimum == 0 ? 0.0 : nilai / maksimum;
    return Semantics(
      label: '$label: $nilai',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            SizedBox(
              width: lebarLabel,
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: AppColors.inkSoft),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) => Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.track,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Container(
                      height: 10,
                      width: c.maxWidth * rasio,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 28,
              child: Text(
                '$nilai',
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
