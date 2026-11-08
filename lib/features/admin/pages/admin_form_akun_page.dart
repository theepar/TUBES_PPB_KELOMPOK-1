import 'package:flutter/material.dart';

import '../../../core/data/demo_store.dart';
import '../../../core/models/pengguna.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/choice_pill.dart';
import '../../../core/widgets/demo_ui.dart';

class AdminFormAkunPage extends StatefulWidget {
  final Pengguna? akun;
  const AdminFormAkunPage({super.key, this.akun});
  @override
  State<AdminFormAkunPage> createState() => _AdminFormAkunPageState();
}

class _AdminFormAkunPageState extends State<AdminFormAkunPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nama = TextEditingController(text: widget.akun?.nama);
  late final _email = TextEditingController(text: widget.akun?.email);
  late final _lokasi = TextEditingController(text: widget.akun?.lokasi);
  final _password = TextEditingController();
  String _role = 'pencari';
  bool get _edit => widget.akun != null;

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _lokasi.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _wajib(String? value, String label) =>
      value == null || value.trim().isEmpty ? '$label wajib diisi' : null;

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    final store = DemoStore.instance;
    final berhasil = jalankanAksi(context, () {
      if (_edit) {
        store.ubahAkun(widget.akun!, nama: _nama.text, lokasi: _lokasi.text);
      } else {
        store.tambahAkun(
          _nama.text,
          _email.text,
          _password.text,
          _lokasi.text,
          _role,
        );
      }
    });
    if (!berhasil) return;
    Navigator.pop(context);
    pesanInfo(context, _edit ? 'Akun diperbarui' : 'Akun ditambahkan');
  }

  @override
  Widget build(BuildContext context) {
    if (!DemoStore.instance.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kelola Akun')),
        body: const Center(child: Text('Halaman khusus admin')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(_edit ? 'Edit Akun' : 'Tambah Akun')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: const ValueKey('akun-nama'),
                    controller: _nama,
                    decoration: const InputDecoration(labelText: 'Nama'),
                    validator: (v) => _wajib(v, 'Nama'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const ValueKey('akun-email'),
                    controller: _email,
                    enabled: !_edit,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const ValueKey('akun-lokasi'),
                    controller: _lokasi,
                    decoration: const InputDecoration(labelText: 'Lokasi'),
                    validator: (v) => _wajib(v, 'Lokasi'),
                  ),
                  if (!_edit) ...[
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey('akun-password'),
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Role akun',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (final role in const ['pencari', 'penyedia']) ...[
                          if (role == 'penyedia') const SizedBox(width: 12),
                          Expanded(
                            child: ChoicePill(
                              label: role == 'pencari' ? 'Pencari' : 'Penyedia',
                              selected: _role == role,
                              onPressed: () => setState(() => _role = role),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 32),
                  FilledButton(onPressed: _simpan, child: const Text('Simpan')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
