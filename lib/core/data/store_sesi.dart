part of 'demo_store.dart';

extension DemoStoreSesi on DemoStore {
  void login(String email, String password) {
    final user = users
        .where((u) => u.email.toLowerCase() == email.trim().toLowerCase())
        .firstOrNull;
    if (user == null || _passwords[user.email] != password) {
      throw StateError('Email atau password salah');
    }
    if (user.status == 'diblokir') {
      aktivitasKeamanan.insert(0, 'Login akun diblokir ditolak: ${user.nama}.');
      throw StateError('Akun Anda diblokir');
    }
    _userId = user.id;
    aktivitasKeamanan.insert(0, '${user.nama} masuk sebagai ${user.role}.');
    refresh();
  }

  void loginDemo(String role) {
    final user = users.firstWhere((u) => u.role == role && u.status == 'aktif');
    login(user.email, _passwords[user.email]!);
  }

  void register(String nama, String email, String password, String lokasi) {
    email = email.trim().toLowerCase();
    if (users.any((u) => u.email.toLowerCase() == email)) {
      throw StateError('Email sudah dipakai');
    }
    final user = Pengguna(
      id: idBaru('user'),
      nama: nama.trim(),
      email: email,
      lokasi: lokasi.trim(),
      role: 'pencari',
    );
    users.add(user);
    _passwords[email] = password;
    _userId = user.id;
    refresh();
  }

  void logout() {
    _userId = null;
    refresh();
  }

  void editProfil(String nama, String lokasi, int warna) {
    final i = users.indexWhere((u) => u.id == _userId);
    if (i < 0) return;
    users[i] = users[i].copyWith(
      nama: nama.trim(),
      lokasi: lokasi.trim(),
      warnaAvatar: warna,
    );
    for (var j = 0; j < daftarTalent.length; j++) {
      if (daftarTalent[j].ownerId == _userId) {
        daftarTalent[j] = daftarTalent[j].copyWith(
          nama: nama.trim(),
          lokasi: lokasi.trim(),
        );
      }
    }
    refresh();
  }
}
