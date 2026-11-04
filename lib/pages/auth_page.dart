import 'package:flutter/material.dart';

import '../pengguna.dart';
import '../utils/app_colors.dart';
import 'beranda_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _lihatPassword = false;

  @override
  void dispose() {
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

  void _masuk() {
    if (!_formKey.currentState!.validate()) return;

    final email = _email.text.trim();
    final pengguna = Pengguna(
      nama: _namaDariEmail(email),
      email: email,
      lokasi: 'Bandung, Jawa Barat',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => BerandaPage(pengguna: pengguna)),
    );
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
                    const Text(
                      'Masuk ke akunmu',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.inkSoft),
                    ),
                    const SizedBox(height: 24),
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
                      onPressed: _masuk,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Masuk'),
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
