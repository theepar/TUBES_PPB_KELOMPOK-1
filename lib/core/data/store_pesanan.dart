part of 'demo_store.dart';

extension DemoStorePesanan on DemoStore {
  String cekPembayaran(Pesanan order) {
    if (!isAdmin && order.buyerId != _userId && order.sellerId != _userId) {
      throw StateError('Pesanan bukan milik akun ini');
    }
    if ([
      'dibayar',
      'dikirim',
      'menunggu_admin',
      'selesai',
    ].contains(order.status)) {
      return 'dibayar';
    }
    return order.status;
  }

  Pesanan buatOrder(
    Talent talent,
    String paket,
    String catatan,
    String metode,
  ) {
    if (!isPencari || talent.ownerId == _userId) {
      throw StateError('Hanya pencari bisa memesan jasa penyedia lain');
    }
    final current = daftarTalent.where((t) => t.id == talent.id).firstOrNull;
    if (current == null || !current.tampil) {
      throw StateError('Jasa sedang tidak tersedia');
    }
    final order = Pesanan(
      id: idBaru('ORDER'),
      talentId: talent.id,
      namaJasa: talent.bidang,
      buyerId: _userId!,
      sellerId: talent.ownerId,
      paket: paket,
      harga: current.hargaPaket(paket),
      catatan: catatan.trim(),
      metode: metode,
    );
    orders.insert(0, order);
    refresh();
    return order;
  }

  void bayar(Pesanan order) {
    if (order.buyerId != _userId || order.status != 'menunggu_pembayaran') {
      throw StateError('Pesanan tidak bisa dibayar');
    }
    order.status = 'dibayar';
    order.dibayarPada = DateTime.now();
    refresh();
  }

  void batalkan(Pesanan order) {
    if (order.buyerId != _userId || order.status != 'menunggu_pembayaran') {
      throw StateError('Pesanan tidak bisa dibatalkan');
    }
    order.status = 'dibatalkan';
    refresh();
  }

  void kirimHasil(Pesanan order, String hasil) {
    if (order.sellerId != _userId || order.status != 'dibayar') {
      throw StateError('Pesanan tidak bisa diselesaikan');
    }
    order.hasil = hasil.trim();
    order.status = 'dikirim';
    refresh();
  }

  void keputusanBuyer(Pesanan order, bool diterima, String alasan) {
    if (order.buyerId != _userId || order.status != 'dikirim') {
      throw StateError('Pesanan belum selesai dikerjakan');
    }
    if (!diterima && alasan.trim().isEmpty) {
      throw StateError('Alasan komplain wajib diisi');
    }
    order.keputusan = diterima ? 'diterima' : 'komplain';
    order.alasan = alasan.trim();
    order.status = 'menunggu_admin';
    refresh();
  }

  void hapusOrder(Pesanan order) {
    if (order.buyerId != _userId || !order.sudahAkhir) {
      throw StateError('Pesanan belum boleh dihapus');
    }
    order.disembunyikanBuyer = true;
    refresh();
  }

  void putuskanOrder(Pesanan order, bool approve) {
    if (!isAdmin || order.status != 'menunggu_admin') {
      throw StateError('Hanya admin bisa memutuskan pesanan ini');
    }
    final id = approve ? order.sellerId : order.buyerId;
    final i = users.indexWhere((u) => u.id == id);
    if (i < 0) throw StateError('Akun tidak ditemukan');
    users[i] = users[i].copyWith(
      saldo: users[i].saldo + (approve ? order.harga : order.total),
    );
    order.status = approve ? 'selesai' : 'direfund';
    refresh();
  }
}
