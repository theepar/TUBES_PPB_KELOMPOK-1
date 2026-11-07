import 'package:flutter/foundation.dart';

import '../models/pengguna.dart';
import '../models/pesanan.dart';
import '../models/statistik_penyedia.dart';
import '../models/talent.dart';
import '../models/ulasan.dart';
import '../utils/validators.dart';
import 'talent_data.dart';

part 'store_akun.dart';
part 'store_jasa.dart';
part 'store_katalog.dart';
part 'store_pesanan.dart';
part 'store_sesi.dart';
part 'store_statistik.dart';
part 'store_ulasan.dart';

class DemoStore extends ChangeNotifier {
  static final instance = DemoStore._();

  DemoStore._() {
    reset();
  }

  final users = <Pengguna>[];

  final orders = <Pesanan>[];

  final reviews = <Ulasan>[];

  final _favorites = <String, Set<String>>{};

  final _passwords = <String, String>{};

  final _initialTalents = daftarTalent.toList();

  String? _userId;

  final aktivitasKeamanan = <String>[];

  Pengguna? get pengguna {
    for (final user in users) {
      if (user.id == _userId) return user;
    }
    return null;
  }

  bool get isAdmin => pengguna?.role == 'admin';

  bool get isPenyedia => pengguna?.role == 'penyedia';

  bool get isPencari => pengguna?.role == 'pencari';

  Set<String> get favorit =>
      Set.unmodifiable(_favorites[_userId] ?? <String>{});

  String namaUser(String id) =>
      users.where((u) => u.id == id).firstOrNull?.nama ?? 'Pengguna';

  String idBaru(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  void refresh() => notifyListeners();

  void reset() {
    _userId = null;
    aktivitasKeamanan
      ..clear()
      ..add('Data akun contoh dimuat untuk sesi ini.');
    users
      ..clear()
      ..addAll([
        penggunaDefault,
        const Pengguna(
          id: 'seller',
          nama: 'Rizky Aditya',
          email: 'rizky@example.com',
          lokasi: 'Jakarta',
          role: 'penyedia',
        ),
        const Pengguna(
          id: 'seller2',
          nama: 'Sari Dewi',
          email: 'sari@example.com',
          lokasi: 'Bandung',
          role: 'penyedia',
        ),
        const Pengguna(
          id: 'seller3',
          nama: 'Budi Santoso',
          email: 'budi@example.com',
          lokasi: 'Bandung',
          role: 'penyedia',
        ),
        const Pengguna(
          id: 'seller4',
          nama: 'Maya Putri',
          email: 'maya@example.com',
          lokasi: 'Surabaya',
          role: 'penyedia',
        ),
        const Pengguna(
          id: 'admin',
          nama: 'Admin SewaSkill',
          email: 'admin@example.com',
          lokasi: 'Bandung',
          role: 'admin',
        ),
        const Pengguna(
          id: 'buyer2',
          nama: 'Dinda Rahayu',
          email: 'dinda@example.com',
          lokasi: 'Yogyakarta',
        ),
      ]);
    _passwords
      ..clear()
      ..addEntries(users.map((u) => MapEntry(u.email, 'demo123')));
    _favorites.clear();
    _favorites['buyer'] = {'t2'};
    daftarTalent
      ..clear()
      ..addAll(_initialTalents);
    reviews.clear();
    for (final talent in daftarTalent) {
      reviews.addAll([
        Ulasan(
          id: 'review-${talent.id}-1',
          talentId: talent.id,
          userId: 'buyer',
          rating: 5,
          komentar: 'Hasilnya rapi dan sesuai brief. Komunikasinya juga jelas.',
        ),
        Ulasan(
          id: 'review-${talent.id}-2',
          talentId: talent.id,
          userId: 'buyer2',
          rating: 4,
          komentar:
              'Pengerjaan tepat waktu. Revisi dibantu sampai sesuai kebutuhan.',
        ),
      ]);
      _hitungRating(talent.id);
    }
    orders.clear();
    const statuses = [
      'menunggu_pembayaran',
      'dibayar',
      'dikirim',
      'menunggu_admin',
      'selesai',
      'direfund',
      'dibatalkan',
    ];
    for (var i = 0; i < statuses.length; i++) {
      orders.add(
        Pesanan(
          id: 'DEMO-${1001 + i}',
          talentId: 't1',
          namaJasa: daftarTalent.first.bidang,
          buyerId: 'buyer',
          sellerId: 'seller',
          paket: daftarTalent.first.paketLayanan[1].nama,
          harga: daftarTalent.first.paketLayanan[1].harga,
          catatan: 'Video promosi produk, durasi 30 detik.',
          status: statuses[i],
          hasil: i >= 2 && i <= 5
              ? 'Video final dan revisi sudah dikirim sesuai brief.'
              : '',
          keputusan: i == 3 || i == 4
              ? 'diterima'
              : i == 5
              ? 'komplain'
              : '',
          alasan: i == 5 ? 'Hasil belum sesuai brief.' : '',
          tanggal: DateTime(2026, 11, 7).subtract(Duration(days: i)),
          dibayarPada: i >= 1 && i <= 5
              ? DateTime(2026, 11, 7).subtract(Duration(days: i))
              : null,
        ),
      );
    }
    notifyListeners();
  }

  List<Ulasan> ulasanJasa(String id) =>
      reviews.where((r) => r.talentId == id).toList();

  void _hitungRating(String id) {
    final list = ulasanJasa(id);
    final i = daftarTalent.indexWhere((t) => t.id == id);
    if (i < 0) return;
    daftarTalent[i] = daftarTalent[i].copyWith(
      rating: list.isEmpty
          ? 0
          : list.fold<int>(0, (sum, r) => sum + r.rating) / list.length,
      jumlahUlasan: list.length,
    );
  }
}
