import 'package:flutter/material.dart';

import '../../../core/models/talent.dart';
import '../../../core/theme/app_colors.dart';

class RingkasanBeranda extends StatefulWidget {
  final List<Talent> talents;

  const RingkasanBeranda({super.key, required this.talents});

  @override
  State<RingkasanBeranda> createState() => _RingkasanBerandaState();
}

class _RingkasanBerandaState extends State<RingkasanBeranda> {
  int _heroTab = 0; // 0 = Harga, 1 = Rating

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.track),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tombolTab('Harga', 0),
                    const SizedBox(width: 8),
                    _tombolTab('Rating', 1),
                  ],
                ),
                const SizedBox(height: 12),
                _buildHeroAngka(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildStatsRow(),
      ],
    );
  }

  Widget _tombolTab(String label, int index) {
    final terpilih = _heroTab == index;

    return ChoiceChip(
      label: Text(label),
      selected: terpilih,
      showCheckmark: false,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      side: BorderSide(color: terpilih ? AppColors.primary : AppColors.track),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: terpilih ? FontWeight.bold : FontWeight.w500,
        color: terpilih ? Colors.white : AppColors.ink,
      ),
      onSelected: (_) {
        setState(() {
          _heroTab = index;
        });
      },
    );
  }

  Widget _buildHeroAngka() {
    final list = widget.talents;
    const gaya = TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      color: AppColors.primary,
      height: 1.1,
    );

    if (list.isEmpty) {
      return const Text('0', style: gaya);
    }

    final bool isHarga = _heroTab == 0;
    final String nilaiStr;
    final String keterangan;

    if (isHarga) {
      int minHarga = list.first.hargaMulai;
      for (final talent in list) {
        if (talent.hargaMulai < minHarga) {
          minHarga = talent.hargaMulai;
        }
      }
      nilaiStr = minHarga.toString();
      keterangan = 'Rupiah, harga mulai dari';
    } else {
      double totalRating = 0;
      for (final talent in list) {
        totalRating += talent.rating;
      }
      final avgRating = totalRating / list.length;
      nilaiStr = avgRating.toStringAsFixed(1);
      keterangan = 'Rating rata-rata';
    }

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(nilaiStr, style: gaya),
        ),
        const SizedBox(height: 2),
        Text(
          keterangan,
          style: const TextStyle(fontSize: 13, color: AppColors.inkSoft),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final list = widget.talents;
    int order = 0;
    int ulasan = 0;
    for (final talent in list) {
      order += talent.jumlahOrder;
      ulasan += talent.jumlahUlasan;
    }

    return Row(
      children: [
        Expanded(child: _buildStatItem('Talent', '${list.length}')),
        const SizedBox(width: 8),
        Expanded(child: _buildStatItem('Order', '$order')),
        const SizedBox(width: 8),
        Expanded(child: _buildStatItem('Ulasan', '$ulasan')),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.track),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11.5, color: AppColors.inkSoft),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
