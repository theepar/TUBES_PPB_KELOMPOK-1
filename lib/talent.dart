class Talent {
  final String nama;
  final String bidang;
  final int hargaMulai;
  final double rating;
  final int jumlahUlasan;
  final int jumlahOrder;
  final String deskripsi;

  const Talent({
    required this.nama,
    required this.bidang,
    required this.hargaMulai,
    required this.rating,
    required this.jumlahUlasan,
    required this.jumlahOrder,
    required this.deskripsi,
  });

  int hargaPaket(String paket) {
    if (paket == 'Basic') return hargaMulai;
    if (paket == 'Standard') return hargaMulai * 2;
    return hargaMulai * 4;
  }
}
