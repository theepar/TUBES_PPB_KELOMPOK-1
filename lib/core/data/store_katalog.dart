part of 'demo_store.dart';

extension DemoStoreKatalog on DemoStore {
  void toggleFavorit(String id) {
    if (pengguna == null) return;
    final ids = _favorites.putIfAbsent(_userId!, () => <String>{});
    if (!ids.add(id)) ids.remove(id);
    refresh();
  }

  void moderasiJasa(Talent talent, {bool hapus = false}) {
    if (!isAdmin) throw StateError('Hanya admin dapat mengelola postingan');
    final i = daftarTalent.indexWhere((t) => t.id == talent.id);
    if (i < 0) throw StateError('Postingan tidak ditemukan');
    if (hapus) {
      daftarTalent.removeAt(i);
      reviews.removeWhere((r) => r.talentId == talent.id);
      for (final ids in _favorites.values) {
        ids.remove(talent.id);
      }
      aktivitasKeamanan.insert(
        0,
        'Admin menghapus postingan: ${talent.bidang}.',
      );
    } else {
      daftarTalent[i] = talent.copyWith(tampil: !talent.tampil);
      aktivitasKeamanan.insert(
        0,
        'Admin ${talent.tampil ? 'menyembunyikan' : 'menampilkan'} postingan: ${talent.bidang}.',
      );
    }
    refresh();
  }
}
