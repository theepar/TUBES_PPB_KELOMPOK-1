part of 'demo_store.dart';

extension DemoStoreJasa on DemoStore {
  void simpanTalent(Talent talent) {
    if (!isPenyedia || talent.ownerId != _userId) {
      throw StateError('Hanya penyedia pemilik jasa yang bisa menyimpan');
    }
    if (talent.paketLayanan.isEmpty ||
        talent.paketLayanan.any((p) => p.nama.trim().isEmpty || p.harga <= 0)) {
      throw StateError(
        'Tambahkan minimal satu pilihan layanan dengan harga yang valid',
      );
    }
    final names = talent.paketLayanan
        .map((p) => p.nama.trim().toLowerCase())
        .toSet();
    if (names.length != talent.paketLayanan.length) {
      throw StateError('Nama pilihan layanan tidak boleh sama');
    }
    final i = daftarTalent.indexWhere((t) => t.id == talent.id);
    if (i >= 0 && daftarTalent[i].ownerId != _userId) {
      throw StateError('Jasa bukan milik Anda');
    }
    if (i < 0) {
      daftarTalent.add(
        talent.copyWith(lokasi: pengguna!.lokasi, nama: pengguna!.nama),
      );
    } else {
      daftarTalent[i] = talent.copyWith(
        lokasi: pengguna!.lokasi,
        nama: pengguna!.nama,
      );
    }
    refresh();
  }

  void hapusTalent(Talent talent) {
    if (!isPenyedia || talent.ownerId != _userId) {
      throw StateError('Hanya pemilik jasa yang bisa menghapus');
    }
    daftarTalent.removeWhere((t) => t.id == talent.id);
    reviews.removeWhere((r) => r.talentId == talent.id);
    for (final ids in _favorites.values) {
      ids.remove(talent.id);
    }
    refresh();
  }
}
