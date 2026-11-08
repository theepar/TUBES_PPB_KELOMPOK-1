part of 'demo_store.dart';

extension DemoStoreAkun on DemoStore {
  void daftarPenyedia(String keahlian, String pengalaman, String lokasi) {
    if (!isPencari) {
      throw StateError('Pendaftaran penyedia hanya untuk akun pencari');
    }
    if (keahlian.trim().isEmpty ||
        pengalaman.trim().isEmpty ||
        lokasi.trim().isEmpty) {
      throw StateError('Lengkapi data keahlian dan lokasi');
    }
    final i = users.indexWhere((u) => u.id == _userId);
    users[i] = users[i].copyWith(
      role: 'penyedia',
      keahlian: keahlian.trim(),
      pengalaman: pengalaman.trim(),
      lokasi: lokasi.trim(),
    );
    aktivitasKeamanan.insert(0, '${users[i].nama} mendaftar sebagai penyedia.');
    refresh();
  }

  void ubahAkun(
    Pengguna user, {
    String? nama,
    String? lokasi,
    String? role,
    String? status,
  }) {
    if (!isAdmin || user.id == _userId || user.role == 'admin') {
      throw StateError('Akun ini tidak bisa diubah');
    }
    if (role != null && !['pencari', 'penyedia'].contains(role)) {
      throw StateError('Role tidak valid');
    }
    if (status != null && !['aktif', 'diblokir'].contains(status)) {
      throw StateError('Status tidak valid');
    }
    if ((nama != null && nama.trim().isEmpty) ||
        (lokasi != null && lokasi.trim().isEmpty)) {
      throw StateError('Nama dan lokasi wajib diisi');
    }
    final i = users.indexWhere((u) => u.id == user.id);
    if (i < 0) throw StateError('Akun tidak ditemukan');
    final updated = users[i].copyWith(
      nama: nama?.trim(),
      lokasi: lokasi?.trim(),
      role: role,
      status: status,
    );
    users[i] = updated;
    for (var j = 0; j < daftarTalent.length; j++) {
      if (daftarTalent[j].ownerId == updated.id) {
        daftarTalent[j] = daftarTalent[j].copyWith(
          nama: updated.nama,
          lokasi: updated.lokasi,
        );
      }
    }
    aktivitasKeamanan.insert(
      0,
      'Admin memperbarui akun ${updated.nama}: ${updated.role}, ${updated.status}.',
    );
    refresh();
  }

  void tambahAkun(
    String nama,
    String email,
    String password,
    String lokasi,
    String role,
  ) {
    if (!isAdmin) throw StateError('Hanya admin dapat menambah akun');
    email = email.trim().toLowerCase();
    if (nama.trim().isEmpty || lokasi.trim().isEmpty) {
      throw StateError('Nama dan lokasi wajib diisi');
    }
    if (!Validators.emailValid(email)) throw StateError('Isi email yang valid');
    if (password.length < 6) throw StateError('Password minimal 6 karakter');
    if (!['pencari', 'penyedia'].contains(role)) {
      throw StateError('Role tidak valid');
    }
    if (users.any((u) => u.email.toLowerCase() == email)) {
      throw StateError('Email sudah dipakai');
    }
    final user = Pengguna(
      id: idBaru('user'),
      nama: nama.trim(),
      email: email,
      lokasi: lokasi.trim(),
      role: role,
    );
    users.add(user);
    _passwords[email] = password;
    aktivitasKeamanan.insert(
      0,
      'Admin menambah akun ${user.nama} sebagai ${user.role}.',
    );
    refresh();
  }

  void hapusAkun(Pengguna user) {
    if (!isAdmin || user.id == _userId || user.role == 'admin') {
      throw StateError('Akun ini tidak bisa dihapus');
    }
    final nama = _hapusDataAkun(user.id);
    aktivitasKeamanan.insert(0, 'Admin menghapus akun $nama.');
    refresh();
  }

  void hapusAkunSendiri() {
    if (pengguna == null || isAdmin) {
      throw StateError('Akun ini tidak bisa dihapus');
    }
    final id = _userId!;
    final nama = _hapusDataAkun(id);
    _userId = null;
    aktivitasKeamanan.insert(0, '$nama menghapus akunnya sendiri.');
    refresh();
  }

  String _hapusDataAkun(String id) {
    final i = users.indexWhere((u) => u.id == id);
    if (i < 0) throw StateError('Akun tidak ditemukan');
    final user = users[i];
    final aktif = orders.any(
      (o) => (o.buyerId == id || o.sellerId == id) && !o.sudahAkhir,
    );
    if (aktif) {
      throw StateError('Akun masih punya pesanan yang belum selesai');
    }
    final jasaIds = daftarTalent
        .where((t) => t.ownerId == id)
        .map((t) => t.id)
        .toSet();
    daftarTalent.removeWhere((t) => jasaIds.contains(t.id));
    final terdampak = reviews
        .where((r) => r.userId == id && !jasaIds.contains(r.talentId))
        .map((r) => r.talentId)
        .toSet();
    reviews.removeWhere((r) => r.userId == id || jasaIds.contains(r.talentId));
    _favorites.remove(id);
    for (final ids in _favorites.values) {
      ids.removeAll(jasaIds);
    }
    _passwords.remove(user.email);
    users.removeAt(i);
    terdampak.forEach(_hitungRating);
    return user.nama;
  }
}
