import 'talent.dart';
import 'ulasan.dart';

class StatistikJasa {
  final Talent talent;
  final int terbeli;
  const StatistikJasa({required this.talent, required this.terbeli});
}

class StatistikPenyedia {
  final int totalDibeli;
  final int pendapatan;
  final double rating;
  final int jumlahUlasan;
  final List<StatistikJasa> perJasa;

  /// Jumlah ulasan per bintang. Indeks 0 = bintang 1, indeks 4 = bintang 5.
  final List<int> sebaranBintang;
  final List<Ulasan> ulasanTerbaru;

  const StatistikPenyedia({
    this.totalDibeli = 0,
    this.pendapatan = 0,
    this.rating = 0,
    this.jumlahUlasan = 0,
    this.perJasa = const [],
    this.sebaranBintang = const [0, 0, 0, 0, 0],
    this.ulasanTerbaru = const [],
  });
}
