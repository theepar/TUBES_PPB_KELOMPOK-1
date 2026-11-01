import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env.dart';
import '../pengguna.dart';

/// Sesi pengguna yang sedang login. Dipakai semua halaman untuk membaca
/// siapa user, role, dan apakah Mode Admin sedang aktif.
class AppSession extends ChangeNotifier {
  AppSession._();

  static final AppSession instance = AppSession._();

  Pengguna? _profile;
  bool _isAdminMode = false;

  Pengguna? get profile => _profile;
  bool get isLoggedIn => _profile != null;
  String? get userId => _profile?.id;

  bool get isAdmin => _profile?.role == 'admin';
  bool get isPenyedia => _profile?.role == 'penyedia';
  bool get isPencari => _profile?.role == 'pencari';

  bool get isAdminMode => _isAdminMode;

  /// Mode Admin hanya bisa menyala kalau user adalah admin.
  set isAdminMode(bool value) {
    final next = value && isAdmin;
    if (next == _isAdminMode) return;
    _isAdminMode = next;
    notifyListeners();
  }

  /// Baca ulang profil user yang sedang login. Kalau tidak ada sesi Supabase,
  /// state dikosongkan.
  Future<void> muatProfil() async {
    if (!Env.terisi) return;

    final db = Supabase.instance.client;
    final user = db.auth.currentUser;
    if (user == null) {
      _reset();
      return;
    }

    final row = await db.from('profiles').select().eq('id', user.id).maybeSingle();
    if (row == null) {
      _reset();
      return;
    }

    _profile = Pengguna.fromMap(row);
    if (!isAdmin) _isAdminMode = false;
    notifyListeners();
  }

  Future<void> keluar() async {
    if (Env.terisi) {
      await Supabase.instance.client.auth.signOut();
    }
    _reset();
  }

  void _reset() {
    _profile = null;
    _isAdminMode = false;
    notifyListeners();
  }
}
