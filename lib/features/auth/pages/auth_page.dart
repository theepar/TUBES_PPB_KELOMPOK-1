import 'package:flutter/material.dart';

import '../../../core/data/demo_store.dart';
import '../../../core/widgets/demo_ui.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _form = GlobalKey<FormState>();
  bool _register = false;
  bool _lihatPassword = false;
  String _nama = '', _email = '', _password = '', _lokasi = '';
  String? _wajib(String? v) =>
      v == null || v.trim().isEmpty ? 'Kolom ini wajib diisi' : null;

  void _masuk() {
    if (!_form.currentState!.validate()) return;
    jalankanAksi(context, () {
      if (_register) {
        DemoStore.instance.register(_nama, _email, _password, _lokasi);
      } else {
        DemoStore.instance.login(_email, _password);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                const Icon(
                  Icons.handshake_outlined,
                  size: 48,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'SewaSkill',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Temukan teman ahli untuk ide berikutnya.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.cardInset),
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _register ? 'Buat akun' : 'Masuk ke akunmu',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_register) ...[
                            TextFormField(
                              key: const ValueKey('auth-nama'),
                              decoration: const InputDecoration(
                                labelText: 'Nama',
                              ),
                              onChanged: (v) => _nama = v,
                              validator: _wajib,
                            ),
                            const SizedBox(height: AppSpacing.fieldGap),
                            TextFormField(
                              key: const ValueKey('auth-lokasi'),
                              decoration: const InputDecoration(
                                labelText: 'Lokasi',
                              ),
                              onChanged: (v) => _lokasi = v,
                              validator: _wajib,
                            ),
                            const SizedBox(height: AppSpacing.fieldGap),
                          ],
                          TextFormField(
                            key: const ValueKey('auth-email'),
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            onChanged: (v) => _email = v,
                            validator: Validators.email,
                          ),
                          const SizedBox(height: AppSpacing.fieldGap),
                          TextFormField(
                            key: const ValueKey('auth-password'),
                            obscureText: !_lihatPassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                tooltip: 'Lihat password',
                                icon: Icon(
                                  _lihatPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () => setState(
                                  () => _lihatPassword = !_lihatPassword,
                                ),
                              ),
                            ),
                            onChanged: (v) => _password = v,
                            validator: Validators.password,
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: _masuk,
                            child: Text(_register ? 'Daftar' : 'Masuk'),
                          ),
                          const SizedBox(height: AppSpacing.actionGap),
                          TextButton(
                            onPressed: () => setState(() {
                              _register = !_register;
                              _form.currentState?.reset();
                            }),
                            child: Text(
                              _register
                                  ? 'Sudah punya akun? Masuk'
                                  : 'Belum punya akun? Daftar',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Coba akun demo',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final role in ['pencari', 'penyedia', 'admin'])
                      OutlinedButton(
                        onPressed: () => jalankanAksi(
                          context,
                          () => DemoStore.instance.loginDemo(role),
                        ),
                        child: Text('Demo $role'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Demo saja. Semua perubahan hilang setelah aplikasi dimulai ulang.\nPassword akun contoh: demo123',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.inkSoft),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
