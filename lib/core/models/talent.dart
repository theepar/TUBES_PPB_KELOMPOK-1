import 'paket_jasa.dart';

class Talent {
  final String id;
  final String ownerId;
  final String nama;
  final String bidang;
  final String lokasi;
  final bool tampil;
  final List<PaketJasa> paketLayanan;
  final double rating;
  final int jumlahUlasan;
  final int jumlahOrder;
  final String deskripsi;
  final String? portfolioUrl;

  const Talent({
    required this.id,
    this.ownerId = 'seller',
    required this.nama,
    required this.bidang,
    this.lokasi = 'Bandung',
    this.tampil = true,
    required this.paketLayanan,
    required this.rating,
    required this.jumlahUlasan,
    required this.jumlahOrder,
    required this.deskripsi,
    this.portfolioUrl,
  });

  int get hargaMulai {
    if (paketLayanan.isEmpty) return 0;
    var minimum = paketLayanan.first.harga;
    for (final paket in paketLayanan) {
      if (paket.harga < minimum) minimum = paket.harga;
    }
    return minimum;
  }

  int hargaPaket(String nama) {
    for (final paket in paketLayanan) {
      if (paket.nama == nama) return paket.harga;
    }
    throw StateError('Pilihan layanan tidak tersedia');
  }

  Talent copyWith({
    String? bidang,
    String? lokasi,
    bool? tampil,
    String? nama,
    double? rating,
    int? jumlahUlasan,
    List<PaketJasa>? paketLayanan,
    String? deskripsi,
    String? portfolioUrl,
    bool hapusPortfolio = false,
  }) {
    return Talent(
      id: id,
      ownerId: ownerId,
      nama: nama ?? this.nama,
      bidang: bidang ?? this.bidang,
      lokasi: lokasi ?? this.lokasi,
      tampil: tampil ?? this.tampil,
      paketLayanan: paketLayanan ?? this.paketLayanan,
      rating: rating ?? this.rating,
      jumlahUlasan: jumlahUlasan ?? this.jumlahUlasan,
      jumlahOrder: jumlahOrder,
      deskripsi: deskripsi ?? this.deskripsi,
      portfolioUrl: hapusPortfolio ? null : portfolioUrl ?? this.portfolioUrl,
    );
  }
}
