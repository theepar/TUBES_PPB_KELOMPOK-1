import 'package:flutter/material.dart';
import '../talent.dart';

class DetailJasaPage extends StatelessWidget {
  final Talent talent;

  const DetailJasaPage({super.key, required this.talent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(child: Text('Detail ${talent.nama} (belum dikerjakan)')),
    );
  }
}
