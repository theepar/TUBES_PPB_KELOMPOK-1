import 'package:flutter/material.dart';

/// Pengganti sementara untuk halaman anggota lain yang belum dikerjakan.
/// Ganti dengan halaman asli di `beranda_page.dart` saat sudah jadi.
class HalamanPlaceholder extends StatelessWidget {
  final String judul;

  const HalamanPlaceholder({super.key, required this.judul});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: Center(child: Text('$judul (belum dikerjakan)')),
    );
  }
}
