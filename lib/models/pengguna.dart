class Pengguna {
  final String nama;
  final String email;
  final String lokasi;

  const Pengguna({
    required this.nama,
    required this.email,
    required this.lokasi,
  });
}

const penggunaDefault = Pengguna(
  nama: 'Deva',
  email: 'deva@example.com',
  lokasi: 'Bandung, Jawa Barat',
);
