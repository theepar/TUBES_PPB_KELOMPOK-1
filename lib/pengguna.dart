class Pengguna {
  final String id;
  final String nama;
  final String lokasi;
  final String role;
  final String status;
  final int saldo;
  final String? avatarPath;

  const Pengguna({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.role,
    required this.status,
    required this.saldo,
    this.avatarPath,
  });

  factory Pengguna.fromMap(Map<String, dynamic> map) {
    return Pengguna(
      id: map['id'] as String,
      nama: (map['nama'] ?? '') as String,
      lokasi: (map['lokasi'] ?? '') as String,
      role: (map['role'] ?? 'pencari') as String,
      status: (map['status'] ?? 'aktif') as String,
      saldo: ((map['saldo'] ?? 0) as num).toInt(),
      avatarPath: map['avatar_path'] as String?,
    );
  }

  bool get diblokir => status == 'diblokir';
}

const penggunaLogin = Pengguna(
  id: 'local-deva',
  nama: 'Deva',
  lokasi: 'Bandung, Jawa Barat',
  role: 'pencari',
  status: 'aktif',
  saldo: 0,
);
