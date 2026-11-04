class Talent {
  final String id;
  final String nama;
  final String bidang;
  final int hargaMulai;
  final double rating;
  final int jumlahUlasan;
  final int jumlahOrder;
  final String deskripsi;
  final String? portfolioUrl;

  const Talent({
    required this.id,
    required this.nama,
    required this.bidang,
    required this.hargaMulai,
    required this.rating,
    required this.jumlahUlasan,
    required this.jumlahOrder,
    required this.deskripsi,
    this.portfolioUrl,
  });

  int hargaPaket(String paket) {
    if (paket == 'Basic') return hargaMulai;
    if (paket == 'Standard') return hargaMulai * 2;
    return hargaMulai * 4;
  }

  Talent copyWith({
    String? bidang,
    int? hargaMulai,
    String? deskripsi,
    String? portfolioUrl,
  }) {
    return Talent(
      id: id,
      nama: nama,
      bidang: bidang ?? this.bidang,
      hargaMulai: hargaMulai ?? this.hargaMulai,
      rating: rating,
      jumlahUlasan: jumlahUlasan,
      jumlahOrder: jumlahOrder,
      deskripsi: deskripsi ?? this.deskripsi,
      portfolioUrl: portfolioUrl,
    );
  }
}
