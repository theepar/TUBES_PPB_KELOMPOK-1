import 'package:flutter/material.dart';

class TambahJasaPage extends StatelessWidget {
  const TambahJasaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Jasa')),
      body: const Center(child: Text('Daftar Jasa (belum dikerjakan)')),
    );
  }
}
