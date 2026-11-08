import 'package:flutter/material.dart';

import '../models/talent.dart';
import '../theme/app_colors.dart';

class TalentCard extends StatelessWidget {
  final Talent talent;
  final VoidCallback? onTap;
  final VoidCallback? onOrderTap;
  final Widget? menu;
  final bool isFavorit;
  final VoidCallback? onToggleFavorit;

  const TalentCard({
    super.key,
    required this.talent,
    this.onTap,
    this.onOrderTap,
    this.menu,
    this.isFavorit = false,
    this.onToggleFavorit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      talent.nama.isEmpty ? '?' : talent.nama[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      talent.nama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ),
                  if (onToggleFavorit != null)
                    IconButton(
                      tooltip: isFavorit ? 'Hapus favorit' : 'Tambah favorit',
                      onPressed: onToggleFavorit,
                      icon: Icon(
                        isFavorit ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.primary,
                      ),
                    ),
                  ?menu,
                ],
              ),
              const SizedBox(height: 16),
              Text(
                talent.bidang,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.inkSoft,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      talent.lokasi,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${talent.jumlahOrder} pesanan',
                style: const TextStyle(fontSize: 12, color: AppColors.inkSoft),
              ),
              const Divider(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mulai dari',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.inkSoft,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${talent.hargaMulai}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onOrderTap != null) ...[
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: onOrderTap,
                      child: const Text('Pesan'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
