import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/app_session.dart';
import '../utils/app_colors.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _nama = TextEditingController();
  final _lokasi = TextEditingController();

  bool _daftar = false;
  bool _lihatPassword = false;
  bool _loading = false;
  String _role = 'pencari';
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _nama.dispose();
    _lokasi.dispose();
    super.dispose();
  }

  String? _wajib(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  String? _cekEmail(String? v) {
    final email = v?.trim() ?? '';
    if (email.isEmpty) return 'Email wajib diisi';
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    return valid ? null : 'Format email tidak valid';
  }

  String? _cekPassword(String? v) {
    if (v == null || v.isEmpty) return 'Password wajib diisi';
    if (v.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  String _pesanAuth(AuthException e) {
    final pesan = e.message.toLowerCase();
    if (pesan.contains('invalid login credentials')) {
      return 'Email atau password salah.';
    }
    if (pesan.contains('already registered')) {
      return 'Email ini sudah terdaftar. Silakan masuk.';
    }
    if (pesan.contains('password')) {
      return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
    }
    if (pesan.contains('email not confirmed')) {
      return 'Email belum dikonfirmasi. Cek kotak masuk emailmu.';
    }
    return e.message;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final db = Supabase.instance.client;
    final session = AppSession.instance;

    try {
      if (_daftar) {
        final res = await db.auth.signUp(
          email: _email.text.trim(),
          password: _password.text,
          data: {
            'nama': _nama.text.trim(),
            'lokasi': _lokasi.text.trim(),
            'role': _role,
          },
        );
        if (res.session == null) {
          if (!mounted) return;
          setState(() {
            _loading = false;
            _daftar = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Akun dibuat. Cek email untuk konfirmasi, lalu masuk.'),
            ),
          );
          return;
        }
      } else {
        await db.auth.signInWithPassword(
          email: _email.text.trim(),
          password: _password.text,
        );
      }

      await session.muatProfil();

      if (session.akunDiblokir) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _error = 'Akun Anda diblokir. Hubungi admin.';
        });
        return;
      }
      if (session.profile == null) {
        await db.auth.signOut();
        if (!mounted) return;
        setState(() {
          _loading = false;
          _error = 'Profil tidak ditemukan. Coba lagi.';
        });
        return;
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _pesanAuth(e);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Terjadi kesalahan. Periksa koneksi internet lalu coba lagi.';
      });
    }
  }

  void _gantiMode() {
    setState(() {
      _daftar = !_daftar;
      _error = null;
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
                        decoration: const InputDecoration(
                          labelText: 'Lokasi (kota)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => _wajib(v, 'Lokasi'),
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: _cekEmail,
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
                      validator: _cekPassword,
                    ),
                    if (_daftar) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Daftar sebagai',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: 'pencari',
                            label: Text('Pencari jasa'),
                          ),
                          ButtonSegment(
                            value: 'penyedia',
                            label: Text('Penyedia jasa'),
                          ),
                        ],
                        selected: {_role},
                        onSelectionChanged: (s) => setState(() => _role = s.first),
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _error!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _loading ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_daftar ? 'Daftar' : 'Masuk'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _loading ? null : _gantiMode,
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
