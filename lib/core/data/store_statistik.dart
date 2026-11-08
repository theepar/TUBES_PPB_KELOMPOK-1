part of 'demo_store.dart';

extension DemoStoreStatistik on DemoStore {
  /// Ringkasan usaha penyedia yang sedang login. Kosong untuk role lain.
  StatistikPenyedia statistikPenyedia() {
    if (!isPenyedia) return const StatistikPenyedia();
    final id = _userId;
    final jasa = daftarTalent.where((t) => t.ownerId == id).toList();
    final jasaIds = jasa.map((t) => t.id).toSet();
    final dibeli = orders
        .where(
          (o) =>
              o.sellerId == id &&
              o.status != 'menunggu_pembayaran' &&
              o.status != 'dibatalkan',
        )
        .toList();
    final ulasan = reviews.where((r) => jasaIds.contains(r.talentId)).toList();
    final sebaran = List<int>.filled(5, 0);
    for (final r in ulasan) {
      sebaran[r.rating.clamp(1, 5) - 1]++;
    }
    return StatistikPenyedia(
      totalDibeli: dibeli.length,
      pendapatan: dibeli
          .where((o) => o.status == 'selesai')
          .fold<int>(0, (sum, o) => sum + o.harga),
      rating: ulasan.isEmpty
          ? 0
          : ulasan.fold<int>(0, (sum, r) => sum + r.rating) / ulasan.length,
      jumlahUlasan: ulasan.length,
      perJasa: [
        for (final t in jasa)
          StatistikJasa(
            talent: t,
            terbeli: dibeli.where((o) => o.talentId == t.id).length,
          ),
      ],
      sebaranBintang: sebaran,
      ulasanTerbaru: ulasan.take(3).toList(),
    );
  }
}
