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
  final String avatar;
  final double? latitude;
  final double? longitude;

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
    this.avatar = '',
    this.latitude,
    this.longitude,
  });

  factory Pengguna.fromJson(Map<String, dynamic> json) => Pengguna(
    id: json['id'],
    nama: json['name'] ?? 'Pengguna',
    email: json['email'] ?? '',
    lokasi: json['location'] ?? '',
    role: json['role'] ?? 'penyedia',
    status: json['status'] ?? 'aktif',
    saldo: (json['balance'] as num?)?.toInt() ?? 0,
    avatar: json['avatar'] ?? '',
    keahlian: json['skills'] ?? '',
    pengalaman: json['experience'] ?? '',
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
  );
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
      avatar: avatar,
      latitude: latitude,
      longitude: longitude,
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
