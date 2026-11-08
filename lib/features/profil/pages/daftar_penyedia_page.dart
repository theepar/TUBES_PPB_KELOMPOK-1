import 'package:flutter/material.dart';

import '../../../core/data/demo_store.dart';
import '../../../core/widgets/demo_ui.dart';
import '../../../core/theme/app_colors.dart';

class DaftarPenyediaPage extends StatefulWidget {
  const DaftarPenyediaPage({super.key});
  @override
  State<DaftarPenyediaPage> createState() => _DaftarPenyediaPageState();
}

class _DaftarPenyediaPageState extends State<DaftarPenyediaPage> {
  final _form = GlobalKey<FormState>();
  String _keahlian = '', _pengalaman = '';
  late String _lokasi = DemoStore.instance.pengguna?.lokasi ?? '';
  String? _wajib(String? value) =>
      value == null || value.trim().isEmpty ? 'Kolom ini wajib diisi' : null;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Daftar menjadi penyedia')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.work_outline_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tawarkan keahlianmu',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Lengkapi profil penyedia untuk mulai menambahkan jasa.',
                    style: TextStyle(color: AppColors.inkSoft, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    key: const ValueKey('penyedia-keahlian'),
                    decoration: const InputDecoration(
                      labelText: 'Keahlian utama',
                      hintText: 'Contoh: Desain grafis',
                    ),
                    onChanged: (v) => _keahlian = v,
                    validator: _wajib,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const ValueKey('penyedia-pengalaman'),
                    decoration: const InputDecoration(
                      labelText: 'Pengalaman dan layanan',
                      hintText: 'Ceritakan keahlian dan jenis layananmu.',
                      alignLabelWithHint: true,
                    ),
                    minLines: 4,
                    maxLines: 6,
                    onChanged: (v) => _pengalaman = v,
                    validator: _wajib,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const ValueKey('penyedia-lokasi'),
                    initialValue: _lokasi,
                    decoration: const InputDecoration(
                      labelText: 'Lokasi layanan',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    onChanged: (v) => _lokasi = v,
                    validator: _wajib,
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: () {
                      if (_form.currentState!.validate() &&
                          jalankanAksi(
                            context,
                            () => DemoStore.instance.daftarPenyedia(
                              _keahlian,
                              _pengalaman,
                              _lokasi,
                            ),
                          )) {
                        Navigator.pop(context);
                        pesanInfo(
                          context,
                          'Pendaftaran berhasil. Sekarang kamu bisa menambahkan jasa.',
                        );
                      }
                    },
                    child: const Text('Daftar sebagai penyedia'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
