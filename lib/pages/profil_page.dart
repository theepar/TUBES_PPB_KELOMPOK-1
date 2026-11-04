import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/avatar_user.dart';
import '../pengguna.dart';
import '../services/app_session.dart';
import '../utils/app_colors.dart';
import '../utils/currency_formatter.dart';

String _labelRole(String role) {
  switch (role) {
    case 'penyedia':
      return 'Penyedia jasa';
    case 'admin':
      return 'Admin';
    default:
      return 'Pencari jasa';
  }
}

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<void> _konfirmasiKeluar(BuildContext context) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu perlu masuk lagi untuk memakai aplikasi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (ya == true) await AppSession.instance.keluar();
  }

  void _bukaEdit(BuildContext context, Pengguna profil) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _EditProfilSheet(profil: profil),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profil')),
      body: ListenableBuilder(
        listenable: AppSession.instance,
        builder: (context, _) {
          final session = AppSession.instance;
          final profil = session.profile;
          if (profil == null) {
            return const Center(child: Text('Kamu belum masuk'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Column(
                children: [
                  AvatarUser(
                    nama: profil.nama,
                    avatarPath: profil.avatarPath,
                    radius: 44,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profil.nama,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.skyLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _labelRole(profil.role),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  if (profil.lokasi.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 15,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          profil.lokasi,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppColors.track),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Saldo',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ),
                      Text(
                        formatRupiah(profil.saldo),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _bukaEdit(context, profil),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Profil'),
              ),
              if (session.isAdmin) ...[
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.track),
                  ),
                  child: SwitchListTile(
                    value: session.isAdminMode,
                    onChanged: (v) => session.isAdminMode = v,
                    title: const Text('Mode Admin'),
                    subtitle: Text(
                      session.isAdminMode
                          ? 'Aktif: menu pengelolaan ditampilkan'
                          : 'Tampilkan menu pengelolaan pembelian dan akun',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => _konfirmasiKeluar(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Keluar'),
                style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EditProfilSheet extends StatefulWidget {
  final Pengguna profil;

  const _EditProfilSheet({required this.profil});

  @override
  State<_EditProfilSheet> createState() => _EditProfilSheetState();
}

class _EditProfilSheetState extends State<_EditProfilSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nama;
  late final TextEditingController _lokasi;

  Uint8List? _fotoBaru;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nama = TextEditingController(text: widget.profil.nama);
    _lokasi = TextEditingController(text: widget.profil.lokasi);
  }

  @override
  void dispose() {
    _nama.dispose();
    _lokasi.dispose();
    super.dispose();
  }

  Future<void> _pilihFoto() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 512,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() => _fotoBaru = bytes);
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final db = Supabase.instance.client;
    final id = widget.profil.id;

    try {
      var path = widget.profil.avatarPath;
      if (_fotoBaru != null) {
        path = '$id.jpg';
        await db.storage.from('avatar').uploadBinary(
              path,
              _fotoBaru!,
              fileOptions: const FileOptions(
                contentType: 'image/jpeg',
                upsert: true,
              ),
            );
      }

      await db.from('profiles').update({
        'nama': _nama.text.trim(),
        'lokasi': _lokasi.text.trim(),
        'avatar_path': path,
      }).eq('id', id);

      await AppSession.instance.muatProfil(avatarBerubah: _fotoBaru != null);

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil diperbarui')),
      );
    } on StorageException catch (e) {
      _gagal('Foto gagal diunggah: ${e.message}');
    } on PostgrestException catch (e) {
      _gagal('Profil gagal disimpan: ${e.message}');
    } catch (_) {
      _gagal('Terjadi kesalahan. Periksa koneksi internet lalu coba lagi.');
    }
  }

  void _gagal(String pesan) {
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = pesan;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fotoBaru = _fotoBaru;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Edit Profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _loading ? null : _pilihFoto,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      if (fotoBaru != null)
                        CircleAvatar(
                          radius: 44,
                          backgroundImage: MemoryImage(fotoBaru),
                        )
                      else
                        AvatarUser(
                          nama: widget.profil.nama,
                          avatarPath: widget.profil.avatarPath,
                          radius: 44,
                        ),
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primary,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: _loading ? null : _pilihFoto,
                child: const Text('Ganti foto'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nama,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lokasi,
                decoration: const InputDecoration(
                  labelText: 'Lokasi (kota)',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(fontSize: 13, color: Colors.redAccent),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loading ? null : _simpan,
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
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
