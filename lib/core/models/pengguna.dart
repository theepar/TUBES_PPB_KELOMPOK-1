class Pengguna {
  final String id;
  final String nama;
  final String email;
  final String lokasi;
  final String role;
  final String status;
  final int saldo;
  final int warnaAvatar;
  final String keahlian;
  final String pengalaman;

  const Pengguna({
    this.id = 'buyer',
    required this.nama,
    required this.email,
    required this.lokasi,
    this.role = 'pencari',
    this.status = 'aktif',
    this.saldo = 0,
    this.warnaAvatar = 0xFF176DCE,
    this.keahlian = '',
    this.pengalaman = '',
  });

  Pengguna copyWith({
    String? nama,
    String? lokasi,
    String? role,
    String? status,
    int? saldo,
    int? warnaAvatar,
    String? keahlian,
    String? pengalaman,
  }) {
    return Pengguna(
      id: id,
      nama: nama ?? this.nama,
      email: email,
      lokasi: lokasi ?? this.lokasi,
      role: role ?? this.role,
      status: status ?? this.status,
      saldo: saldo ?? this.saldo,
      warnaAvatar: warnaAvatar ?? this.warnaAvatar,
      keahlian: keahlian ?? this.keahlian,
      pengalaman: pengalaman ?? this.pengalaman,
    );
  }
}

const penggunaDefault = Pengguna(
  nama: 'Deva',
  email: 'deva@example.com',
  lokasi: 'Bandung, Jawa Barat',
);
