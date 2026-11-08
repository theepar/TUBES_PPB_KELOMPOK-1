import '../../../app/app_route.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/talent.dart';
import '../../../core/theme/app_colors.dart';
import '../../order/pages/order_page.dart';
import '../../../core/data/demo_store.dart';
import '../../../core/models/ulasan.dart';
import '../../../core/widgets/demo_ui.dart';
import '../../../core/widgets/app_select.dart';
import '../../../core/widgets/choice_pill.dart';
import '../../../core/data/talent_data.dart';

class DetailJasaPage extends StatefulWidget {
  final Talent talent;

  const DetailJasaPage({super.key, required this.talent});

  @override
  State<DetailJasaPage> createState() => _DetailJasaPageState();
}

class _DetailJasaPageState extends State<DetailJasaPage> {
  String? _paket;

  Future<void> _editUlasan(String talentId, {Ulasan? review}) async {
    var rating = review?.rating ?? 5;
    var komentar = review?.komentar ?? '';
    final form = GlobalKey<FormState>();
    await showDialog<void>(
      animationStyle: AnimationStyle.noAnimation,
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          constraints: const BoxConstraints(maxWidth: 560),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.all(24),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          title: Text(review == null ? 'Tulis ulasan' : 'Edit ulasan'),
          content: SizedBox(
            width: 512,
            child: SingleChildScrollView(
              child: Form(
                key: form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Bagaimana pengalamanmu dengan jasa ini?',
                      style: TextStyle(color: AppColors.inkSoft, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              for (var i = 1; i <= 5; i++)
                                Expanded(
                                  child: Semantics(
                                    selected: i == rating,
                                    child: IconButton(
                                      tooltip: '$i bintang',
                                      style: IconButton.styleFrom(
                                        minimumSize: const Size(48, 52),
                                        padding: const EdgeInsets.all(8),
                                      ),
                                      onPressed: () =>
                                          setState(() => rating = i),
                                      icon: Icon(
                                        i <= rating
                                            ? Icons.star_rounded
                                            : Icons.star_outline_rounded,
                                        color: AppColors.star,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$rating dari 5 bintang',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      initialValue: komentar,
                      minLines: 4,
                      maxLines: 6,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        labelText: 'Komentar',
                        hintText: 'Ceritakan hasil pekerjaan dan pengalamanmu.',
                        alignLabelWithHint: true,
                      ),
                      onChanged: (value) => komentar = value,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Komentar wajib diisi'
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (form.currentState!.validate() &&
                          jalankanAksi(
                            context,
                            () => DemoStore.instance.simpanUlasan(
                              talentId,
                              rating,
                              komentar,
                              id: review?.id,
                            ),
                          )) {
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text(
                      'Simpan ulasan',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _lihatPortfolio(BuildContext context, String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty) {
      pesanInfo(context, 'Alamat portfolio tidak valid');
      return;
    }
    try {
      final terbuka = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
      if (!terbuka && context.mounted) {
        pesanInfo(context, 'Portfolio belum bisa dibuka');
      }
    } catch (_) {
      if (context.mounted) pesanInfo(context, 'Portfolio belum bisa dibuka');
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: DemoStore.instance,
    builder: (context, _) => _buildPage(context),
  );

  Widget _buildPage(BuildContext context) {
    final store = DemoStore.instance;
    final t =
        daftarTalent.where((t) => t.id == widget.talent.id).firstOrNull ??
        widget.talent;
    if (t.paketLayanan.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Jasa')),
        body: const Center(child: Text('Pilihan layanan belum tersedia')),
      );
    }
    final pilihan = t.paketLayanan.firstWhere(
      (p) => p.nama == _paket,
      orElse: () => t.paketLayanan.first,
    );
    final reviews = store.ulasanJasa(t.id);
    final punyaPortfolio = t.portfolioUrl != null && t.portfolioUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        actions: [
          IconButton(
            tooltip: store.favorit.contains(t.id)
                ? 'Hapus favorit'
                : 'Tambah favorit',
            onPressed: () => store.toggleFavorit(t.id),
            icon: Icon(
              store.favorit.contains(t.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
          ),
        ],
      ),
      bottomNavigationBar: store.isPencari
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    AppRoute(
                      builder: (_) => OrderPage(talent: t, paket: pilihan.nama),
                    ),
                  ),
                  child: const Text('Pesan sekarang'),
                ),
              ),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: AppColors.inkSoft,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          t.lokasi,
                          style: const TextStyle(color: AppColors.inkSoft),
                        ),
                      ),
                    ],
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
                      Expanded(
                        child: Text(
                          '${t.rating.toStringAsFixed(1)} / 5 | ${t.jumlahUlasan} ulasan | ${t.jumlahOrder} order',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.inkSoft,
                          ),
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
                        onPressed: () =>
                            _lihatPortfolio(context, t.portfolioUrl!),
                        icon: const Icon(Icons.link_rounded),
                        label: const Text('Lihat Portfolio'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
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
          if (t.paketLayanan.length > 1)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final paket in t.paketLayanan)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChoicePill(
                        label: paket.nama,
                        selected: pilihan.nama == paket.nama,
                        onPressed: () => setState(() => _paket = paket.nama),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pilihan.nama,
                    style: const TextStyle(color: AppColors.inkSoft),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    key: ValueKey(pilihan.nama),
                    'Rp ${pilihan.harga}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Pilih paket yang sesuai kebutuhan proyekmu.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Ulasan pelanggan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (store.isPencari)
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () => _editUlasan(t.id),
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text('Tulis ulasan'),
              ),
            ),
          if (reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Belum ada ulasan'),
            ),
          for (final review in reviews)
            Card(
              margin: const EdgeInsets.only(top: 16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            store.namaUser(review.userId),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (review.userId == store.pengguna?.id)
                          AppActionMenu(
                            options: const {
                              'edit': 'Edit ulasan',
                              'hapus': 'Hapus ulasan',
                            },
                            onSelected: (aksi) async {
                              if (aksi == 'edit') {
                                _editUlasan(t.id, review: review);
                              } else if (await konfirmasi(
                                    context,
                                    'Hapus ulasan?',
                                    'Ulasan ini akan dihapus.',
                                    aksi: 'Hapus',
                                  ) &&
                                  context.mounted) {
                                jalankanAksi(
                                  context,
                                  () => store.hapusUlasan(review),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        for (var i = 1; i <= 5; i++)
                          Icon(
                            i <= review.rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: AppColors.star,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(review.komentar),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
