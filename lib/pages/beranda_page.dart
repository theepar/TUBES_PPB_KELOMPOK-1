import 'package:flutter/material.dart';
import 'katalog_page.dart';
import 'tambah_jasa_page.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('SewaSkill')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Temukan Ahlinya, Selesaikan Proyekmu',
              style: tema.headlineMedium),
          const SizedBox(height: 8),
          const Text(
            'SewaSkill menghubungkan kamu dengan talent terverifikasi untuk edit video, desain, koding, dan penulisan konten.',
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KatalogPage()),
              );
            },
            child: const Text('Cari Talent'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TambahJasaPage()),
              );
            },
            child: const Text('Daftarkan Jasa'),
          ),
          const SizedBox(height: 32),
          Text('Kategori Jasa Populer', style: tema.titleLarge),
          const SizedBox(height: 8),
          const _KategoriCard(
            judul: 'Edit Video',
            deskripsi: 'Video pendek untuk Reels, TikTok, dan Shorts.',
          ),
          const _KategoriCard(
            judul: 'Desain Thumbnail',
            deskripsi: 'Thumbnail YouTube yang menarik klik.',
          ),
          const _KategoriCard(
            judul: 'Tutor Koding',
            deskripsi: 'Belajar Python, HTML, dan JavaScript dari praktisi.',
          ),
          const _KategoriCard(
            judul: 'Penulisan Konten',
            deskripsi: 'Artikel SEO, caption, dan copywriting.',
          ),
          const SizedBox(height: 32),
          Text('Mengapa SewaSkill?', style: tema.titleLarge),
          const SizedBox(height: 8),
          const _Poin('500+ Talent Terverifikasi'),
          const _Poin('Rating & Review Transparan'),
          const _Poin('Harga Terjangkau, Mulai dari Rp 25.000'),
          const _Poin('Proses Order Mudah & Cepat'),
          const SizedBox(height: 32),
          Text('Apa Kata Mereka?', style: tema.titleLarge),
          const SizedBox(height: 8),
          const _TestimoniCard(
            isi:
                'Hasil editan videonya langsung bikin akun saya naik engagement. Komunikasinya cepat.',
            nama: 'Dinda R., pemilik brand lokal',
          ),
          const _TestimoniCard(
            isi:
                'Revisi dilayani dengan sabar dan harganya terjangkau untuk kualitas sebagus ini.',
            nama: 'Andi K., kreator konten kuliner',
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'SewaSkill. Hak Cipta Dilindungi.\nPlatform Jasa Freelance Mikro untuk Generasi Digital Indonesia',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _KategoriCard extends StatelessWidget {
  final String judul;
  final String deskripsi;

  const _KategoriCard({required this.judul, required this.deskripsi});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(judul, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(deskripsi),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KatalogPage()),
                );
              },
              child: const Text('Lihat Jasa'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Poin extends StatelessWidget {
  final String teks;

  const _Poin(this.teks);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle),
          const SizedBox(width: 8),
          Expanded(child: Text(teks)),
        ],
      ),
    );
  }
}

class _TestimoniCard extends StatelessWidget {
  final String isi;
  final String nama;

  const _TestimoniCard({required this.isi, required this.nama});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('"$isi"'),
            const SizedBox(height: 8),
            Text('— $nama'),
          ],
        ),
      ),
    );
  }
}
