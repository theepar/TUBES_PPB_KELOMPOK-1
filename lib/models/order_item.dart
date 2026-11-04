import '../talent.dart';

class OrderItem {
  final String id;
  final Talent talent;
  final String namaJasa;
  final String buyerName;
  final String sellerName;
  final String paket;
  final int total;
  final String catatan;
  String status;
  String? metodeBayar;
  String? hasilKerja;
  String? alasanKomplain;
  final DateTime createdAt;

  OrderItem({
    required this.id,
    required this.talent,
    required this.namaJasa,
    required this.buyerName,
    required this.sellerName,
    required this.paket,
    required this.total,
    required this.catatan,
    this.status = 'menunggu_pembayaran',
    this.metodeBayar,
    this.hasilKerja,
    this.alasanKomplain,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
