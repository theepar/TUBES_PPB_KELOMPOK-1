import '../../../app/app_route.dart';

import 'package:flutter/material.dart';

import '../../../core/models/pengguna.dart';
import '../../../core/models/talent.dart';
import '../../../core/data/talent_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../jasa/pages/detail_jasa_page.dart';
import '../../../core/widgets/choice_pill.dart';
import '../widgets/dashboard_penyedia.dart';

class BerandaPage extends StatefulWidget {
  final Pengguna pengguna;
  final VoidCallback onBukaKatalog;

  const BerandaPage({
    super.key,
    required this.pengguna,
    required this.onBukaKatalog,
  });

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  String _kebutuhan = 'Semua';
  final _dilihat = <String>{};
  String? _terakhirDilihat;

  List<Talent> get _rekomendasi {
    const kataKunci = {
      'Semua': '',
      'Konten video': 'video',
      'Desain': 'desain',
      'Belajar koding': 'koding',
      'Menulis': 'penulisan',
    };
    final hasil = daftarTalent.where((t) {
      if (!t.tampil) return false;
      final cocok = t.bidang.toLowerCase().contains(kataKunci[_kebutuhan]!);
      return cocok;
    }).toList();
    hasil.sort((a, b) => b.rating.compareTo(a.rating));
    return hasil.take(3).toList();
  }

  Future<void> _openDetail(Talent talent) async {
    setState(() {
      _terakhirDilihat = talent.id;
      _dilihat.add(talent.id);
    });
    await Navigator.push(
      context,
      AppRoute(builder: (_) => DetailJasaPage(talent: talent)),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final jam = DateTime.now().hour;
    final waktu = jam < 11
        ? 'pagi'
        : jam < 15
        ? 'siang'
        : jam < 18
        ? 'sore'
        : 'malam';
    final rekomendasi = _rekomendasi;
    Talent? terakhir;
    for (final talent in daftarTalent) {
      if (talent.tampil && talent.id == _terakhirDilihat) terakhir = talent;
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat $waktu,',
                      style: const TextStyle(color: AppColors.inkSoft),
                    ),
                    Text(
                      widget.pengguna.nama,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.pengguna.lokasi,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primary,
                child: Text(
                  widget.pengguna.nama.isEmpty ? '?' : widget.pengguna.nama[0],
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _statistik('${daftarTalent.length}', 'Jasa tersedia'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statistik(
                  '${_dilihat.length}',
                  'Kamu lihat di beranda',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const DashboardPenyedia(),
          _pilihanDaerah(),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1465CE), Color(0xFF2382EB)],
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RUANG UNTUK IDEMU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ide sudah ada.\nCari teman ahlinya.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Dari konten pertama sampai skill baru, mulai dari yang kamu butuhkan.',
                  style: TextStyle(color: Colors.white, height: 1.5),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF1465CE),
                  ),
                  onPressed: widget.onBukaKatalog,
                  child: const Text('Jelajahi jasa'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text(
            'Lagi butuh bantuan apa?',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Pilih kebutuhanmu, kita sesuaikan pilihannya.',
            style: TextStyle(color: AppColors.inkSoft, fontSize: 13),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final kebutuhan in [
                  'Semua',
                  'Konten video',
                  'Desain',
                  'Belajar koding',
                  'Menulis',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoicePill(
                      label: kebutuhan,
                      selected: _kebutuhan == kebutuhan,
                      onPressed: () => setState(() => _kebutuhan = kebutuhan),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Pilihan untukmu',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: widget.onBukaKatalog,
                child: const Text('Lihat semua'),
              ),
            ],
          ),
          Text(
            _kebutuhan == 'Semua'
                ? 'Temukan teman ahli untuk proyek berikutnya.'
                : 'Untuk kebutuhan ${_kebutuhan.toLowerCase()} kamu.',
            style: const TextStyle(color: AppColors.inkSoft, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Column(
            key: ValueKey(_kebutuhan),
            children: [
              if (rekomendasi.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text('Belum ada jasa yang cocok.'),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => setState(() {
                            _kebutuhan = 'Semua';
                          }),
                          child: const Text('Atur ulang pilihan'),
                        ),
                      ],
                    ),
                  ),
                ),
              for (final talent in rekomendasi) _pilihanTalent(talent),
            ],
          ),
          if (terakhir != null) ...[
            const SizedBox(height: 20),
            const Text(
              'Lanjutkan penelusuranmu',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Jasa terakhir yang kamu lihat.',
              style: TextStyle(color: AppColors.inkSoft, fontSize: 13),
            ),
            const SizedBox(height: 12),
            _pilihanTalent(terakhir),
          ],
        ],
      ),
    );
  }

  Widget _statistik(String nilai, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nilai,
            key: ValueKey(nilai),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.inkSoft, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _pilihanDaerah() {
    final kota = widget.pengguna.lokasi.split(',').first.trim();
    final lokal = daftarTalent
        .where(
          (t) =>
              t.tampil &&
              t.ownerId != widget.pengguna.id &&
              t.lokasi.split(',').first.trim().toLowerCase() ==
                  kota.toLowerCase(),
        )
        .take(2)
        .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DI SEKITARMU',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.4,
                color: AppColors.inkSoft,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Talent di $kota',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (lokal.isEmpty) ...[
              const Text(
                'Belum ada talent lain di kotamu. Temukan pilihan dari kota lain.',
                style: TextStyle(color: AppColors.inkSoft, height: 1.5),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: widget.onBukaKatalog,
                child: const Text('Jelajahi talent'),
              ),
            ],
            for (final talent in lokal)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    hoverColor: AppColors.inkSoft.withValues(alpha: 0.08),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    leading: CircleAvatar(child: Text(talent.nama[0])),
                    title: Text(
                      talent.nama,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      talent.bidang,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openDetail(talent),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _pilihanTalent(Talent talent) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetail(talent),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.track,
                foregroundColor: AppColors.ink,
                child: Text(talent.nama.isEmpty ? '?' : talent.nama[0]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      talent.bidang,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      talent.nama,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mulai Rp ${talent.hargaMulai}',
                      style: const TextStyle(
                        color: Color(0xFF1465CE),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.inkSoft),
            ],
          ),
        ),
      ),
    );
  }
}
