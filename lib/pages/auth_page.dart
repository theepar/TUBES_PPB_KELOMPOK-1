import 'package:flutter/material.dart';

import '../pengguna.dart';
import '../utils/app_colors.dart';
import 'beranda_page.dart';

const _lokasiDefault = 'Bandung, Jawa Barat';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _lokasi = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _daftar = false;
  bool _lihatPassword = false;

  @override
  void dispose() {
    _nama.dispose();
    _lokasi.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _wajib(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  static String _namaDariEmail(String email) {
    final bersih = email.trim();
    final bagian = bersih.contains('@') ? bersih.split('@').first : bersih;
    if (bagian.isEmpty) return 'Pengguna';
    return bagian[0].toUpperCase() + bagian.substring(1);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final email = _email.text.trim();
    final lokasi = _lokasi.text.trim();
    final pengguna = _daftar
        ? Pengguna(
            nama: _nama.text.trim(),
            email: email,
            lokasi: lokasi.isEmpty ? _lokasiDefault : lokasi,
          )
        : Pengguna(
            nama: _namaDariEmail(email),
            email: email,
            lokasi: _lokasiDefault,
          );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => BerandaPage(pengguna: pengguna)),
    );
  }

  void _gantiMode() {
    setState(() {
      _daftar = !_daftar;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'SewaSkill',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _daftar ? 'Buat akun baru' : 'Masuk ke akunmu',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_daftar) ...[
                      TextFormField(
                        controller: _nama,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => _wajib(v, 'Nama'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _lokasi,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Lokasi (kota)',
                          helperText: 'Kosongkan untuk $_lokasiDefault',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => _wajib(v, 'Email'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _password,
                      obscureText: !_lihatPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _lihatPassword
                              ? 'Sembunyikan password'
                              : 'Tampilkan password',
                          icon: Icon(
                            _lihatPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _lihatPassword = !_lihatPassword),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(_daftar ? 'Daftar' : 'Masuk'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _gantiMode,
                      child: Text(
                        _daftar
                            ? 'Sudah punya akun? Masuk'
                            : 'Belum punya akun? Daftar',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
