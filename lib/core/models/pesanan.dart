class Pesanan {
  final String id;
  final String talentId;
  final String namaJasa;
  final String buyerId;
  final String sellerId;
  final String paket;
  final int harga;
  final String catatan;
  final DateTime tanggal;
  String status;
  String metode;
  String hasil;
  String keputusan;
  String alasan;
  DateTime? dibayarPada;
  bool disembunyikanBuyer = false;

  Pesanan({
    required this.id,
    required this.talentId,
    required this.namaJasa,
    required this.buyerId,
    required this.sellerId,
    required this.paket,
    required this.harga,
    this.catatan = '',
    this.status = 'menunggu_pembayaran',
    this.metode = 'BCA',
    this.hasil = '',
    this.keputusan = '',
    this.alasan = '',
    this.dibayarPada,
    DateTime? tanggal,
  }) : tanggal = tanggal ?? DateTime.now();

  int get biayaLayanan => (harga * 0.05).round();
  int get total => harga + biayaLayanan;
  bool get sudahAkhir => ['selesai', 'direfund', 'dibatalkan'].contains(status);
}
